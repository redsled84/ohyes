local class = require "lib.middleclass"
local Enemy = class("Enemy")

function Enemy:initialize(world)
	self.world = world
end

function Enemy:newEnemy(x,y,w,h)
	local world = self.world
	local enemy = {x = x, y = y, w = w, h = h, vx = 0, vy = 0, spd = 200, type = "Enemy"}
	table.insert(self, enemy)
	world:add(enemy, x, y, w, h)
end

function Enemy:update(dt, goalX, goalY)
	local world = self.world
	for i=1,#self do
		local v = self[i]
		v.vy = v.vy + 880 * dt
		local futureX, futureY = v.x + (v.vx * dt), v.y + (v.vy * dt)
    	local nextX, nextY, cols, len = world:move(v, futureX, futureY)

    	for i=1, len do
    		local col = cols[i]
    		if goalY == v.y then
    			if goalX > v.x then
    				v.vx = v.spd
    			else
    				v.vx = -v.spd
    			end
    		end
    		if col.normal.y == -1 then
    			v.vy = 0
    		end
    	end

    	v.x, v.y = nextX, nextY
	end
end

function Enemy:drawEnemies()
	for i=1,#self do
		local v = self[i]
		love.graphics.setColor(0,255,0)
		love.graphics.rectangle('fill', v.x, v.y, v.w, v.h)
	end
end

return Enemy