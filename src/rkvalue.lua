local rkvalue_mt = {}
rkvalue = {}

function rkvalue.new(n,func)
	local self = setmetatable({},{__index=rkvalue_mt})
	self.x = n
	self.v = 0
	self.func = func
	return self
end

function rkvalue_mt:update(dt)
	rkvalue.integrate(self, 0, dt, self.func)
end

function rkvalue.eval(initial,t,dt,d,f)
	local state = {
		x = initial.x+d.dx*dt,
		v = initial.v+d.dv*dt}
	local output = {
		dx = state.v,
		dv = f(state,t+dt)
	}
	return output
end

function rkvalue.integrate(state, t, dt,f)
	local a = rkvalue.eval(state, t, 0, {dx=0,dv=0},f)
	local b = rkvalue.eval(state, t, dt*0.5, a,f)
	local c = rkvalue.eval(state, t, dt*0.5, b,f)
	local d = rkvalue.eval(state, t, dt, c,f)

	local dxdt = 1/6 * (a.dx + 2*(b.dx + c.dx) + d.dx)
	local dvdt = 1/6 * (a.dv + 2*(b.dv + c.dv) + d.dv)

	state.x = state.x+dxdt*dt
	state.v = state.v+dvdt*dt
end