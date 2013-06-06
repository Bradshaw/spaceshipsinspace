level = {}
local boxnum = 10

function level.new()
	for i=1,boxnum do
		level[i]=polygon.new()
		level[i]:append(vector.new(-40,-40))
		level[i]:append(vector.new(-40,40))
		level[i]:append(vector.new(40,40))
		level[i]:append(vector.new(40,-40))
		level[i]:convexify()
		--level[i].transform:rotate((i/boxnum)*math.pi*2+0.1)
		level[i].transform:translate_global(512,300)
		level[i].transform:translate((85*i)%(4*85),math.floor(i/4)*85)
		level[i].transform:rotate(math.random()/10)
		level[i].transform:rotate(-math.random()/10)
		--level[i].transform:translate_global(512,300)
	end
end

function level.update(dt)
	
end

function level.draw()
	if not level.canv then
		local r,g,b,a = love.graphics.getColor()
		love.graphics.setColor(255,255,255,255)
		level.canv = love.graphics.newCanvas(1024,1024)
		love.graphics.setCanvas(level.canv)
		for i,v in ipairs(level) do
			v:draw()
		end
		level.canv:setFilter("nearest","nearest")
		love.graphics.setCanvas()
		love.graphics.setColor(r,g,b,a)
	end
	love.graphics.draw(level.canv)
end