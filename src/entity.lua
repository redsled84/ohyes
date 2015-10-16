local class = require 'lib.middleclass'
local Entity = class('Entity')

local gravityAccel = 800

function Entity:initialize(world, x,y,w,h)
	self.world, self.x, self.y, self.w, self.h = world, x,y,w,h
	self.vx, self.vy = 0,0
	self.world:add(self, x,y,w,h)
	self.created_at = love.timer.getTime()
end

function Entity:changeVelocityByGravity(dt)
  	self.vy = self.vy + gravityAccel * dt
end

function Entity:changeVelocityByCollisionNormal(nx, ny, bounciness)
  	bounciness = bounciness or 0
  	local vx, vy = self.vx, self.vy

  	if (nx < 0 and vx > 0) or (nx > 0 and vx < 0) then
    	vx = -vx * bounciness
  	end

  	if (ny < 0 and vy > 0) or (ny > 0 and vy < 0) then
    	vy = -vy * bounciness
  	end

  	self.vx, self.vy = vx, vy
end

function Entity:getCenter()
  	return self.l + self.w / 2,
        self.t + self.h / 2
end

function Entity:destroy()
	self.world:remove(self)
end

return Entity