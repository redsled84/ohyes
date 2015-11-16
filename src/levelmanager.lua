local class = require 'lib.middleclass'
local inspect = require 'lib.inspect'
local MapSystem = require 'src.mapsystem'
local Player = require 'src.player'
local LevelManager = class('LevelManager') 

function LevelManager:initialize(world)
	self.world = world

end

function LevelManager:deleteLevel(data)
	local world = self.world
	for i=1, #data do
		data[i] = 0
	end
	local items, len = world:getItems()
	for i=1, len do
		local item = items[i]
		if item.type == 'Solid' then
			world:remove(item)
		end
	end
end

function LevelManager:resetLevel(data, map)
	self:deleteLevel(data)
	MapSystem:loadMap(map)
	local PlayerLoadX, PlayerLoadY = MapSystem:returnTileCoors(4)
	Player:setPosition(PlayerLoadX, PlayerLoadY)
end

function LevelManager:playerNextLevel()

end

return LevelManager