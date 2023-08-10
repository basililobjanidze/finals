Princess = Class{}

function Princess:init(x, y)
    self.x = x
    self.y = y
    self.width = PRINCESS_WIDTH
    self.height = PRINCESS_HEIGHT
    
    self.image = textures['princess.png']
    
    self.gravity = true
    self.gravityAmount = 600
    
    self.destroyed = false
end

function Princess:update(dt)
    if not self.destroyed then
        -- Apply gravity
        if self.gravity then
            self.y = self.y + self.gravityAmount * dt
        end
    end
end

function Princess:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Princess:collides(object)
    return not (self.x > object.x + object.width or
                self.x + self.width < object.x or
                self.y > object.y + object.height or
                self.y + self.height < object.y)
end
