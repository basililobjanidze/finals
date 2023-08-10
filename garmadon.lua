Garmadon = Class{}

local GARMADON_WIDTH = 64
local GARMADON_HEIGHT = 64
local GARMADON_SWITCH_INTERVAL_MIN = 3
local GARMADON_SWITCH_INTERVAL_MAX = 7

function Garmadon:init(x, y)
    self.x = x
    self.y = y
    self.width = GARMADON_WIDTH
    self.height = GARMADON_HEIGHT
    self.image = textures['kongstill1']
    self.timer = love.math.random(GARMADON_SWITCH_INTERVAL_MIN, GARMADON_SWITCH_INTERVAL_MAX)
end

function Garmadon:spawnFireball()
    local fireball = Fireball(self.x + self.width, self.y + self.height / 2)
    table.insert(fireballs, fireball)
end

function Garmadon:update(dt)
    self.timer = self.timer - dt
    if self.timer <= 0 then
        self:switchImage()
        self:spawnFireball()  -- Spawn a fireball when switching image
        self.timer = love.math.random(GARMADON_SWITCH_INTERVAL_MIN, GARMADON_SWITCH_INTERVAL_MAX)
    end

    -- Update fireballs
    for i, fireball in ipairs(fireballs) do
        fireball:update(dt)
        if fireball.x > VIRTUAL_WIDTH or fireball:collides(self.background) then
            table.remove(fireballs, i)
        end
    end
end

function Garmadon:render()
    love.graphics.draw(self.image, self.x, self.y)
    
    -- Render fireballs
    for _, fireball in ipairs(fireballs) do
        fireball:render()
    end
end

function Garmadon:collides(object)
    return self.x + GARMADON_WIDTH > object.x and self.x < object.x + object.width and
           self.y + GARMADON_HEIGHT > object.y and self.y < object.y + object.height
end

function Garmadon:switchImage()
    if self.image == textures['kongstill1'] then
        self.image = textures['kong0']
    else
        self.image = textures['kongstill1']
    end
end
