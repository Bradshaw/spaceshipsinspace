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
	local i = 0
	while i < math.pi*2*2 do
		local a = i
		local d = self.radius/2+math.random()*self.radius
		self.poly:append(vector.new(math.cos(a)*d,math.sin(a)*d))
		i=i+math.random()
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
	self.poly:draw()
end