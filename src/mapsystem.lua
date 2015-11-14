local class = require 'lib.middleclass'
local txt = require 'lib.txt'
local Blocks = require 'src.blocks'
local MapSystem = class('MapSystem')

function MapSystem:initialize(x, y, map)
    self.x, self.y = x, y
    self.data = {}
    self.map = map
    self.mapwidth, self.mapheight = map.w, map.h 
    self.tilewidth, self.tileheight = map.tilewidth, map.tileheight
    self.created_at = love.timer.getTime()
    self.itemCount = 0
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
                    
                elseif num == 2 then
                    Blocks:newBlock(self.x, self.y, tilewidth, tileheight, "Key", j)
                    self.itemCount = self.itemCount + 1
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

function MapSystem:loadMap(map)
    self:initialize(0, 0, map)
    self:loadTiles(map)
end

--[[function that returns the x and y position of a type of tile (use would be for setting the 
    players x and y with a player origin block at the beginning of a level or the nearest checkpoint).    
]]
function MapSystem:returnTileCoors(tileNum)
    local x, y = 0, 0
    local coors = {}
    local mapwidth = self.mapwidth
    local tilewidth, tileheight = self.tilewidth, self.tileheight
    for i=1, #self.map.layers do 
        local v = self.map.layers[i]

        for j=1, #v.data do
            local num = v.data[j]
            if num == tileNum then
                return x, y
            end
            if j % mapwidth == 0 then
                x = 0
                y = y + tileheight
            else
                x = x + tilewidth
            end
        end
    end
end

function MapSystem:getTileIndex(x, y)
    local index = y + (x+32)/32
    return index
end

function MapSystem:removeTile(x, y)
    local i = self:getTileIndex(x, y)
    self.data[i] = 0
end

function MapSystem:drawTiles(tileset, quadInfo, quads)
    local x, y = 0, 0
    for i=1, #self.data do
        local num = self.data[i]
        if num > 0 and num <= #quadInfo then
            love.graphics.setColor(255,255,255)
            love.graphics.draw(tileset, quads[num], x, y)

            -- debug draw
            -- love.graphics.rectangle('line', x, y, self.tilewidth, self.tileheight)
            -- love.graphics.setColor(0,255,0)
            -- love.graphics.print(tostring(x), x+5, y+5)
            -- love.graphics.print(tostring(y), x+5, y+15)
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