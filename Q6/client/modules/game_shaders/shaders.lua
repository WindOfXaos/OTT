function init()
	-- Apply dash shaders after pressing F key
	g_keyboard.bindKeyPress("F", function()
		local player = g_game.getLocalPlayer()

		local dashShader = g_shaders.createShaders("Dash", "shaders/dash.frag", "shaders/dash.vert")
		player:setShader(dashShader)

		-- Set default shaders after 300ms to remove dashing effects
		scheduleEvent(undash, 300)
	end)
end

function undash()
	local player = g_game.getLocalPlayer()
	local defaultShader =
		g_shaders.createShaders("Default", "shaders/default/default.frag", "shaders/default/default.vert")
	player:setShader(defaultShader)
end