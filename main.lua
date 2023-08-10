push = require 'push'
Class = require 'class'
require 'background'
require 'coin'
require 'enterhighscorestate'
require 'fireball'
require 'gamestate'
require 'gamestatebackground'
require 'garmadon'
require 'highscorestate'
require 'player'
require 'princess'
require 'startstate'
require 'statemachine'
require 'basestate'
function love.load()
	
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = true,
		vsync = true
	})
	
	io.stdout:setvbuf("no")
	
	love.graphics.setDefaultFilter('nearest', 'nearest')
	
	love.window.setTitle('donkeykong')
	
	math.randomseed(os.time())
	
	fonts = {
		['large'] = love.graphics.newFont('font.ttf', 32),
		['medium'] = love.graphics.newFont('font.ttf', 16),
		['small'] = love.graphics.newFont('font.ttf', 8)
	}
	
	sounds = {
		['jump'] = love.audio.newSource('jump.wav', 'static'),
		['death'] = love.audio.newSource('death.wav', 'static'),
		['levelcomplete'] = love.audio.newSource('levelcomplete.wav', 'static'),
		
		--https://freesound.org/people/Duisterwho/sounds/643569/
		['music'] = love.audio.newSource('ninjago.mp3', 'static')
	}
	
	sounds['music']:setLooping(true)
	sounds['music']:play()
	
	textures = {
		['background'] = love.graphics.newImage('background.png'),
		['coin1'] = love.graphics.newImage('coin1.png'),
		['coin2'] = love.graphics.newImage('coin2.png'),
		['coin3'] = love.graphics.newImage('coin3.png'),
		['coin4'] = love.graphics.newImage('coin4.png'),
		['coin5'] = love.graphics.newImage('coin5.png'),
		['donkeykongtext'] = love.graphics.newImage('donkeykongtext.png'),
		['exit'] = love.graphics.newImage('exit.png'),
		['exit1'] = love.graphics.newImage('exit1.png'),
		['fireballdown'] = love.graphics.newImage('fireballdown.png'),
		['fireballleft'] = love.graphics.newImage('fireballleft.png'),
		['fireballright'] = love.graphics.newImage('fireballright.png'),
		['kong0'] = love.graphics.newImage('kong0.png'),
		['kongstill1'] = love.graphics.newImage('kongstill1.png'),
		['right'] = love.graphics.newImage('right.png'),
		['left'] = love.graphics.newImage('left.png'),
		['still'] = love.graphics.newImage('still.png'),
		['ultimateleft'] = love.graphics.newImage('ultimateleft.png'),
		['ultimateright'] = love.graphics.newImage('ultimateright.png'),
		['princess'] = love.graphics.newImage('princess.png'),
	}
	
	
	
	
	
	
	stateMachine = StateMachine {
		['startstate'] = function() return StartMenuState() end,
		['gamestate'] = function() return PlayState() end,
		['highscorestate'] = function() return GameOverState() end,
		['enterhighscorestate'] = function() return HighscoreState() end
		
	}
	
	stateMachine:change('startstate', {
		highscores = loadHighscores()
	})
	
	love.keyboard.keysPressed = {}
	
end

function love.update(dt)
	stateMachine:update(dt)
	
	love.keyboard.keysPressed = {}
end

function love.resize(width, height)
	push:resize(width, height)
end

function love.keypressed(key)
	love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.draw()
	push:start()
	
	local backgroundWidth = textures['background']:getWidth()
	local backgroundHeight = textures['background']:getHeight()
	
	love.graphics.draw(textures['background'], 0, 0, 0, VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))
	
	stateMachine:render()
	
	push:finish()
end
function renderScore(score)
	love.graphics.setFont(fonts['small'])
	love.graphics.print('Score: ', VIRTUAL_WIDTH - 100, 5)
	love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 50, 5, 40, 'right')
end
function loadHighscores()
	love.filesystem.setIdentity('donkeykong')
	
	if not love.filesystem.getInfo('donkeykong.lst') then
		local scores = ''
		for index = 10, 1, -1 do
			scores = scores .. 'NAM\n'
			scores = scores .. 0 .. '\n'
		end
		
		love.filesystem.write('donkeykong.lst', scores)
	end
	local name = true
	local currentName = nil
	local counter = 1
	
	local scores = {}
	
	for index = 1, 10 do
		scores[index] = {
			name = nil,
			score = nil
		}
	end
	
	for line in love.filesystem.lines('donkeykong.lst') do
		if name then
			scores[counter].name = string.sub(line, 1, 3)
		else
			scores[counter].score = tonumber(line)
			counter = counter + 1
		end
		
		name = not name
	end
	
	return scores
end
