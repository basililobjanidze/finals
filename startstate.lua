-- startstate.lua
require 'class'
Startstate = Class{}
-- Load the font
local font = love.graphics.newFont("font.ttf", 20)
love.graphics.setFont(font)

-- Load the music
local music = love.audio.newSource("ninjago.mp3", "stream")
music:setLooping(true)
music:play()

-- Load the Donkey Kong text image
local donkeyKongText = love.graphics.newImage("donkeykongtext.png")

-- Load the start button images
local startButtonImage = love.graphics.newImage("start.png")
local startButtonHoverImage = love.graphics.newImage("start1.png")

local startButtonX = (love.graphics.getWidth() - startButtonImage:getWidth()) / 2
local startButtonY = love.graphics.getHeight() / 2 + 50

local isStartButtonHovered = false

-- Load the exit button images
local exitButtonImage = love.graphics.newImage("exit.png")
local exitButtonHoverImage = love.graphics.newImage("exit1.png")

local exitButtonX = (love.graphics.getWidth() - exitButtonImage:getWidth()) / 2
local exitButtonY = love.graphics.getHeight() / 2 + 100

local isExitButtonHovered = false

require "background"

background = Background:new()

function love.update(dt)
    local mouseX, mouseY = love.mouse.getPosition()
    
    -- Update button hover state
    isStartButtonHovered = mouseX >= startButtonX and mouseX <= startButtonX + startButtonImage:getWidth() and
                           mouseY >= startButtonY and mouseY <= startButtonY + startButtonImage:getHeight()

    isExitButtonHovered = mouseX >= exitButtonX and mouseX <= exitButtonX + exitButtonImage:getWidth() and
                          mouseY >= exitButtonY and mouseY <= exitButtonY + exitButtonImage:getHeight()
end

function love.draw()
    -- Draw the background
    background:draw()

    -- Draw Donkey Kong text
    local textX = (love.graphics.getWidth() - donkeyKongText:getWidth()) / 2
    local textY = 50
    love.graphics.draw(donkeyKongText, textX, textY)

    -- Draw Start button
    local startButtonImageToShow = isStartButtonHovered and startButtonHoverImage or startButtonImage
    love.graphics.draw(startButtonImageToShow, startButtonX, startButtonY)

    -- Draw Exit button
    local exitButtonImageToShow = isExitButtonHovered and exitButtonHoverImage or exitButtonImage
    love.graphics.draw(exitButtonImageToShow, exitButtonX, exitButtonY)

    -- Draw "HS" text in bottom right corner
    local hsText = "HS"
    local hsTextWidth = font:getWidth(hsText)
    local hsTextHeight = font:getHeight(hsText)
    love.graphics.print(hsText, love.graphics.getWidth() - hsTextWidth - 20, love.graphics.getHeight() - hsTextHeight - 20)
end

function love.mousepressed(x, y, button)
    if button == 1 then
        if isStartButtonHovered then
            love.audio.stop(music)  -- Stop the music before transitioning to gamestate
            require "gamestate"
            love.load()
            love.update(0)  -- Update once to ensure a smooth transition
            love.draw()
        elseif isExitButtonHovered then
            love.event.quit()  -- Close the game if Exit button is pressed
        else
            -- Check if HS text is pressed
            local hsTextWidth = font:getWidth("HS")
            local hsTextHeight = font:getHeight("HS")
            local hsTextX = love.graphics.getWidth() - hsTextWidth - 20
            local hsTextY = love.graphics.getHeight() - hsTextHeight - 20
            if x >= hsTextX and x <= hsTextX + hsTextWidth and y >= hsTextY and y <= hsTextY + hsTextHeight then
                love.audio.stop(music)  -- Stop the music before transitioning to highscoresstate
                require "highscoresstate"
                love.load()
                love.update(0)  -- Update once to ensure a smooth transition
                love.draw()
            end
        end
    end
end
