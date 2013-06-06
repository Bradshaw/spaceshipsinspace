local polygon_mt = {}
polygon = {}

polygon.all = {}

function polygon.new(poly, mat)
	local self = setmetatable({},{__index=polygon_mt})
	self.vertices = {}
	self.cache = {}
	if poly then
		for i,v in ipairs(poly) do
			self:append(v)
		end
	end

	self.transform = mat or matrix.new()
	return self
end

function polygon_mt:clearCache()
	self.cache = {}
end

function polygon_mt:getTransed()
	if not self.cache.transed then
		self.cache.transed = self:dup()
		self.cache.transed:applyTransform()
	end
	return self.cache.transed
end

function polygon_mt:dup()
	if not self.cache.dup then
		local dup = polygon.new()
		for i,v in ipairs(self.vertices) do
			dup:append(v:dup())
		end
		dup.transform = self.transform:dup()
		self.cache.dup = dup
	end
	return self.cache.dup
end

function polygon_mt:getAABB()
	if not self.cache.AABB then
		self.cache.AABB = {}
		local minX = math.huge
		local minY = math.huge
		local maxX = -math.huge
		local maxY = -math.huge
		for i,v in ipairs(self.vertices) do
			pt = self:getTransed().vertices[i]
			
			maxX = math.max(maxX,pt.X)
			maxY = math.max(maxY,pt.Y)
			minX = math.min(minX,pt.X)
			minY = math.min(minY,pt.Y)
		end
		self.cache.AABB.minX = minX
		self.cache.AABB.minY = minY
		self.cache.AABB.maxX = maxX
		self.cache.AABB.maxY = maxY
	end
	return self.cache.AABB.minX,self.cache.AABB.minY,self.cache.AABB.maxX,self.cache.AABB.maxY
end

function polygon_mt:collideAABB(poly)
	local sx,sy,sX,sY = self:getAABB()
	local px,py,pX,pY = poly:getAABB()
	return not (sX<px or pX<sx or sY<py or pY<sy)
end

function polygon_mt:collideLine(linestart,lineend)
	local hits = {}
	local axes = {}
	for i=1,#self.vertices do
		local a = self:getTransed().vertices[i]
		local j = i+1
		if j>#self.vertices then
			j=1
		end
		local b = self:getTransed().vertices[j]
		local axis = a:getNormal(b)
		local h, hx, hy = useful.lintersect(linestart.X,linestart.Y,lineend.X,lineend.Y,a.X,a.Y,b.X,b.Y)
		if h then
			--table.insert(hits,vector.new(hx,hy))
			--[[]]
			if hx>math.min(a.X,b.X) and hx<math.max(a.X,b.X) and hy>math.min(a.Y,b.Y) and hy<math.max(a.Y,b.Y) then
				table.insert(axes,axis)
				table.insert(hits,vector.new(hx,hy))
			end
			--]]
		end
	end
	return hits, axes
end

