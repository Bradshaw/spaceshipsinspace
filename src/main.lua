function love.load(arg)
	gstate = require "gamestate"
	game = require("game")
	require("useful")
	require("rkvalue")
	require("vector")
	require("matrix")
	require("polygon")
	require("module")
	require("dude")
	require("bullet")
	require("rail")
	require("rocket")
	require("flame")
	require("level")
	require("splosion")
	--[[]
	music = love.audio.newSource("audio/music_knives.ogg")
	music:setLooping(true)
	music:play()
	--]]
	gstate.switch(game)
end


function love.focus(f)
	gstate.focus(f)
end

function love.mousepressed(x, y, btn)
	gstate.mousepressed(x, y, btn)
end

function love.mousereleased(x, y, btn)
	gstate.mousereleased(x, y, btn)
end

function love.joystickpressed(joystick, button)
	gstate.joystickpressed(joystick, button)
end

function love.joystickreleased(joystick, button)
	gstate.joystickreleased(joystick, button)
end

function love.quit()
	gstate.quit()
end

function love.keypressed(key, uni)
	gstate.keypressed(key, uni)
end

function keyreleased(key, uni)
	gstate.keyreleased(key)
end
local max_dt = 1/40
function love.update(dt)
	gstate.update(math.min(dt,max_dt))
end

function love.draw()
	gstate.draw()
end
