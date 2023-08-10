Player = Class{}

local PLAYER_WIDTH = 64
local PLAYER_HEIGHT = 64
local PLAYER_SPEED = 200
local GRAVITY = 20
local JUMP_HEIGHT = -400
local ULT_DURATION = 10

function Player:init(x, y)
    self.x = x
    self.y = y
    self.dy = 0
    self.ultMode = false
    self.ultTimer = 0
    self.lastKey = ''
    self.score = 0
    self.image = textures['still']
end

function Player:update(dt)
    self:handleInput(dt)
    
    self.dy = self.dy + GRAVITY * dt
    self.y = self.y + self.dy * dt

    self.y = math.max(0, self.y)
    self.y = math.min(VIRTUAL_HEIGHT - PLAYER_HEIGHT, self.y)
end

function Player:handleInput(dt)
    if love.keyboard.isDown('a') then
        self.x = self.x - PLAYER_SPEED * dt
        self.image = textures['left']
        self.lastKey = 'a'
    elseif love.keyboard.isDown('d') then
        self.x = self.x + PLAYER_SPEED * dt
        self.image = textures['right']
        self.lastKey = 'd'
    else
        self.image = textures['still']
    end

    if self:collides(self.background) then
        self:handleCollision(self.background)
    end

    if love.keyboard.wasPressed('w') and self.y == VIRTUAL_HEIGHT - PLAYER_HEIGHT then
        self.dy = JUMP_HEIGHT
    end

    if self.ultMode then
        self.ultTimer = self.ultTimer - dt
        if self.ultTimer <= 0 then
            self.ultMode = false
        end
    end
end

function Player:render()
    if self.ultMode then
        if self.lastKey == 'a' then
            love.graphics.draw(textures['ultimateleft'], self.x, self.y)
        elseif self.lastKey == 'd' then
            love.graphics.draw(textures['ultimateright'], self.x, self.y)
        else
            -- Render default ultimate image
            -- ...
        end
    else
        love.graphics.draw(self.image, self.x, self.y)
    end
end

function Player:collides(object)
    return self.x + PLAYER_WIDTH > object.x and self.x < object.x + object.width and
           self.y + PLAYER_HEIGHT > object.y and self.y < object.y + object.height
end

function Player:handleCollision(object)
    if self.x + PLAYER_WIDTH > object.x and self.x < object.x + object.width then
        if self.y + PLAYER_HEIGHT > object.y and self.y < object.y + object.height then
            self.dy = 0
            self.y = object.y - PLAYER_HEIGHT
        end
    end
end

function Player:keypressed(key)
    if key == 'x' and self.score >= 600 then
        self.ultMode = true
        self.ultTimer = ULT_DURATION
        self.lastKey = ''
    end
end

function Player:keyreleased(key)
    -- Handle key release if needed
end
