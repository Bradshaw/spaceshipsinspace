local splosion_mt = {}
splosion_mt.decay = 100
splosion_mt.time = 1
splosion = {}

splosion.all = {}

function splosion.new(x,y,radius,damaging)
	local self = setmetatable({},{__index=splosion_mt})
	self.x = x
	self.y = y
	self.radius = radius or 50
	self.damaging = damaging
	self.poly = polygon.new()
	local i = math.random()
	while i < math.pi*2*2 do
		local a = i
		local d = self.radius/2+math.random()*self.radius
		local xn = math.cos(a)
		local yn = math.sin(a)
		if damaging then
			flame.new(vector.new(x+xn*d,y+yn*d),vector.new(xn,yn))
		end
		self.poly:append(vector.new(xn*d,yn*d))
		i=i+math.random()
	end
	for i,v in ipairs(dude.all) do
		local dx = self.x - v.pos.X
		local dy = self.y - v.pos.Y
		local d2 = dx*dx+dy*dy
		if d2<(self.radius*self.radius) then
			if not (self.shooter==v) then
				local pow = ((self.radius*self.radius)-d2)/(self.radius*self.radius)
				local d = math.sqrt(d2)
				v.mov.X = v.mov.X-(dx/d)*pow*100
				v.mov.Y = v.mov.Y-(dy/d)*pow*100
			elseif self.damaging then
				v:die()
			end
		end
	end
	self.poly.transform:translate(x,y)
	table.insert(splosion.all, self)
	return self
end

function splosion.update( dt )
	local i = 1
	while i<=#splosion.all do
		v = splosion.all[i]
		if v.purge then
			table.remove(splosion.all,i)
		else
			v:update(dt)
			i=i+1
		end
	end
end

function splosion_mt:update(dt)
	self.time=self.time-dt*self.decay
	if self.time<=0 then
		self.purge = true
	end
end

function splosion.draw()
	for i,v in ipairs(splosion.all) do
		v:draw()
	end
end

function splosion_mt:draw()
	local r,g,b,a = love.graphics.getColor()
	--love.graphics.print(i,math.floor(v.transform.mat[3]),math.floor(v.transform.mat[6]))
	local div = (60/255)
	love.graphics.setColor(r*div,g*div,b*div,255)
	self.poly:drawFill()
	love.graphics.setColor(r,g,b,a)
	self.poly:draw()
end