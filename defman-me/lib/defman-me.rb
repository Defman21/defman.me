require "middleman-core"
require "nokogiri"
require "rumoji"

Middleman::Extensions.register :defmanme do
  require "defman-me/extension"
  DefmanMe
end

module Emojiware
  class Rumojiware
    def initialize(app)
      @app = app
    end
    
    def call(env)
      call! env
    end
    
    def call!(env)
      @env = env.dup
      status, @headers, response = @app.call @env
      
      if emojify?
        @headers.delete "Content-Length"
        
        res = Rack::Response.new(
          emojify(response.respond_to?(:body) ? response.body : response),
          status,
          @headers
        )
        
        res.finish
        res.to_a
      else
        [status, @headers, response]
      end
    end
    
    def emojify?
      @headers["Content-Type"] &&
      @headers["Content-Type"].include?("text/html")
    end
    
    def emojify(content)
      html = Nokogiri::HTML content.join ""
      html.css(".content > p").each do |p|
        p.inner_html = Rumoji.decode p.inner_html
      end
      html.to_html
    end
  end
end