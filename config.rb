page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

page 'projects/index.html', layout: :layout
page 'projects/*', layout: :project
page 'schemes/index.html', layout: :layout
page 'schemes/*', layout: :scheme
page 'blog/index.html', layout: :layout
page 'blog/*', layout: :blog

ignore '/blog/pages/page.html'

page '404.html', directory_index: false

set :index_file, "index.html"

activate :syntax
set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true, prettify: true
set :site_url, "http://dev.defman.me:4567"

set :fonts_dir, "assets/fonts"
set :images_dir, "assets/images"
set :js_dir, "assets/javascripts"
set :css_dir, "assets/stylesheets"
set :layouts_dir, "assets/layouts"

configure :build do
  activate :minify_css
  activate :minify_javascript
end

activate :deploy do |deploy|
  deploy.deploy_method = :git
  deploy.build_before = true
end

ready do
  $blogs = 5
  blogs = sitemap.resources.select do |p|
    if p.metadata[:options][:layout] == :blog and p.source_file.include? "md"
      true
    end
    false
  end
  offset = 0
  if blogs.length > $blogs
    first, last = false, false
    for page in 0..blogs.length.div($blogs)
      _blogs = blogs[offset, $blogs]
      _next_blogs = blogs[offset+$blogs, $blogs]
      if _next_blogs.nil? or _next_blogs.length == 0
        last = true
      end
      if offset == 0
        first = true
      else
        first = false
      end
      proxy "/blog/pages/#{page+1}.html", "/blog/pages/page.html", locals: {
        first: first,
        last: last,
        page: page+1,
        blogs: _blogs
        }, ignore: true
      if last
        break
      end
      offset += $blogs
    end
  end
end

activate :livereload, host: "dev.defman.me"
activate :directory_indexes
activate :defmanme
