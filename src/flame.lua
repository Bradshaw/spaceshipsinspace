flame = {}

function flame.new(pos, dir, spread)
	spread = spread or 0.25
	dir = dir:dup():transform(matrix.newRotate((math.random()-0.5)*spread))
	local self = bullet.new(pos,dir)
	self.time_out = math.random()/3
	self.rad = math.random(10,20)
	self.speed = math.random(0,350)
	self.nocollide = true
	function self:draw()
		love.graphics.line(self.pos.X,self.pos.Y,self.pos.X+self.dir.X*4*(1-self.time),self.pos.Y+self.dir.Y*4*(1-self.time))
	end
	return self
end