Coin = Class{}

function Coin:init(x, y)
    self.x = x
    self.y = y
    self.width = COIN_WIDTH
    self.height = COIN_HEIGHT
    
    self.animationFrames = {
        textures['coin1.png'],
        textures['coin2.png'],
        textures['coin3.png'],
        textures['coin4.png'],
        textures['coin5.png']
    }
    
    self.currentFrame = 1
    self.frameTimer = 0
    self.frameDuration = 0.5  -- Duration in seconds for each frame
    
    self.destroyed = false
end

function Coin:update(dt)
    self.frameTimer = self.frameTimer + dt
    
    if self.frameTimer >= self.frameDuration then
        self.frameTimer = self.frameTimer - self.frameDuration
        self.currentFrame = (self.currentFrame % #self.animationFrames) + 1
    end
end

function Coin:render()
    love.graphics.draw(self.animationFrames[self.currentFrame], self.x, self.y)
end
