page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false
page "materia.html", layout: false

page 'projects/index.html', layout: :layout
page 'projects/*', layout: :project
page 'schemes/index.html', layout: :layout
page 'schemes/*', layout: :scheme
page 'blog/index.html', layout: :layout
page 'blog/*', layout: :blog


set :index_file, "index.html"
set :markdown, fenced_code_blocks: true, smartypants: true, prettify: true
set :markdown_engine, :redcarpet

configure :build do
  activate :minify_css
  activate :minify_javascript
end

activate :deploy do |deploy|
  deploy.deploy_method = :git
  deploy.build_before = true
end

activate :livereload
activate :directory_indexes
activate :ellipses
