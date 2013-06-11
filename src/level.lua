level = {}
local boxnum = 20

function makeCircle(x,y,r,e)
	local c = polygon.new()
	for i=1,e do
		local a = ((math.pi*2)/e)*i
		local r = r * (0.5+math.random())
		local xo = r*math.sin(a)
		local yo = r*math.cos(a)
		c:append(vector.new(xo,yo))
	end
	c.transform:translate(x,y)
	c:convexify()
	return c
end

function level.new()
	--[[
	level[1] = makeCircle(
			love.graphics.getWidth()/2,
			love.graphics.getHeight()/2,
			100,
			15
			)
	--]]
	--[[
	level[1] = polygon.new()
	level[1]:append(vector.new(400,300))
	level[1]:append(vector.new(624,300))
	level[1]:append(vector.new(512,400))
	--]]
	---[[
	local saturation = 1
	local i = 1
	while saturation<100 do
		local col = true
		local tries = 0
		while col and tries < 1 do
			tries = tries + 1
			level[i] = makeCircle(
				math.random(0,love.graphics.getWidth()),
				math.random(0,love.graphics.getHeight()),
				math.random(30,100),
				15
				)
			col = false
			for j=1,i-1 do
				v = level[j]
				if level[i]:collide(v) then
					col = true
				end
			end
		end
		if col then
			level[i] = nil
			saturation = saturation+1
		else
			i=i+1
		end
	end
	--]]
end

function level.update(dt)
end

function level.draw()
	if not level.canv then
		local r,g,b,a = love.graphics.getColor()
		level.canv = love.graphics.newCanvas(1024,1024)
		love.graphics.setCanvas(level.canv)
		for i,v in ipairs(level) do
			love.graphics.print(i,math.floor(v.transform.mat[3]),math.floor(v.transform.mat[6]))
			--love.graphics.setColor(r/4,g/4,b/4,a)
			love.graphics.setColor(60,60,60,255)
			v:drawFill()
			--love.graphics.setColor(r,g,b,a)
			love.graphics.setColor(255,255,255,255)
			v:draw()
		end
		level.canv:setFilter("nearest","nearest")
		love.graphics.setCanvas()
		love.graphics.setColor(r,g,b,a)
	end
	love.graphics.draw(level.canv)
end