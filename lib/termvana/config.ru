require 'termvana-defaults'

Termvana::Application.initialize!
# Development middlewares
if Termvana::Application.rack_env == 'development'
  use AsyncRack::CommonLogger


  # Enable code reloading on every request
  use Rack::Reloader, 0

  # Serve assets from /public
  # use Rack::Static, :urls => ["/css", "/images", "/js"], :root => Termvana::Application.root(:public)
end

if Termvana::Application.rack_env == 'test'
  # use AsyncRack::CommonLogger
  # Serve assets from /public
  # use Rack::Static, :urls => ["/css", "/images", "/js"], :root => Termvana::Application.root(:public)
end

# Running thin :
#
#
#   bundle exec thin --max-persistent-conns 1024 --timeout 0 -R config.ru start
#
# Vebose mode :
#
#   Very useful when you want to view all the data being sent/received by thin
#
#   bundle exec thin --max-persistent-conns 1024 --timeout 0 -V -R config.ru start
#
map("/assets") do
  run Termvana::Application.assets
end

map("/") do
  run Termvana::Application.routes
end



