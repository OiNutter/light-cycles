function love.conf(t)
	t.identity = "Light Cycle"
	t.window.title = t.identity
	t.version = "0.10.2"
  t.window.width = 400        -- we want our game to be long and thin.
  t.window.height = 400

  -- For Windows debugging
  t.console = true
end
