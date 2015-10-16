local class = require 'lib.middleclass'
local txt = require 'lib.txt'
local Blocks = require 'src.blocks'
local MapSystem = class('MapSystem')

local map = txt.parseMap('levels/level_0.txt')

function MapSystem:initialize(x, y, map)
    self.x, self.y = x, y
    self.data = {}
    self.map = map
    self.mapwidth, self.mapheight = map.w, map.h 
    self.tilewidth, self.tileheight = map.tilewidth, map.tileheight
    self.created_at = love.timer.getTime()
end

function MapSystem:loadTiles(map)
    local mapwidth = self.mapwidth
    local tilewidth, tileheight = self.tilewidth, self.tileheight
    for i=1, #self.map.layers do
        local v = self.map.layers[i]
        if v.name == "Solid" then
            for j=1, #v.data do
                local num = v.data[j]
                if num == 1 then
                    Blocks:newBlock(self.x, self.y, tilewidth, tileheight, "Solid")
                -- elseif num == 2 then
                --     Blocks:newBlock(self.x, self.y, tilewidth, tileheight, "Key", j)
                --     roomKeyCount = roomKeyCount + 1
                -- elseif num == 3 then
                --     Blocks:newBlock(self.x, self.y, tilewidth, tileheight, "Door")
                end
                if j % mapwidth == 0 then
                    self.x = 0
                    self.y = self.y + tileheight
                else
                    self.x = self.x + tilewidth
                end
                table.insert(self.data, num)
            end
        end
    end
end

function MapSystem:loadMap()
    self:initialize(0, 0, map)
    self:loadTiles(map)
end

function MapSystem:drawTiles(tileset, quadInfo, quads)
    local x, y = 0, 0
    for i=1, #self.data do
        local num = self.data[i]
        if num > 0 and num <= #quadInfo then
            love.graphics.draw(tileset, quads[num], x, y)
        end
        if i % self.mapwidth == 0 then
            x = 0
            y = y + self.tileheight
        else
            x = x + self.tilewidth
        end
    end
end

return MapSystem