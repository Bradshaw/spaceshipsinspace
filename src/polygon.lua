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
	print(self.transform)

	return self
end

function polygon_mt:append(vect)
	table.insert(self.vertices,vect)
end

function polygon_mt:draw()
	if #self.vertices>=2 then
		local v = self.vertices[1]:dup():transform(self.transform)
		local u = self.vertices[2]:dup():transform(self.transform)
		love.graphics.line(v.x,v.y,u.x,u.y)
		for i=3,#self.vertices do
			v = u
			u = self.vertices[i]:dup():transform(self.transform)
			love.graphics.line(v.x,v.y,u.x,u.y)
		end
		v = u
		u = self.vertices[1]:dup():transform(self.transform)
		love.graphics.line(v.x,v.y,u.x,u.y)
	end
end