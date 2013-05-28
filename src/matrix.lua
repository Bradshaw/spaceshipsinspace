local matrix_mt = {}
matrix = {}

function matrix.new()
	local self = setmetatable({},{__index=matrix_mt})
	self.mat = {1,0,0,
				0,1,0,
				0,0,1}
	return self
end

function matrix.newTranslate(x,y)
	local self = matrix.new()
	self.mat[3]=x
	self.mat[6]=y
	return self
end

function matrix.newScale(x,y)
	local self = matrix.new()
	self.mat[1]=x or 1
	self.mat[5]=y or x or 1
	return self
end

function matrix.newRotate(a)
	local self = matrix.new()
	self.mat[1]=math.cos(a)
	self.mat[2]=math.sin(a)
	self.mat[4]=-math.sin(a)
	self.mat[5]=math.cos(a)
	return self
end

function matrix_mt:rotate(ang,x,y)
	if x and y then
		self:mult(matrix.newTranslate(x,y))
	end
	self:mult(matrix.newRotate(ang))
	if x and y then
		self:mult(matrix.newTranslate(-x,-y))
	end
end

function matrix_mt:translate(x,y)
	self:mult(matrix.newTranslate(x,y))
end

function matrix_mt:scale(x,y)
	self:mult(matrix.newScale(x,y))
end

function matrix_mt:dup()
	local newmat = matrix.new()
	for i,v in ipairs(self.mat) do
		newmat.mat[i]=v
	end
	return newmat
end

--[[
	a b c     A B C     aA+bD+cG  aB+bE+cH  aC+bF+cI
	d e f  X  D E F  =  dA+eD+fG  dB+eE+fH  dC+eF+fI
	g h i     G H I     gA+hD+iG  gB+hE+iH  gC+hF+iI


]]
function matrix_mt:mult(mat)
	self.mat = {
	self.mat[1]*mat.mat[1] + self.mat[2]*mat.mat[4] + self.mat[3]*mat.mat[7],
	self.mat[1]*mat.mat[2] + self.mat[2]*mat.mat[5] + self.mat[3]*mat.mat[8],
	self.mat[1]*mat.mat[3] + self.mat[2]*mat.mat[6] + self.mat[3]*mat.mat[9],

	self.mat[4]*mat.mat[1] + self.mat[5]*mat.mat[4] + self.mat[6]*mat.mat[7],
	self.mat[4]*mat.mat[2] + self.mat[5]*mat.mat[5] + self.mat[6]*mat.mat[8],
	self.mat[4]*mat.mat[3] + self.mat[5]*mat.mat[6] + self.mat[6]*mat.mat[9],

	self.mat[7]*mat.mat[1] + self.mat[8]*mat.mat[4] + self.mat[9]*mat.mat[7],
	self.mat[7]*mat.mat[2] + self.mat[8]*mat.mat[5] + self.mat[9]*mat.mat[8],
	self.mat[7]*mat.mat[3] + self.mat[8]*mat.mat[6] + self.mat[9]*mat.mat[9]
	}
	return self
end