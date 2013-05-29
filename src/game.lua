local state = gstate.new()


function state:init()
	p = polygon.new()
	for i=1,20 do
		p:append(vector.new(math.random(-100,100),math.random(-100,100)))
	end
	p:convexify()
	p.transform:translate(2*love.graphics.getWidth()/3,2*love.graphics.getHeight()/3)
	d = polygon.new()
	for i=1,20 do
		d:append(vector.new(math.random(-100,100),math.random(-100,100)))
	end
	d:convexify()
	axis = vector.new(1,1)
	axis:normalise()
	sstoggle = false
	frame = 0
	time = 0
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
	if key == " " then
		axis = vector.new(math.random(),math.random())
		axis:normalise()
	end
	if key == "p" then
		sstoggle = true
		frame = 0
		time = 0
	end
end


function state:keyreleased(key, uni)
	
end


function state:update(dt)
	time = time+dt
	frame = frame + 1
	if sstoggle and time>=math.pi*2 then
		sstoggle = false
	end
	if love.keyboard.isDown("left") then
		d.transform:translate(-dt*100,0)
	end
	if love.keyboard.isDown("right") then
		d.transform:translate(dt*100,0)
	end
	if love.keyboard.isDown("up") then
		d.transform:translate(0,-dt*100)
	end
	if love.keyboard.isDown("down") then
		d.transform:translate(0,dt*100)
	end
	p.transform:rotate(dt)
end


function state:draw()
	if p:collide(d) then
		love.graphics.setColor(255,0,0)
	else
		love.graphics.setColor(127,127,127)
	end
	p:draw()
	d:draw()

	--[[]]
	if p:collideAABB(d) then
		love.graphics.setColor(255,0,0)
	else
		love.graphics.setColor(127,127,127)
	end
	local x,y,X,Y = p:getAABB()
	love.graphics.rectangle("line",x,y,X-x,Y-y)
	x,y,X,Y = d:getAABB()
	love.graphics.rectangle("line",x,y,X-x,Y-y)
	--]]

	if sstoggle then
		local ss = love.graphics.newScreenshot()
		ss:encode("collider"..string.format("%04d",frame)..".png")
	end

end

return state

