local dude_mt = {}
dude_mt.cooldown = 0.65
dude = {}

dude.all = {}

function dude.new(controller)
	local self = setmetatable({},{__index=dude_mt})
	dude.all[controller] = self
	self.cooling = 0
	self.controller = controller
	self.pos = vector.new(love.graphics.getWidth()/2,love.graphics.getHeight()/2)
	self.dir = vector.new()
	self.mov = vector.new()
	self.poly = polygon.new()
	self.poly:append(vector.new(5,5))
	self.poly:append(vector.new(5,-5))
	self.poly:append(vector.new(-5,-5))
	self.poly:append(vector.new(-5,5))
	self.poly:convexify()
	self.poly.drawNorms = true
	self.wep = true
	return self
end

function dude.update(dt)
	for k,v in pairs(dude.all) do
		v:update(dt)
	end
end


function dude_mt:update(dt)
	self.poly.transform:rotate(dt-dt*(self.cooling/self.cooldown)^2*30)
	self.dir.X = love.joystick.getAxis(self.controller,4)
	self.dir.Y = love.joystick.getAxis(self.controller,5)
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
		if (love.joystick.isDown(self.controller,6) or (love.joystick.getAxis(self.controller,6)>0)) then
			self.mov:add(intent:scale(dt*100))
		else
			self.mov:add(intent:scale(dt*400))
		end
	else
	end

	if (love.joystick.isDown(self.controller,6) or (love.joystick.getAxis(self.controller,6)>0)) then
		self.mov.X = self.mov.X-self.mov.X*dt*2.5
		self.mov.Y = self.mov.Y-self.mov.Y*dt*2.5
	else
		self.mov.X = self.mov.X-self.mov.X*dt*10
		self.mov.Y = self.mov.Y-self.mov.Y*dt*10
	end
	--[[
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
	--]]
	---[[
	local col=false
	local ax
	local thisx = self.pos.X
	local thisy = self.pos.Y
	local nextx = self.pos.X+self.mov.X*dt*5
	local nexty = self.pos.Y+self.mov.Y*dt*5
	local colcount = 0
	local lastcol = 0
	local dist = math.huge
	if not self.nocollide then
		for j,u in ipairs(level) do
			local minx,miny,maxx,maxy = u:getAABB()
			if nextx>=minx and nextx<=maxx and nexty>=miny and nexty<=maxy then
				local hits, axes = u:collideLine(vector.new(self.pos.X,self.pos.Y),vector.new(self.pos.X+self.mov.X,self.pos.Y+self.mov.Y))
				for i,v in ipairs(hits) do
					if v.X>=math.min(thisx,nextx) and v.Y>=math.min(thisy,nexty) and v.X<=math.max(thisx,nextx) and v.Y<=math.max(thisy,nexty) then
						local dx = v.X-thisx
						local dy = v.Y-thisy
						local d = (dx*dx+dy*dy)
						if lastcol~= u then
							colcount = colcount+1
							lastcol = u
						end
						if d<=dist then
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
		if colcount then
			self.pos.X = col.X+ax.X
			self.pos.Y = col.Y+ax.Y
		else
			self.pos.X = self.pos.X-self.mov.X*dt*5
			self.pos.Y = self.pos.Y-self.mov.Y*dt*5
		end
		--self.purge = true
	else
		self.pos.X = self.pos.X+self.mov.X*dt*5
		self.pos.Y = self.pos.Y+self.mov.Y*dt*5
	end
	self.poly.transform.mat[3] = self.pos.X
	self.poly.transform.mat[6] = self.pos.Y
	self.poly:clearCache()
	--]]

	if (love.joystick.isDown(self.controller,6) or (love.joystick.getAxis(self.controller,6)>0)) and self.cooling<=0 then
		--self.mov.X = self.mov.X-self.dir.X * 50
		--self.mov.Y = self.mov.Y-self.dir.Y * 50
		self.cooling=self.cooling+self.cooldown
		splosion.new(self.pos.X+self.dir.X*5,self.pos.Y+self.dir.Y*5,10)
		--flame.new(self.pos,self.dir)
		rail.new(self.pos,self.dir)
		--bullet.new(self.pos,self.dir)
		--rocket.new(self.pos,self.dir)
		shake = shake+0.4
	end
end

function dude_mt:die()
	self = dude.new(self.controller)
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
	---[[
	love.graphics.line(
		self.pos.X+self.dir.X*20+self.dir.Y*2,
		self.pos.Y+self.dir.Y*20-self.dir.X*2,
		self.pos.X+self.dir.X*40+self.dir.Y*2,
		self.pos.Y+self.dir.Y*40-self.dir.X*2
		)
	love.graphics.line(
		self.pos.X+self.dir.X*20-self.dir.Y*2,
		self.pos.Y+self.dir.Y*20+self.dir.X*2,
		self.pos.X+self.dir.X*40-self.dir.Y*2,
		self.pos.Y+self.dir.Y*40+self.dir.X*2
		)
	--]]
	if self.cooling<=0 then
		local candy = {}
		for i,v in ipairs(level) do
			local h, a = v:collideLine(self.pos,self.pos:dup():add(self.dir))
			for j,u in ipairs(h) do
				table.insert(candy,{hit=u,axis=a[j]})
			end
		end
		local dist = math.huge
		local spray
		local tgt
		for i,v in ipairs(candy) do
			if math.sign(v.hit.X-self.pos.X)==math.sign(self.dir.X) and math.sign(v.hit.Y-self.pos.Y)==math.sign(self.dir.Y) then
				local dx = v.hit.X-self.pos.X
				local dy = v.hit.Y-self.pos.Y
				local d = (dx*dx+dy*dy)
				if d<dist then
					tgt = v.hit
					dist = d
					spray = v.axis
				end
			end
		end
		local r,g,b,a = love.graphics.getColor()
		love.graphics.setColor(r,g,b,a/4)
		if tgt then
			love.graphics.line(self.pos.X,self.pos.Y,tgt.X,tgt.Y)
		else
			love.graphics.line(self.pos.X,self.pos.Y,self.pos.X+self.dir.X*3000,self.pos.Y+self.dir.Y*3000)
		end
		love.graphics.setColor(r,g,b,a)
	end
end