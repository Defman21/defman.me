guard 'livereload', host: '127.0.0.1', grace_period: 0.5 do
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
  }

  extensions.each do |ext, type|
    watch %r{/assets/([^\.]+)(?:\.#{ext})(?:\.\w+|$)} do |m|
      "/assets/#{m[1]}.#{type}"
    end
    watch %r{data/.+}
    watch %r{source/(?:(blog|projects|partials|schemes)/)?.+\.(slim|md)$}
  end
end
