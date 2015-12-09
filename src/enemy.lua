local class = require "lib.middleclass"
local Enemy = class("Enemy", Entity)

function Enemy:loadEnemy(world, x,y,w,h)
	self:initialize(world, x,y,w,h)
end