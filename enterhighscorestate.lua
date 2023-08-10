
EnterHighscoreState = Class{__includes = BaseState}

local chars = {
    [1] = 65,
    [2] = 65,
    [3] = 65
}

local highlightedChar = 1

function EnterHighscoreState:enter(params)
    self.highscores = params.highscores
    self.score = params.score
    self.scoreIndex = params.scoreIndex
end

function EnterHighscoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
	sounds['select']:play()
        local name = string.char(chars[1]) .. string.char(chars[2]) .. string.char(chars[3])

        for index = 10, self.scoreIndex, -1 do
            self.highscores[index + 1] = {
                name = self.highscores[index].name,
                score = self.highscores[index].score
            }
        end


        self.highscores[self.scoreIndex].name = name
        self.highscores[self.scoreIndex].score = self.score

        local scores = ''

        for index = 1, 10 do
            scores = scores .. self.highscores[index].name .. '\n'
            scores = scores .. tostring(self.highscores[index].score) .. '\n'
        end

        love.filesystem.write('donkeykong.lst', scores)

        stateMachine:change('highscore', {
            highscores = self.highscores
        })
    end

    if love.keyboard.wasPressed('left') and highlightedChar > 1 then
	sounds['select']:play()
        highlightedChar = highlightedChar - 1
    elseif love.keyboard.wasPressed('right') and highlightedChar < 3 then
    	sounds['select']:play()
        highlightedChar = highlightedChar + 1
    end
    
    if love.keyboard.wasPressed('up') then
	sounds['select']:play()
        chars[highlightedChar] = chars[highlightedChar] + 1
        if chars[highlightedChar] > 90 then
            chars[highlightedChar] = 65
        end
    elseif love.keyboard.wasPressed('down') then
	sounds['select']:play()
        chars[highlightedChar] = chars[highlightedChar] - 1
        if chars[highlightedChar] < 65 then
            chars[highlightedChar] = 90
        end
    end
end

function EnterHighscoreState:render()
    love.graphics.setFont(fonts['medium'])
    love.graphics.printf('Your score: ' .. tostring(self.score), 0, 30,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(fonts['large'])
    
    if highlightedChar == 1 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.print(string.char(chars[1]), VIRTUAL_WIDTH / 2 - 44, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1, 1)

    if highlightedChar == 2 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.print(string.char(chars[2]), VIRTUAL_WIDTH / 2 - 6, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1, 1)

    if highlightedChar == 3 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.print(string.char(chars[3]), VIRTUAL_WIDTH / 2 + 32, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1, 1)
    
    love.graphics.setFont(fonts['small'])
    love.graphics.printf('Press Enter to confirm!', 0, VIRTUAL_HEIGHT - 18,
        VIRTUAL_WIDTH, 'center')
end
