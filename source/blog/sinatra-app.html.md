---
title: Sinatra + Rack + Rake + ActiveRecord
description: How to build an application with Sinatra, Rack and ActiveRecord?
date: 201605101630
id: 201605101630-create-sinatra-app
comments: on
links:
    Simple Sinatra App:
        href: //github.com/Defman21/simple-sinatra-app
        fa: github
---

Building an application with Ruby is pretty interesting (at least for me).
You can use Rails if you want to do it fast or you can use Sinatra if you're
interested in building a very lightweight REST API application.

This article should help you create a simple Sinatra RESTFUL application with
Rack tasks for ActiveRecord and Rake.

# Creating a structure

In my project, I use this structure for the application:

```
.
├── apps
│   └── # your applications here
├── config.ru # Our Rack config
├── db
│   ├── config.yml # ActiveRecord database configuration
│   ├── migrate
│   │   └── # Migrations
│   └── schema.rb
├── environment.db
├── Gemfile
├── models
│   └── # Our ActiveRecord models (Bases) here
└── Rakefile # Our Rake tasks
```

Moving next!

# Gemfile

We need `sinatra`, `sinatra-contrib`, `activerecord`, `rake`, `rack` and
`logger` in our project and `slite3` or other driver for database.

```ruby
source 'https://rubygems.org'

gem 'sinatra'
gem 'sinatra-contrib'
gem 'activerecord'
gem 'sqlite3'
gem 'rake'
gem 'rack'
gem 'logger'
```

Run `bundle` to install the gems.

# Rakefile

If you want to use ActiveRecord tasks with Sinatra, you have to configure
Rackfile. It's not very hard and you don't have to install any extensions
(like `sinatra-activerecord`).

```ruby
require 'yaml'
require 'logger'
require 'active_record'

include ActiveRecord::Tasks

class Seeder
  def initialize(seed)
    @seed = seed
  end

  def load_seed
    raise "Seed file '#{@seed}' does not exist" unless File.file? @seed
    load @seed_file
  end
end


root = File.expand_path '..', __FILE__
DatabaseTasks.env = ENV['ENV'] || 'development'
conf = File.join root, 'db/config.yml'
DatabaseTasks.database_configuration = YAML.load(File.read(conf))
DatabaseTasks.db_dir = File.join root, 'db'
DatabaseTasks.fixtures_path = File.join root, 'test/fixtures'
DatabaseTasks.migrations_paths = [File.join(root, 'db/migrate')]
DatabaseTasks.seed_loader = Seeder.new File.join root, 'db/seeds.rb'
DatabaseTasks.root = root

task :environment do
  ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
  ActiveRecord::Base.establish_connection DatabaseTasks.env.to_sym
end

load 'active_record/railties/databases.rake'
```

Now if you run `rake -T`, you should get the similar output:

```
rake db:create              # Creates the database from DATABASE_URL or con...
rake db:drop                # Drops the database from DATABASE_URL or confi...
rake db:fixtures:load       # Load fixtures into the current environment's ...
rake db:migrate             # Migrate the database (options: VERSION=x, VER...
rake db:migrate:status      # Display status of migrations
rake db:rollback            # Rolls the schema back to the previous version...
rake db:schema:cache:clear  # Clear a db/schema_cache.dump file
rake db:schema:cache:dump   # Create a db/schema_cache.dump file
rake db:schema:dump         # Create a db/schema.rb file that is portable a...
rake db:schema:load         # Load a schema.rb file into the database
rake db:seed                # Load the seed data from db/seeds.rb
rake db:setup               # Create the database, load the schema, and ini...
rake db:structure:dump      # Dump the database structure to db/structure.sql
rake db:structure:load      # Recreate the databases from the structure.sql...
rake db:version             # Retrieves the current schema version number
```

It's truncated to 80 chars, but if you just see `rake db:` - then you're good.

Now we should add a config file for our ActiveRecord connection.

# ActiveRecord config file

It's placed at `db/config.yml` and here's how it looks:

```yaml
development:
    adapter: sqlite3
    database: development.db
    pool: 5
    timeout: 5000
```

For better explanation, you should have a look at the official documentation.

Next we should create migrations for our app.

# Migrations

In this tutorial, we will create `users` table with `001_create_users.rb`
migration placed in `db/migrate/`.

```ruby
class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :email
    end
  end
  
  def down
    drop_table :users
  end
end
```

