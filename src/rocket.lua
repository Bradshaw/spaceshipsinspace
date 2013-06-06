rocket = {}

function rocket.new(pos, dir)
	local self = bullet.new(pos,dir,rocket.impact)
	self.time_out = 5
	self.speed = 1000
	return self
end

function rocket.impact(self, pos)
	splosion.new(pos.X,pos.Y)
	shake = shake+1
end