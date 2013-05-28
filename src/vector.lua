local vector_mt = {}
vector_mt.x = rkvalue.new(0,function() end)
vector_mt.y = rkvalue.new(0,function() end)
vector_mt.X = vector_mt.x.val
vector_mt.Y = vector_mt.y.val
vector = {}

function vector.new(x,y,f)
	local self = setmetatable({},{__index=vector_mt})
	self.f = f or function() end
	self.x = rkvalue.new(x,self.f)
	self.y = rkvalue.new(y,self.f)
	self.X = self.x.val
	self.Y = self.y.val
	return self
end

function vector_mt:dup()
	return vector.new(self.X,self.Y)
end

function vector_mt:transform(mat)
	local xp = self.X*mat.mat[1] + self.Y*mat.mat[2] + mat.mat[3]
	self.Y = self.X*mat.mat[4] + self.Y*mat.mat[5] + mat.mat[6]
	self.X = xp
	return self
end