This code will create the `users` table when migrating.

Run `rake db:migrate` to execute migrations.

We have prepared everything, so now we're gonna create an application!

# Creating the application

At first, let's create our Rack file (`config.ru`)

```ruby
require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/reloader'

require 'active_record'
require 'yaml'
require 'json'

class BaseApp < Sinatra::Base
  
  # Register custom extensions
  
  configure :development do
    register Sinatra::Reloader
  end
  
  # Configure ActiveRecord
  
  env    = ENV['ENV'] || 'development'
  root   = File.expand_path '..', __FILE__
  config = YAML.load(File.read(File.join(root, 'db/config.yml')))
  
  ActiveRecord::Base.configurations = config
  ActiveRecord::Base.establish_connection env.to_sym
  
  # Create @body variable
  
  before do
    if request.content_length.to_i > 0
      request.body.rewind
      @body = JSON.parse request.body.read, symbolize_names: true
    end
  end
end

Dir.glob("./models/*.rb").sort.each do |file|
  require file
end

Dir.glob("./apps/*.rb").sort.each do |file|
  require file
end

map "/" do
  run RootApp
end
```

So, what's going on there?

1. At first, we require our dependencies.
2. We create a new instance of `Sinatra::Base`, which contains some settings
and ActiveRecord connection initialization which our `apps/` uses.
3. Next, because we're creating a RESTFUL API, we should accept request body
and parse it. This is the `before` block, which invokes by Sinatra before the
active route. (so if an user call `/route`, Sinatra executes `before` and
then the route).
4. `Dir.glob` loads our models and apps. Models are loading first because
Apps depends on them.
5. `map` is some sort of namespaces, we could add more `map` to run different
apps on these urls, so if you add `map '/users/ do ... end`, Rack will run the
code defined in the block for `/users/*` url.

In the code, `map` binds `/` to run RootApp. Let's take a look how `RootApp`
looks.

**Path:** `apps/root.rb`

```ruby
class RootApp < BaseApp
  get "/" do
    @user = User.find_by id: @body[:id]
    if @user
      json response: {
        status: :ok,
        errors: [],
        data: @user,
        request: params,
        redirect: nil
      }
    else
      json response: {
        status: :fail,
        errors: [
          "User #{params[:id]} does not exist"
        ],
        data: [],
        request: params,
        redirect: nil
      }
    end
  end
  
  post '/' do
    @user = User.create username: @body[:username],
                        password: @body[:password],
                        email: @body[:email]
    if @user.valid?
      json response: {
        status: :ok,
        errors: [],
        data: @user,
        request: @body,
        redirect: "/#{@user.id}"
      }
    else
      json response: {
        status: :fail,
        errors: @user.errors,
        data: [],
        request: @body,
        redirect: "/"
      }
    end
  end
end
```

class `RootApp` extends `BaseApp`, so we don't have to re-initialize
ActiveRecord connection and register extensions again.

`get` and `post` methods are bindings for `GET /` and `POST /` requests.

`get` Accepts JSON body with `id` parameter in it and it's using ActiveRecord
to find the user by ID. If user with this ID does not exist, we response with
JSON contains `errors` key, but if it does exist, we just return the data.

`post` uses the same ideology as `get` for responding, but in this method
we're creating a new User instance using ActiveRecord::Base class (`User`).

Let's take a look at it!

**Path:** `models/user.rb`

```ruby
class User < ActiveRecord::Base
  validates :username, length: {
    minimum: 6,
    maximum: 35,
  }, uniqueness: true
  
  validates :password, format: {
    with: /\A[a-zA-Z0-9!@#\$%^&\(\)]+\z/,
    message: "only allows a-z, 0-9 and !@#$%^&*()"
  }
end
```

As you can see, there are no new methods defined, but I've
added some validations:

1. Username should have 6-35 characters and be unique.
2. Password should contain only a-z, 0-9 and !@#$%^&*().

You can add validation for `:email` field as well, but the best
validation for e-mail is sending a mail to it with a confirmation link.

And... we're done! Now you should able to run your application with
`rackup -p 3000`.

 * To create an user, send POST request to `localhost:3000/` with credentials.
 * To view an user, send GET request to `localhost:3000/` with ID of the user.
 
You could try to send invalid data or non-existent ID to see if it works
(it should give you a JSON response contains `errors` key with some data
inside and the empty `data` array).

If you have any questions, feel free to ask them in the comments!