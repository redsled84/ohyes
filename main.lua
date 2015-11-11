--Dick Splinters 

--libs
local bump = require 'lib.bump'
local inspect = require 'lib.inspect'
local class = require 'lib.middleclass'
local gamera = require 'lib.gamera'
local txt = require 'lib.txt'

-- source files
local Player = require 'src.player'
local MapSystem = require 'src.mapsystem'
local Blocks = require 'src.blocks'
local Quads = require 'src.quads'
local Entity = require 'src.entity'

local map = txt.parseMap('levels/level_0.txt')
local world = bump.newWorld()

-- ** tilesets **
local tileset = love.graphics.newImage('images/solid_tileset2.png')
local tilesetW, tilesetH = tileset:getWidth(), tileset:getHeight()

-- camera
-- local Camera = class('Camera')

-- function Camera:initialize(tileW, tileH, mapW, mapH, windowWidth, windowHeight)
--     cam = gamera.new(0, 0, windowWidth, windowHeight)
--     cam:setWorld(0, 0, mapW*tileW, mapH*tileH)
-- end

function love.load()
    local tileswide = tilesetW/map.tilewidth
    local tileshigh = tilesetH/map.tileheight

    cam = gamera.new(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    cam:setWorld(0, 0, map.w*map.tilewidth, map.h*map.tileheight)

    Blocks:initialize(world)
    Quads.quadInfo = Quads:loadQuadInfo(map.tilewidth, map.tileheight,
        tilesetW/map.tilewidth, tilesetH/map.tileheight)
    Quads.quads = Quads:loadQuads(map.tilewidth, map.tileheight, 
        tilesetW, tilesetH)
    MapSystem:loadMap(map)

    local PlayerLoadX, PlayerLoadY = MapSystem:returnTileCoors(4)
	Player:initialize(world, PlayerLoadX, PlayerLoadY, 32, 32)
end

function love.update(dt)
    Player:update(dt)
    Player:canPassLevel(MapSystem.itemCount)
    Blocks:checkBlocks()
end

function love.draw()
    cam:draw(function(l,t,w,h)
        Player:draw()
        MapSystem:drawTiles(tileset, Quads.quadInfo, Quads.quads, map)
    end)
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end

    Player:jumpWithKey(key)
end