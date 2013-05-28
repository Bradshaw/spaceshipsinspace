local vector_mt = {}
vector_mt.x = 0
vector_mt.y = 0
vector = {}

function vector.new(x,y)
	local self = setmetatable({},{__index=vector_mt})
	self.x = x
	self.y = y
	return self
end

function vector_mt:dup()
	return vector.new(self.x,self.y)
end

function vector_mt:transform(mat)
	local xp = self.x*mat.mat[1] + self.y*mat.mat[2] + mat.mat[3]
	self.y = self.x*mat.mat[4] + self.y*mat.mat[5] + mat.mat[6]
	self.x = xp
	return self
end

