###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout
page 'blog/index.html', layout: :layout
page 'blog/*', layout: :blog
page "index.html", layout: false
page "materia.html", layout: false
page "contact.html", layout: false

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# General configuration

###
# Helpers
###

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

# Build-specific configuration
configure :build do
  # Minify CSS on build
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

end

activate :livereload

activate :directory_indexes

set :index_file, "index.html"
set :markdown, fenced_code_blocks: true, smartypants: true, prettify: true
set :markdown_engine, :redcarpet

activate :ellipses
