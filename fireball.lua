-- fireball.lua

Fireball = {}

function Fireball:new(x, y, direction)
    local fireball = {
        x = x,
        y = y,
        direction = direction, -- "left" or "right"
        isFalling = false,
        image = love.graphics.newImage("fireballright.png"), -- Default image
        collisionBox = {
            width = 40,  -- Adjust collision box size as needed
            height = 40 -- Adjust collision box size as needed
        }
    }
    setmetatable(fireball, self)
    self.__index = self
    return fireball
end

function Fireball:update(dt)
    if self.isFalling then
        self.y = self.y + 200 * dt -- Adjust falling speed as needed
        self.image = love.graphics.newImage("fireballdown.png")
    else
        if self.direction == "left" then
            self.x = self.x - 150 * dt -- Adjust horizontal speed as needed
            self.image = love.graphics.newImage("fireballleft.png")
        else
            self.x = self.x + 150 * dt -- Adjust horizontal speed as needed
            self.image = love.graphics.newImage("fireballright.png")
        end
    end
end

function Fireball:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Fireball:checkCollisionWithBackground(background)
    local fireballX = math.floor(self.x)
    local fireballY = math.floor(self.y)
    
    for yOffset = 0, self.collisionBox.height do
        for xOffset = 0, self.collisionBox.width do
            if background:checkCollision(fireballX + xOffset, fireballY + yOffset) then
                -- Handle collision with background
                -- Adjust collision logic as needed
                self.isFalling = false
                return
            end
        end
    end
    
    self.isFalling = true
end

function Fireball:checkCollisionWithPlayer(player)
    local playerRight = player.x + player.image:getWidth()
    local fireballRight = self.x + self.image:getWidth()
    
    if self.x < playerRight and fireballRight > player.x and self.y < player.y + player.image:getHeight() and self.y + self.image:getHeight() > player.y then
        -- Handle collision with player
        -- Adjust collision logic as needed
    end
end

return Fireball
