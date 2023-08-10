-- background.lua

Background = {}

function Background:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.image = love.graphics.newImage("background.png")

    return obj
end

function Background:draw()
    love.graphics.draw(self.image, 0, 0)
end

return Background
