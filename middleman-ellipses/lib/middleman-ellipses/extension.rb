# Require core library
require 'middleman-core'

# Extension namespace
class Ellipses < ::Middleman::Extension

  option :style, '...', 'Truncate style'

  def initialize(app, options_hash={}, &block)
    super
  end

  helpers do
    def truncate_with_ellipses(string, length)
      opts = extensions[:ellipses].options
      if string.length > length
        string[0..length].gsub(/[^\w]\w+\s*$/, opts.style)
      else
        string
      end
    end
  end
end
