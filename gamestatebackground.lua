GameStateBackground = Class{}

function GameStateBackground:init()
    self.image = textures['gamestatebackground.png']
end

function GameStateBackground:render()
    love.graphics.draw(self.image, 0, 0)
end

function GameStateBackground:collides(object)
    return not (object.x > VIRTUAL_WIDTH or
                object.x + object.width < 0 or
                object.y > VIRTUAL_HEIGHT or
                object.y + object.height < 0)
end
