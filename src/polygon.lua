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