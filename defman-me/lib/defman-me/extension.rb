# Require core library
require 'middleman-core'
require 'json'

# Extension namespace

module Middleman
  module Util
    
    module_function
    
    def asset_path(app, kind, source, options={})
      return source if source.to_s.include?('//') || source.to_s.start_with?('data:')

      asset_folder = case kind
      when :css
        app.config[:css_dir]
      when :js
        app.config[:js_dir]
      when :images
        app.config[:images_dir]
      when :fonts
        app.config[:fonts_dir]
      else
        kind.to_s
      end

      source = source.to_s.tr(' ', '')
      ignore_extension = (kind == :images || kind == :fonts) # don't append extension
      source << ".#{kind}?#{Time.new.to_i}" unless ignore_extension || source.end_with?(".#{kind}")
      asset_folder = '' if source.start_with?('/') # absolute path

      asset_url(app, source, asset_folder, options)
    end
  end
end

class DefmanMe < ::Middleman::Extension

  option :style, '...', 'Truncate style'

  def initialize(app, options_hash={}, &block)
    super
  end
  
  class Scheme
    @@colors = [
      [
        ["CommonStyles", "default_fixed", "back"],
        ["CommonStyles", "default_proportional", "back"]
      ],
      [
        ["CommonStyles", "default_fixed", "fore"],
        ["CommonStyles", "default_proportional", "fore"]
      ],
      [["CommonStyles", "comments", "fore"],],
      [["CommonStyles", "keywords", "fore"],],
      [["CommonStyles", "strings", "fore"],],
      [["CommonStyles", "classes", "fore"],],
      [
        ["CommonStyles", "variables", "fore"],
        ["LanguageStyles", "Python", "variables", "fore"],
        ["LanguageStyles", "Ruby", "variables", "fore"],
        ["LanguageStyles", "Tcl", "variables", "fore"],
        ["LanguageStyles", "PHP", "variables", "fore"]
      ],
      [["CommonStyles", "numbers", "fore"],],
      [["CommonStyles", "operators", "fore"],],
      [["CommonStyles", "identifiers", "fore"],]
    ]
    
    def parse_ksf(name)
        require 'tempfile'
        require 'open-uri'
        require 'json'

        file = Tempfile.new "ksf"
        file.close

        stream = open File.join(__dir__, "../../../data/schemes/#{name}.ksf")

        IO.copy_stream stream, file.path


        exporter = <<-eos

import json
export = locals()
_export = {}
for l in export.keys():
    if l in ["export", "_export"]:
        continue
    if isinstance(export[l],dict):
        _export[l] = export[l]
print json.dumps(_export)
        eos

        file = open file.path, "a"
        file.write exporter
        file.close

        return `python2 #{file.path}`
    end

  
    def initialize(ksf)
      begin
        ksf = JSON.parse(parse_ksf(ksf))
      rescue Exception => e
        puts "Parsing KSF failed: #{e}"
        @ready = false
        return
      end
  
      if ksf.has_key? "exports"
        ksf = ksf["exports"]
      end
  
      @ksf = ksf
  
      @fg = []
      @@colors.each do |options|
          options.each do |option|
              c = self.get(option, ksf)
              if c
                  @fg.push self.hex(c)
                  break
              end
          end
      end
      @bg = @fg.shift
      @ready = true
    end
  
    def ready
      @ready
    end
  
    def bg
      @bg
    end
  
    def fg
      @fg
    end
  
    def hex(value)
      value = ((value & 0xFF0000) >> 16) +
          (value & 0x00FF00) +
         ((value & 0xFF) << 16)
      return "#" + ("0" + ((value & 0xFF0000) >> 16).to_s(16))[-2..-1] +
               ("0" + ((value &   0xFF00) >>  8).to_s(16))[-2..-1] +
               ("0" + ((value &   0xFF)   >>  0).to_s(16))[-2..-1]
    end
  
    def get(select, ob = false)
      unless ob
        ob = @ksf
      end
      r = ob
      select.each() do |k|
        unless r.has_key? k
          return false
        end
        r = r[k]
      end
      return r
    end
  
    def color(select)
      c = self.get(select)
      unless c
        return ""
      end
  
      return self.hex(c)
    end
  
    def color_for(key, language, default = "default_fixed", style = "fore")
      c = self.get(["LanguageStyles", language, key, style])
  
      unless c
        c = self.get(["CommonStyles", key, style])
      end
  
      unless c
        c = self.get(["CommonStyles", default, style])
      end
      
      unless c
        ""
      end
  
      return self.hex(c)
    end
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
    
    def ksf(name)
      Scheme.new(name)
    end
  end
end