function polygon_mt:collidePoly(poly)
	local minl = math.huge
	local minvec = vector.new(1,0)
	local contact = vector.new(0,0)
	local dir = 1
	for i=1,#self.vertices do
		local a = self:getTransed().vertices[i]
		local j = i+1
		if j>#self.vertices then
			j=1
		end
		local b = self:getTransed().vertices[j]
		if a.X~=b.X or a.Y~=b.Y then
			local axis = a:getNormal(b)
			axis:normalise()
			local sm,sM = math.huge,-math.huge
			local pm,pM = math.huge,-math.huge


			for i=1,#self.vertices do
				local v = self:getTransed().vertices[i]
				local pr = v:project(axis)
				sm = math.min(sm,pr:dot(axis))
				sM = math.max(sM,pr:dot(axis))
			end
			for i=1,#poly.vertices do
				local v = poly:getTransed().vertices[i]
				local pr = v:project(axis)
				pm = math.min(pm,pr:dot(axis))
				pM = math.max(pM,pr:dot(axis))
			end
			if sm>=pM or pm>=sM then
				return false
			end
			if math.min(math.abs(sm-pM),math.abs(pm-sM))<minl then
				minvec = axis
				minl = math.min(math.abs(sm-pM),math.abs(pm-sM))
			end
		end
	end
	for i=1,#poly.vertices do
		local a = poly.vertices[i]:dup():transform(poly.transform)
		local j = i+1
		if j>#poly.vertices then
			j=1
		end
		local b = poly.vertices[j]:dup():transform(poly.transform)
		if a.X~=b.X or a.Y~=b.Y then
			local axis = a:getNormal(b)
			axis:normalise()
			local sm,sM = math.huge,-math.huge
			local pm,pM = math.huge,-math.huge


			for i=1,#self.vertices do
				local v = self.vertices[i]:dup():transform(self.transform)
				local pr = v:project(axis)
				sm = math.min(sm,pr:dot(axis))
				sM = math.max(sM,pr:dot(axis))
			end
			for i=1,#poly.vertices do
				local v = poly.vertices[i]:dup():transform(poly.transform)
				local pr = v:project(axis)
				pm = math.min(pm,pr:dot(axis))
				pM = math.max(pM,pr:dot(axis))
			end
			if sm>=pM or pm>=sM then
				return false
			end
			if math.min(math.abs(sm-pM),math.abs(pm-sM))<minl then
				minvec = axis
				minl = math.min(math.abs(sm-pM),math.abs(pm-sM))
				--dir = -1
			end
		end
	end
	minvec:normalise()
	minvec:scale(minl*dir)
	local minpr = math.huge
	if dir==1 then
		minpr = -math.huge
		for i=1,#poly.vertices do
			local pt = poly:getTransed().vertices[i]
			local pr = pt:project(minvec)
			if math.abs(pr:dot(minvec))>minpr then
				contact = pt
				minpr = math.abs(pr:dot(minvec))
			end
		end
	else
		for i=1,#self.vertices do
			local pt = self:getTransed().vertices[i]
			local pr = pt:project(minvec)
			if math.abs(pr:dot(minvec))<minpr then
				contact = pt
				minpr = math.abs(pr:dot(minvec))
			end
		end
	end
	return true, minvec, contact
end

function polygon_mt:collide(poly)
	if self:collideAABB(poly) then
		return self:collidePoly(poly)
	else
		return false
	end
end


function polygon_mt:convexify()
	self:clearCache()
	table.sort(self.vertices,function(a,b) return a.X<b.X end)
	local U = {}
	local L = {}
	
	local function cross(o, a, b)

		return (a.X - o.X) * (b.Y - o.Y) - (a.Y - o.Y) * (b.X - o.X)
	end

	for i,p in ipairs(self.vertices) do
		while #L>=2 and cross(L[#L-1], L[#L], p)<=0 do
			table.remove(L,#L)
		end
		table.insert(L,p)
	end

	table.sort(self.vertices,function(a,b) return a.X>b.X end)

	for i,p in ipairs(self.vertices) do
		while #U>=2 and cross(U[#U-1], U[#U], p)<=0 do
			table.remove(U,#U)
		end
		table.insert(U,p)
	end
	self.vertices = {}
	for i,v in ipairs(L) do
		self:append(v)
	end
	for i,v in ipairs(U) do
		self:append(v)
	end
end

function polygon_mt:append(vect)
	self:clearCache()
	table.insert(self.vertices,vect)
end

function polygon_mt:applyTransform()
	self:clearCache()
	for _,v in ipairs(self.vertices) do
		v:transform(self.transform)
	end
	self.transform = matrix.new()
end

function polygon_mt:draw()
	if #self.vertices>=2 then

		local v = self:getTransed().vertices[1]
		local u = self:getTransed().vertices[2]
		love.graphics.line(v.X,v.Y,u.X,u.Y)
		for i=3,#self.vertices do
			v = u
			u = self:getTransed().vertices[i]
			love.graphics.line(v.X,v.Y,u.X,u.Y)
		end
		v = u
		u = self:getTransed().vertices[1]
		love.graphics.line(v.X,v.Y,u.X,u.Y)
	end
	--[[]
	local norms = self:getNormals()
	for i,v in ipairs(norms) do
		love.graphics.line(v.pos.X,v.pos.Y,v.pos.X+v.nor.X*10,v.pos.Y+v.nor.Y*10)
	end
	--]]
end

function polygon_mt:getNormals()
	if not self.cache.normals then
		self.cache.normals = {}
		if #self.vertices>=2 then
			for i=1,#self.vertices do
				local v = self.vertices[i]:dup():transform(self.transform)
				local u = self.vertices[(i%#self.vertices)+1]:dup():transform(self.transform)
				table.insert(self.cache.normals, {
					pos=vector.new( u.X+(v.X-u.X)/2 , u.Y+(v.Y-u.Y)/2),
					nor=v:dup():getNormal(u)})
			end
		end
	end
	return self.cache.normals
end