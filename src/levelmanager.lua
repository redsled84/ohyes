local class = require 'lib.middleclass'
local inspect = require 'lib.inspect'
local txt = require 'lib.txt'
local MapSystem = require 'src.mapsystem'
local Player = require 'src.player'
local LevelManager = class('LevelManager') 
LevelManager.currLevel = 2

function LevelManager:initialize(world)
	self.world = world
	self.levels = {}
end

-- PLANS: adjust code to fit a hub world design
function LevelManager:loadLevels(path)
	local files = love.filesystem.getDirectoryItems(path)
	for i=1,#files do
		local str = files[i]
		if str:sub(1,6) == "level_" and str:sub(-3) == "txt" then
			self.levels[#self.levels+1] = files[i]
		end
	end
end

function LevelManager:deleteLevel(data)
	local world = self.world
	for i=1, #data do
		data[i] = nil
	end
	local items, len = world:getItems()
	for i=1, len do
		local item = items[i]
		if item.type == 'Solid' then
			world:remove(item)
		end
	end
end

function LevelManager:resetLevel(data, level)
	self:deleteLevel(data) 
	MapSystem:loadMap(level)
	--temp var for current linear world design
	self.currLevel = self.currLevel + 1
end

function LevelManager:nextLevel(data)
	for i=1, #self.levels do
		local str = self.levels[i]
		if tonumber(str:sub(7,7)) == self.currLevel then
			self:resetLevel(data, txt.parseMap("levels/"..str))
			return  
		end
	end
end

return LevelManager