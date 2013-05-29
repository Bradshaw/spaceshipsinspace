local polygon_mt = {}
polygon = {}

function polygon.new(poly, mat)
	local self = setmetatable({},{__index=polygon_mt})
	self.vertices = {}
	if poly then
		for i,v in ipairs(poly) do
			self:append(v)
		end
	end

	self.transform = mat or matrix.new()

	return self
end

function polygon_mt:dup()
	local dup = polygon.new()
	for i,v in ipairs(self.vertices) do
		dup:append(v:dup())
	end
	dup.transform = self.transform:dup()
	return dup
end

function polygon_mt:getAABB()
	local minX = math.huge
	local minY = math.huge
	local maxX = -math.huge
	local maxY = -math.huge
	for i,v in ipairs(self.vertices) do
		pt = self.vertices[i]:dup():transform(self.transform)
		
		maxX = math.max(maxX,pt.X)
		maxY = math.max(maxY,pt.Y)
		minX = math.min(minX,pt.X)
		minY = math.min(minY,pt.Y)
	end
	return minX,minY,maxX,maxY
end

function polygon_mt:collideAABB(poly)
	local sx,sy,sX,sY = self:getAABB()
	local px,py,pX,pY = poly:getAABB()
	return not (sX<px or pX<sx or sY<py or pY<sy)
end

function polygon_mt:collidePoly(poly)
	for i=1,#self.vertices do
		local a = self.vertices[i]:dup():transform(self.transform)
		local j = i+1
		if j>#self.vertices then
			j=1
		end
		local b = self.vertices[j]:dup():transform(self.transform)
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
		end
	end
	return true
end

function polygon_mt:collide(poly)
	if self:collideAABB(poly) then
		return self:collidePoly(poly)
	else
		return false
	end
end


function polygon_mt:convexify()
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
	table.insert(self.vertices,vect)
end

function polygon_mt:applyTransform()
	for _,v in ipairs(self.vertices) do
		v:transform(self.transform)
	end
	self.transform = matrix.new()
end

function polygon_mt:draw()
	if #self.vertices>=2 then
		local v = self.vertices[1]:dup():transform(self.transform)
		local u = self.vertices[2]:dup():transform(self.transform)
		love.graphics.line(v.X,v.Y,u.X,u.Y)
		for i=3,#self.vertices do
			v = u
			u = self.vertices[i]:dup():transform(self.transform)
			love.graphics.line(v.X,v.Y,u.X,u.Y)
		end
		v = u
		u = self.vertices[1]:dup():transform(self.transform)
		love.graphics.line(v.X,v.Y,u.X,u.Y)
	end
end

function polygon_mt:getNormals()
	local norms = {}
	if #self.vertices>=2 then
		for i=1,#self.vertices do
			local v = self.vertices[i]:dup():transform(self.transform)
			local u = self.vertices[(i%#self.vertices)+1]:dup():transform(self.transform)
			table.insert(norms, {
				pos=vector.new( u.X+(v.X-u.X)/2 , u.Y+(v.Y-u.Y)/2),
				nor=v:dup():getNormal(u)})
		end
	end
	return norms
end