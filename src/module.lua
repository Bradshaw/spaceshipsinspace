local module_mt = {}
module = {}

function module.new()
	local self = setmetatable({},{__index=module_mt})
	self.shape = {}
	self.doors = {}
	self.hardpoints = {}

	return self
end