require "middleman-core"

Middleman::Extensions.register :defmanme do
  require "defman-me/extension"
  DefmanMe
end
