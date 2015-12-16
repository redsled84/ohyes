gameState = "play"

--libs
local bump = require 'lib.bump'
local inspect = require 'lib.inspect'
local class = require 'lib.middleclass'
local gamera = require 'lib.gamera'
local txt = require 'lib.txt'

-- source files
local Player = require 'src.player'
local MapSystem = require 'src.mapsystem'
local LevelManager = require 'src.levelmanager'
local Blocks = require 'src.blocks'
local Quads = require 'src.quads'
local Entity = require 'src.entity'
local Enemy = require 'src.enemy'

local map = txt.parseMap('levels/level_' .. tostring(LevelManager.currLevel-1) .. '.txt')

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

    Enemy:initialize(world)
    Blocks:initialize(world)
    Quads.quadInfo = Quads:loadQuadInfo(map.tilewidth, map.tileheight,
        tilesetW/map.tilewidth, tilesetH/map.tileheight)
    Quads.quads = Quads:loadQuads(map.tilewidth, map.tileheight, 
        tilesetW, tilesetH)
    MapSystem:loadMap(map)
    LevelManager:initialize(world)
    LevelManager:loadLevels("levels")

    love.graphics.setBackgroundColor(53,118,143)
    font = love.graphics.newFont('fonts/font.ttf', 48)
    local PlayerLoadX, PlayerLoadY = MapSystem:returnTileCoors(4)
    Player:initialize(world, PlayerLoadX, PlayerLoadY, 32, 32)
end

function love.update(dt)
    if gameState == 'play' then
    Enemy:update(dt, Player.x, Player.y)

    Player:update(dt)
    Player:canPassLevel(MapSystem.itemCount)

    local width, height = MapSystem.tilewidth*MapSystem.mapwidth, MapSystem.tileheight*MapSystem.mapheight
    cam:setWorld(0, 0, width, height)
    debugX = cam:getCameraX() - cam.w / 2
    debugY = cam:getCameraY() - cam.h / 2        
    local var = Player:canPassLevel(MapSystem.itemCount)
    -- print(Player.keyCount, var, MapSystem.itemCount)

    end
end

function love.draw()
    cam:draw(function(l,t,w,h)
        Player:drawPlayer()
    
        MapSystem:drawTiles(tileset, Quads.quadInfo, Quads.quads)
        -- Player:drawDebugStrings(debugX, debugY)

        Enemy:drawEnemies()
    end)

    if gameState == "dead" then
        love.graphics.setColor(255,255,255)
        love.graphics.setFont(font)
        love.graphics.print("YOU'RE DEAD KIDDO", cam:getCameraX()-120, cam:getCameraY())
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'r' then
        local var = Player:canPassLevel(MapSystem.itemCount)
        if var then
            LevelManager:nextLevel(MapSystem.data)
            print(var, MapSystem.itemCount)
            local PlayerLoadX, PlayerLoadY = MapSystem:returnTileCoors(4)
            world:update(Player, PlayerLoadX, PlayerLoadY)
            Player:resetPlayer(PlayerLoadX, PlayerLoadY)
        end
    end

    Player:jump(key)
end