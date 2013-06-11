rocket = {}

function rocket.new(pos, dir)
	local self = bullet.new(pos,dir,rocket.impact)
	self.time_out = 5
	self.speed = 600
	self.useFlame = true
	return self
end

function rocket.impact(self, pos)
	splosion.new(pos.X,pos.Y,50,true)
	shake = shake+1
end