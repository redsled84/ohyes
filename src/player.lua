local class = require 'lib.middleclass'
local inspect = require 'lib.inspect'
local Blocks = require 'src.blocks'
local MapSystem = require 'src.mapsystem'
local Entity = require 'src.entity'
local Player = class('Player', Entity)

local frc, acc, dec, top, low = 700, 500, 6000, 350, 50
local jumpAccel = -100

function Player:initialize(world, x,y,w,h)
    Entity.initialize(self, world, x, y, w, h)
    self.jumpFactor = -435
    self.jumpCount, self.jumpCountMax = 0, 2
    self.keyCount = 0
    self.isDoor = false
    self.onGround = false
end

local function collisionFilter(item, other)
    return 'slide'
end

function Player:changeVelocityByKeys(dt)
    local lk = love.keyboard
    local vx, vy = self.vx, self.vy

    if lk.isDown('right') then
        if vx < 0 then
            vx = vx + dec * dt
        elseif vx < top then
            vx = vx + acc * dt
        end
    elseif lk.isDown('left') then
        if vx > 0 then
            vx = vx - dec * dt
        elseif vx > -top then
            vx = vx - acc * dt
        end
    else
        if math.abs(vx) < low then
            vx = 0
        elseif vx > 0 then
            vx = vx - frc * dt
        elseif vx < 0 then
            vx = vx + frc * dt
        end
    end

    self.vx, self.vy = vx, vy
end

function Player:checkIfOnGround(ny)
    if ny < 0 then self.onGround = true end
end

function Player:checkJumpCount(ny)
    if ny < 0 then self.jumpCount = 0 end
end

function Player:setPosition(x, y) 
    self.x, self.y = x, y
end

local debugStr = {'','','','',''}

function Player:moveCollide(dt)
    local world = self.world
    self.onGround = false

    local futureX, futureY = self.x + (self.vx * dt), self.y + (self.vy * dt)
    local nextX, nextY, cols, len = world:move(self, futureX, futureY, collisionFilter)

    for i=1, len do
        local col = cols[i]
        if col.other.type == 'Key' then
            self:addKey()
            world:remove(col.other)
            MapSystem:removeTile(col.other.x, col.other.y)
        end
        if col.other.type == 'Door' then
            self.isDoor = true
        else
            self.isDoor = false
        end

        if col.other.type == 'Enemy' then
            gameState = "dead"
        end

        local tileIndex = MapSystem:getTileIndex(col.other.x, col.other.y)
        debugStr[5] = 'Current: '..col.other.type..' x: '..col.other.x..' y: '..col.other.y..' i: '..tileIndex
        
        self:changeVelocityByCollisionNormal(col.normal.x, col.normal.y, bounciness)
        self:checkIfOnGround(col.normal.y)
        self:checkJumpCount(col.normal.y)
    end

    self.x, self.y = nextX, nextY
end

function Player:addKey()
    if self.keyCount ~= nil then
        self.keyCount = self.keyCount + 1
    else
        self.keyCount = 1
    end 
end

function Player:canPassLevel(maxItemCount)
    if self.keyCount ~= nil then
        if self.keyCount >= maxItemCount and self.isDoor then
            return true
        else
            return false
        end
    end
end

function Player:resetValues()
    self.xvel, self.yvel = 0, 0
    self.keyCount = 0
end

function Player:resetPlayer(x, y)
    local x = x or 0
    local y = y or 0
    self:setPosition(x, y)
    self:resetValues()
end

function Player:jump(key)
    if (key == ' ' or key == 'up') and 
        (self.onGround or self.jumpCount < self.jumpCountMax) then
        if self.jumpCount < 1 then
            self.vy = self.jumpFactor
        else
            self.vy = self.jumpFactor - 50
        end
        self.jumpCount = self.jumpCount + 1
    end
end

function Player:shootArrow(key)
    if key == "s" then
        return true
    end
end

function Player:cameraLogic(cam)
    cam:setX(self.x)
    cam:setY(self.y)
end

function Player:update(dt)
    Player:changeVelocityByGravity(dt)
    Player:changeVelocityByKeys(dt)
    Player:moveCollide(dt)
    Player:cameraLogic(cam)
end

function Player:drawPlayer()
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end

function Player:drawDebugStrings(x, y)
    for i=1, #debugStr do
        love.graphics.print(debugStr[i], x+15, y+15*i)
    end
end

return Player