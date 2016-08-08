---
title: Livereload and Hanami
description: A guide how to make LiveReload work in Hanami
date: 201608052115
id: 201608052115-hanami-love-livereload
tags: hanami livereload ruby
---

I've spent a lot of time trying to figure out how to make LiveReload work in
Hanami.

# Installing LiveReload

Add that to your `Gemfile`:

```ruby
gem 'guard'
gem 'guard-livereload', '~> 2.5', require: false
gem 'rack-livereload' # if you don't want to use browser extension
```

Then run `bundle install`.

# Preparing Guard for watching our files

By default, `guard-livereload` is targeted for RoR. We should change `Guardfile`
to:

```ruby
guard 'livereload' do
  extensions = {
    css: :css,
    scss: :css,
    sass: :css,
    js: :js,
    coffee: :js,
    html: :html,
    png: :png,
    gif: :gif,
    jpg: :jpg,
    jpeg: :jpeg,
    # less: :less, # uncomment if you want LESS stylesheets done in browser
  }

  extensions.each do |ext, type|
    watch(%r{
          (?:apps) # /apps/
          (?:/\w+/assets/\w+/(?<path>[^.]+) # /apps/<app_name>/assets/<folder>/<file>
           (?<ext>\.#{ext})) # matching extension (must be first encountered)
          (?:\.\w+|$) # other extensions
          }x) do |m|
      path = m[1]
      "/assets/#{path}.#{type}" # Hanami puts compiled assets in development env here
    end
  end
end
```

This config make Guard watch for `./apps/<app_name>/assets/<folder>/<file>`.
Once something will be changed there, `guard-livereload` will sent a `RELOAD`
signal to our browser: `RELOAD /assets/<file>`.

# Enabling LiveReload

## Browser extension (preferred)

Install the corresponding extension for your browser:

* [Chrome](https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei)
* [Firefox](https://addons.mozilla.org/en-US/firefox/addon/livereload/)

You can find more ways to install it on the [official website](//livereload.com).

## Rack gem

Add this code to `/config.ru` before `run Hanami::Container.new`:

```ruby
require 'rack-livereload'
use Rack::LiveReload
```

This will enable `rack-livereload` globally.

### Fixing Content Security Policy

If you run `guard` and `hanami server` and try to open your site, you'll see
Content Security Policy error in your console. The problem here is `guard` will
host it's own `livereload.js` at `localhost:35729` and `rack-livereload` will be
trying to inject it. But `hanami` does not allow including scripts and
connecting to WebSockets from external resources.

We'll change CSP to allow loading inline scripts and scripts from `localhost:35729`.

Change `security.content_security_policy %{...}` in `apps/<app>/application.rb` to:

```ruby
security.content_security_policy %{
  ...
  script-src 'self' http://localhost:35729/ 'unsafe-inline';
  connect-src 'self' ws://localhost:35729/;
  ...
}
end
```

We allowed inline scripts because `rack-livereload` injects some variables in
this way for `livereload.js`
(such as `RACK_LIVERELOAD_PORT` and `WEB_SOCKET_SWF_LOCATION`).

We allowed scripts from `localhost:35729` and connections to `localhost:35729`.
`livereload.js` will be trying to connect to `ws://localhost:35729`. That's why
we allow to do it in CSP.

# Testing LiveReload

Run `guard` and `hanami server`. Open `localhost:2300` and change any resource
(a css file for example). Your changes should be applied immediately.

If you're using the extension for browser, don't forget to connect to the
livereload server by clicking on the toolbar button.

Have fun! :)