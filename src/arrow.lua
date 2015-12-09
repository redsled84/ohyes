local class = require 'lib.middleclass'
local inspect = require 'lib.inspect'
local Arrow = class('Arrow')

local speed = 600

function Arrow:initialize(world)
	self.world = world
	self.arrows = {}
end

function Arrow:shoot(x, y)
	local world = self.world
	local arrow = {x = x, y = y, w=20, h=5, type = "Arow"}
	world:add(arrow, x, y, arrow.w, arrow.h)
	table.insert(self.arrows, arrow)
end

function Arrow:updateArrows(dt)
	local world = self.world
	for i=1, #self.arrows do
		local arrow = self.arrows[i]
		nx = arrow.x + speed * dt
		ny = arrow.y --
		local goalX, goalY, cols, len = world:move(arrow, nx, ny)

		for i=1, len do
			local col = cols[len]
			if col.normal.x == -1 then
				nx = col.itemRect.x
			end
		end

		arrow.x, arrow.y = nx, ny
	end
end

function Arrow:drawArrows()
	for i,v in ipairs(self.arrows) do
		love.graphics.rectangle("line", v.x, v.y, v.w, v.h)
	end
end

return Arrow