local state = gstate.new()


function state:init()
	p = polygon.new()
	p:append(vector.new(-100,-100))
	p:append(vector.new(-100,100))
	p:append(vector.new(100,100))
	p:append(vector.new(100,-100))
	p:append(vector.new(-100,-100))
	for i=1,10 do
		p:append(vector.new(math.random(-100,100),math.random(-100,100)))
	end
	p.transform:scale(0.5,0.5)
	p:applyTransform()
	p.transform:translate(512,300)
	d = polygon.new()
	d:append(vector.new(-15,-30))
	d:append(vector.new(-15,30))
	d:append(vector.new(15,30))
	d:append(vector.new(15,-30))
	d:append(vector.new(-15,-30))
	for i=1,10 do
		d:append(vector.new(math.random(-15,15),math.random(-30,30)))
	end
	d.transform:translate(65,30)
	d:applyTransform()
	d.transform=p.transform
	b = polygon.new()
	b:append(vector.new(-15,-30))
	b:append(vector.new(-15,30))
	b:append(vector.new(15,30))
	b:append(vector.new(15,-30))
	b:append(vector.new(-15,-30))
	for i=1,10 do
		b:append(vector.new(math.random(-15,15),math.random(-30,30)))
	end
	b.transform:translate(-65,30)
	b:applyTransform()
	b.transform=p.transform
	rval = math.random(1,4)
	time = 0
	gtime = 0
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
	gtime = gtime+1
	time = time + dt*10
	if time>1 then
		time = time - math.random()*2
		rval = math.random(1,4)
	end
	if rval==1 then
		p.transform:rotate(dt*1.5)
	end
	if rval==2 then
		p.transform:rotate(-dt*1.5)
	end
	if rval==3 then
		p.transform:translate(0,-dt*150)
	end
	if rval==4 then
		p.transform:translate(0,dt*150)
	end
end


function state:draw()
	love.graphics.setColor(useful.hsv(gtime*rval,100,100))
	love.graphics.setLine(math.sin(rval*time)*1+2)
	p:draw()
	d:draw()
	b:draw()
	love.graphics.setColor(useful.hsv(gtime*rval,25,100))
	love.graphics.setLine(math.sin(rval*time)+0.5)
	p:draw()
	d:draw()
	b:draw()
end

return state

