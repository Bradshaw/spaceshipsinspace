local dude_mt = {}
dude_mt.cooldown = 0.75
dude = {}

dude.all = {}

function dude.new(controller)
	local self = setmetatable({},{__index=dude_mt})
	dude.all[controller] = self
	self.cooling = 0
	self.controller = controller
	self.pos = vector.new(512,300)
	self.dir = vector.new()
	self.mov = vector.new()
	self.poly = polygon.new()
	self.poly:append(vector.new(5,5))
	self.poly:append(vector.new(5,-5))
	self.poly:append(vector.new(-5,-5))
	self.poly:append(vector.new(-5,5))
	self.poly:convexify()
	self.wep = true
	return self
end

function dude.update(dt)
	for k,v in pairs(dude.all) do
		v:update(dt)
	end
end


function dude_mt:update(dt)
	self.poly.transform:rotate(dt)
	self.dir.X = love.joystick.getAxis(self.controller,3)
	self.dir.Y = love.joystick.getAxis(self.controller,4)
	self.cooling = math.max(self.cooling-dt,0)
	if self.dir:magnitude()>0.3 then
		self.dir:normalise()
	else
		self.dir = self.mov:dup():normalise()
	end
	local intent = vector.new(love.joystick.getAxis(self.controller,1),love.joystick.getAxis(self.controller,2))
	if intent:magnitude()>0.2 then
		--intent:normalise()
		intent.X = intent.X*intent.X*useful.sign(intent.X)
		intent.Y = intent.Y*intent.Y*useful.sign(intent.Y)
		self.mov:add(intent:scale(dt*400))
	else
	end
	self.mov.X = self.mov.X-self.mov.X*dt*10
	self.mov.Y = self.mov.Y-self.mov.Y*dt*10
	self.pos.X = self.pos.X+self.mov.X*dt*10
	self.pos.Y = self.pos.Y+self.mov.Y*dt*10
	self.poly.transform.mat[3] = self.pos.X
	self.poly.transform.mat[6] = self.pos.Y
	self.poly:clearCache()
	for i,v in ipairs(level) do
		local c, vec, point = self.poly:collide(v)
		if c then
			vec:normalise()
			self.mov.X = self.mov.X+vec.X*30
			self.mov.Y = self.mov.Y+vec.Y*30
			self.mov.X = self.mov.X-self.mov.X*dt*10
			self.mov.Y = self.mov.Y-self.mov.Y*dt*10
		end
	end

	if (love.joystick.isDown(self.controller,6) or (love.joystick.getAxis(self.controller,5)>0)) and self.cooling<=0 then
		self.cooling=self.cooling+self.cooldown
		splosion.new(self.pos.X+self.dir.X*5,self.pos.Y+self.dir.Y*5,10)
		--flame.new(self.pos,self.dir)
		rail.new(self.pos,self.dir)
		--bullet.new(self.pos,self.dir)
		--rocket.new(self.pos,self.dir)
		shake = shake+0.4
	end
end

function dude.draw()
	for k,v in ipairs(dude.all) do
		v:draw()
	end
end

function dude_mt:draw()
	--love.graphics.rectangle("line",self.pos.X-4,self.pos.Y-4,8,8)
	self.poly:draw()
	--love.graphics.setColor(255,255,255)
	love.graphics.line(self.pos.X+self.dir.X*30,self.pos.Y+self.dir.Y*30,self.pos.X+self.dir.X*60,self.pos.Y+self.dir.Y*60)
end