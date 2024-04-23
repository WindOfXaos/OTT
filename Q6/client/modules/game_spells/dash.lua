function init()
	-- Trigger dashing with F key
	g_keyboard.bindKeyDown("F", function()
		g_game.talk("!dash")
	end)

	-- Turn around without movement
	g_keyboard.bindKeyDown("W", function()
		g_game.turn(North)
	end)
	g_keyboard.bindKeyDown("S", function()
		g_game.turn(South)
	end)
	g_keyboard.bindKeyDown("D", function()
		g_game.turn(East)
	end)
	g_keyboard.bindKeyDown("A", function()
		g_game.turn(West)
	end)
end