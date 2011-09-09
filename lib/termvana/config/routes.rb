# Check out https://github.com/joshbuddy/http_router for more information on HttpRouter
HttpRouter.new do
  add('/').to(HomeAction)
end

HttpRouter.new do
  add('/socket').to(WebsocketAction)
end

