useful = {}

function useful.sign(val)
	if val == 0 then
		return 1
	else
		return math.abs(val)/val
	end
end

function useful.tri(cond, a, b)
	if cond then
		return a
	else
		return b
	end
end

function useful.hsv(H, S, V, A, div, max, ang)
	local max = max or 255
	local ang = ang or 360
	local ang6 = ang/6
	local r, g, b
	local div = div or 100
	local S = (S or div)/div
	local V = (V or div)/div
	local A = (A or div)/div * max
	local H = H%ang
	if H>=0 and H<=ang6 then
		r = 1
		g = H/ang6
		b = 0
	elseif H>ang6 and H<=2*ang6 then
		r = 1 - (H-ang6)/ang6
		g = 1
		b = 0
	elseif H>2*ang6 and H<=3*ang6 then
		r = 0
		g = 1
		b = (H-2*ang6)/ang6
	elseif H>180 and H <= 240 then
		r = 0
		g = 1- (H-3*ang6)/ang6
		b = 1
	elseif H>4*ang6 and H<= 5*ang6 then
		r = (H-4*ang6)/ang6
		g = 0
		b = 1
	else
		r = 1
		g = 0
		b = 1 - (H-5*ang6)/ang6
	end
	local top = (V*max)
	local bot = top - top*S
	local dif = top - bot
	r = bot + r*dif
	g = bot + g*dif
	b = bot + b*dif

	return r, g, b, A
end


function useful.getABC(x1,y1,x2,y2)
	local A = y2-y1
	local B = x1-x2
	local C = A*x1+B*y1
	return A,B,C
end

function useful.lintersect(ax1,ay1,ax2,ay2,bx1,by1,bx2,by2)
	local a1,b1,c1 = useful.getABC(ax1,ay1,ax2,ay2)
	local a2,b2,c2 = useful.getABC(bx1,by1,bx2,by2)
	local det = a1*b2-a2*b1
	if det==0 then
		return false, 0, 0
	else
		local x = (b2*c1 - b1*c2)/det
		local y = (a1*c2 - a2*c1)/det
		return true, x, y
	end

end

function useful.alintersect(x1,y1,x2,y2,x3,y3,x4,y4)
	local bx = x2-x1
	local by = y2-y1
	local dx = x4-x3
	local dy = y4-y3
	local b_dot_d_perp = bx*dy - by*dx
	if b_dot_d_perp == 0 then
		return false, 0, 0
	else
		local cx = x3-x1
		local cy = y3-y1
		local t = (cx*dy - cy*dx) / b_dot_d_perp
		return true, x1+t*bx, y1+t*by
	end
end


math.sign = useful.sign