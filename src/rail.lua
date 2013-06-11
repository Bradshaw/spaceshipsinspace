local rail_mt = {}
rail_mt.time = 1
rail_mt.decay = 4
rail_mt.width = 2
rail = {}

rail.all = {}

function rail.new(pos, dir)
	local self = setmetatable({},{__index=rail_mt})
	self.startpoint = pos:dup()
	local candy = {}
	for i,v in ipairs(level) do
		local h, a = v:collideLine(pos,pos:dup():add(dir))
		for j,u in ipairs(h) do
			table.insert(candy,{hit=u,axis=a[j]})
		end
	end
	local dist = math.huge
	local spray
	for i,v in ipairs(candy) do
		if math.sign(v.hit.X-pos.X)==math.sign(dir.X) and math.sign(v.hit.Y-pos.Y)==math.sign(dir.Y) then
			local dx = v.hit.X-pos.X
			local dy = v.hit.Y-pos.Y
			local d = (dx*dx+dy*dy)
			if d<dist then
				self.endpoint = v.hit
				dist = d
				spray = v.axis
			end
		end
	end
	if spray then
		for i=1,30 do
			flame.new(self.endpoint,dir,0.25)
		end
	end
	if not self.endpoint then
		self.endpoint = vector.new(pos.X+dir.X*10000,pos.Y+dir.Y*10000)
	end
	

	table.insert(rail.all, self)
	return self
end

function rail.update( dt )
	local i = 1
	while i<=#rail.all do
		v = rail.all[i]
		if v.purge then
			table.remove(rail.all,i)
		else
			v:update(dt)
			i=i+1
		end
	end
end

function rail_mt:update(dt)
	self.time=self.time-dt*self.decay
	if self.time<0 then
		self.purge = true
	end
end

function rail.draw()
	for i,v in ipairs(rail.all) do
		v:draw()
	end
end

function rail_mt:draw()
	love.graphics.setLine(self.width*self.time,"rough")
	love.graphics.line(self.startpoint.X,self.startpoint.Y,self.endpoint.X,self.endpoint.Y)
	love.graphics.setLine(1,"rough")
end