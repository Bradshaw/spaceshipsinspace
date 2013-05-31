local state = gstate.new()


function state:init()
	p = polygon.new()
	for i=1,20 do
		p:append(vector.new(math.random(-100,100),math.random(-100,100)))
	end
	p:convexify()
	p.transform:translate(love.graphics.getWidth()/2,2*love.graphics.getHeight()/3)
	spawnshape()
	axis = vector.new(1,1)
	axis:normalise()
	sstoggle = false
	move = vector.new(0,0)
	ang = 0
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

function spawnshape( ... )
	d = polygon.new()
	for i=1,10 do
		d:append(vector.new(math.random(-50,50),math.random(-50,50)))
	end
	d:convexify()
	--d.transform = matrix.new()
	d.transform:translate(love.graphics.getWidth()/2,-50)
	d.transform:rotate(math.random()*math.pi*2)
	ang=0
	move = vector.new(0,0)
end

function state:keypressed(key, uni)
	if key=="escape" then
		love.event.push("quit")
	end
	if key == " " then
		spawnshape()
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
		--sstoggle = false
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
	c,v,con = p:collide(d)
	if c then
		d.transform:translate_global(v.X,v.Y)
		pvec = vector.new(-(d.transform.mat[6]-con.Y),(d.transform.mat[3]-con.X))
		pvec:normalise()
		ang = ang + pvec:dot(v)/30
		move.X=(move.X+v.X/2)
		move.Y=(move.Y+v.Y/2)
	end
	move.Y=move.Y+dt*10
	d.transform:translate_global(move.X,move.Y)
	d.transform:rotate(ang)
	if d.transform.mat[3]<-50 or d.transform.mat[3]>love.graphics.getWidth()+50 or d.transform.mat[6]>love.graphics.getHeight()+50 then
		spawnshape()
	end
end


function state:draw()
	p:draw()
	d:draw()
	love.graphics.point(p.transform.mat[3],p.transform.mat[6])
	love.graphics.point(d.transform.mat[3],d.transform.mat[6])
	if c then
		--love.graphics.print(con.X.." "..con.Y,10,10)
		--love.graphics.line(con.X,con.Y,con.X+v.X*100,con.Y+v.Y*100)
		--love.graphics.line(con.X,con.Y,con.X-v.X*100,con.Y-v.Y*100)
		--love.graphics.line(con.X,con.Y,con.X + pvec.X*100,con.Y+pvec.Y*100)
	end

	if sstoggle then
		local ss = love.graphics.newScreenshot()
		ss:encode("collider"..string.format("%04d",frame)..".png")
	end

end

return state

