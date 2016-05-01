require "middleman-core"

Middleman::Extensions.register :ellipses do
  require "middleman-ellipses/extension"
  Ellipses
end
