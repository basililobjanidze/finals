-- highscorestate.lua

HighscoreState = {}

function HighscoreState:enter(params)
    self.highscores = params.highscores
end

function HighscoreState:update(dt)
    if love.keyboard.wasPressed('escape') then
        sounds['select']:play()
        stateMachine:change('start-menu', {
            highscores = self.highscores
        })
    end
end

function HighscoreState:render()
    love.graphics.setFont(fonts['large'])
    love.graphics.printf('Highscores', 0, 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(fonts['small'])

    for index = 1, 10 do
        local name = self.highscores[index].name or '_'
        local score = self.highscores[index].score or '_'

        love.graphics.printf(tostring(index) .. '.', VIRTUAL_WIDTH / 4, 
            60 + index * 13, 50, 'left')

        love.graphics.printf(name, VIRTUAL_WIDTH / 4 + 38, 
            60 + index * 13, 50, 'right')
        
        love.graphics.printf(tostring(score), VIRTUAL_WIDTH / 2,
            60 + index * 13, 100, 'right')
    end

    love.graphics.setFont(fonts['small'])
    love.graphics.printf("Press Escape to return to the main menu!",
        0, VIRTUAL_HEIGHT - 18, VIRTUAL_WIDTH, 'center')
end

return HighscoreState
