local class = require 'lib.middleclass'

local Blocks = class('Blocks', Entity)

function Blocks:initialize(world)
    self.world = world
end

function Blocks:newBlock(x, y, w, h, type, item)
    local world = self.world
    local block = {x = x, y = y, w = w, h = h, type = type}
    self[#self+1] = block
    world:add(block, x, y, w, h)
end

function Blocks:removeBlock(item)
	local world = self.world
	world:remove(item)
end

function Blocks:checkBlocks()
	-- print(#self)
end

return Blocks