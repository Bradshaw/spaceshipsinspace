local state = gstate.new()


function state:init()
	axis = vector.new(1,1)
	axis:normalise()
	sstoggle = false
	move = vector.new(0,0)
	ang = 0
	frame = 0
	time = 0
	h = math.random()*360
	for i=1,love.joystick.getNumJoysticks() do
		dude.new(i)
	end
	print(love.joystick.getNumJoysticks())
	level.new()
	wobbles = 0
	shake = 0
end


function state:enter()

end


function state:focus()

end


function state:mousepressed(x, y, btn)
end


function state:mousereleased(x, y, btn)
	
end


function state:joystickpressed(joystick, button)
	
end


function state:joystickreleased(joystick, button)
	
end


function state:quit()
	
end

function state:keypressed(key, uni)
	if key=="escape" then
		love.event.push("quit")
	end
	if key == "p" then
		sstoggle = not sstoggle
		frame = 0
		time = 0
	end
end


function state:keyreleased(key, uni)
	
end


function state:update(dt)
	h = h+dt*10
	wobbles = wobbles + dt
	shake = math.max(0,shake - shake*dt*10)
	level.update(dt)
	dude.update(dt)
	bullet.update(dt)
	rail.update(dt)
	splosion.update(dt)
	time = time+dt
	frame = frame + 1
	move.Y=move.Y+dt*10
end


function state:draw()
	love.graphics.setBackgroundColor(useful.hsv(h,15,20))
	love.graphics.setColor(useful.hsv(h+180,15,80))
	love.graphics.setLine(1,"rough")
	love.graphics.push()
	--shake = 0
	love.graphics.translate(love.graphics.getWidth()/2,love.graphics.getHeight()/2)
	love.graphics.translate(math.sin(wobbles*321)*2*shake,math.sin(wobbles*450)*2*shake)
	love.graphics.rotate((math.sin(wobbles*264)/100)*shake)
	love.graphics.translate(math.sin(wobbles*432)*2*shake,math.sin(wobbles*654)*2*shake)
	love.graphics.translate(-love.graphics.getWidth()/2,-love.graphics.getHeight()/2)
	--love.graphics.translate(-dude.all[1].pos.X,-dude.all[1].pos.Y)
	level.draw()
	dude.draw()
	bullet.draw()
	rail.draw()
	splosion.draw()

	if sstoggle then
		local ss = love.graphics.newScreenshot()
		ss:encode("movement"..string.format("%04d",frame)..".png")
	end
	love.graphics.pop()
	love.graphics.print(love.timer.getFPS(),10,10)
end

return state

