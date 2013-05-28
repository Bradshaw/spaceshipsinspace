local state = gstate.new()


function state:init()
	p = polygon.new()
	p:append(vector.new(-100,-100))
	p:append(vector.new(-100,100))
	p:append(vector.new(100,100))
	p:append(vector.new(100,-100))
	p.transform:translate(512,300)
	time = 0
	frame = 0
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
end


function state:keyreleased(key, uni)
	
end


function state:update(dt)
	frame = frame+1
	time = time + dt
	if time>1 then
		--p.transform.mat[3]=p.transform.mat[3]+100
		time=time-1
	end
	p.transform:rotate(dt)
end


function state:draw()
	p:draw()
end

return state

