# Require core library
require 'middleman-core'

# Extension namespace
class DefmanMe < ::Middleman::Extension

  option :style, '...', 'Truncate style'

  def initialize(app, options_hash={}, &block)
    super
  end

  helpers do
    def truncate_with_ellipses(string, length)
      opts = extensions[:defmanme].options
      if string.length > length
        string[0..length].gsub(/[^\w]\w+\s*$/, opts.style)
      else
        string
      end
    end
    
    def children(dir)
      sitemap.resources.select do |resource|
        resource.path.start_with?(dir)
      end
    end
  end
end
