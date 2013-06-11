local bullet_mt = {}
bullet_mt.time_out = 0.5
bullet_mt.speed = 800

bullet = {}

bullet.all = {}

function bullet.new(pos,dir,impact)
	local self = setmetatable({},{__index = bullet_mt})
	table.insert(bullet.all, self)
	self.pos = pos:dup()
	self.dir = dir:dup()
	self.time = 0
	self.impact = impact or function() end

	return self
end

function bullet.update(dt)
	local i = 1
	while i<=#bullet.all do
		local v=bullet.all[i]
		if v.purge then
			table.remove(bullet.all,i)
		else
			v:update(dt)
			i=i+1
		end
	end
end

function bullet_mt:update( dt )
	self.time = self.time+dt
	if self.time > self.time_out then
		self.purge = true
	end
	local col=false
	local ax
	local thisx = self.pos.X
	local thisy = self.pos.Y
	local nextx = self.pos.X+self.dir.X*dt*self.speed
	local nexty = self.pos.Y+self.dir.Y*dt*self.speed
	local dist = math.huge
	if not self.nocollide then
		for i,v in ipairs(level) do
			local minx,miny,maxx,maxy = v:getAABB()
			if nextx>=minx and nextx<=maxx and nexty>=miny and nexty<=maxy then
				local hits, axes = v:collideLine(vector.new(self.pos.X,self.pos.Y),vector.new(self.pos.X+self.dir.X,self.pos.Y+self.dir.Y))
				for i,v in ipairs(hits) do
					if v.X>=math.min(thisx,nextx) and v.Y>=math.min(thisy,nexty) and v.X<=math.max(thisx,nextx) and v.Y<=math.max(thisy,nexty) then
						local dx = thisx-v.X
						local dy = thisy-v.Y
						local d = (dx*dx+dy*dy)
						if d<dist then
							col = v
							ax = axes[i]
							dist = d
						end
					end
				end
			end
		end
	end
	if col then
		self:impact(col)
		self.purge = true
	else
		self.pos:add(self.dir:dup():scale(self.speed*dt))
	end
	if not self.flame and self.useFlame then
		flame.new(self.pos,vector.new(-self.dir.X,-self.dir.Y))
	end
end

function bullet.draw()
	for i,v in ipairs(bullet.all) do
		v:draw()
	end
end

function bullet_mt:draw()
	love.graphics.line(
		self.pos.X+self.dir.Y*2,
		self.pos.Y-self.dir.X*2,
		self.pos.X-self.dir.Y*2,
		self.pos.Y+self.dir.X*2)
	love.graphics.line(
		self.pos.X+self.dir.Y*2,
		self.pos.Y-self.dir.X*2,
		self.pos.X+self.dir.X*10,
		self.pos.Y+self.dir.Y*10)
	love.graphics.line(
		self.pos.X-self.dir.Y*2,
		self.pos.Y+self.dir.X*2,
		self.pos.X+self.dir.X*10,
		self.pos.Y+self.dir.Y*10)
end