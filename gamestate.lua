-- gamestate.lua
require 'player'
require 'princess'
require 'garmadon'
require 'coin'
require 'fireball'
require 'gamestatebackground'

GameState = Class{}

function GameState:init()
    -- Initialize player, princess, garmadon, fireballs, coins, and other variables
    self.player = Player(0, VIRTUAL_HEIGHT - PLAYER_HEIGHT)
    self.princess = Princess(0, 0)
    self.garmadon = Garmadon(VIRTUAL_WIDTH - GARMADON_WIDTH, 0)
    self.background = GameStateBackground()
    self.fireballs = {}  -- Table to store fireball instances
    self.coins = {}  -- Table to store coin instances
    
    -- Initialize other gamestate variables
    self.ultimateSound = love.audio.newSource('ultimate.wav', 'static')
    self.deathSound = love.audio.newSource('death.wav', 'static')
    -- Initialize level completed sound
    self.levelCompletedSound = love.audio.newSource('levelcompleted.wav', 'static')
end

function GameState:update(dt)
    self.player:update(dt)
    self.princess:update(dt)
    self.garmadon:update(dt)
    
    -- Update fireball instances
    for i, fireball in ipairs(self.fireballs) do
        fireball:update(dt)
        if fireball.y > VIRTUAL_HEIGHT then
            table.remove(self.fireballs, i)
        end
    end
    
    -- Update coin instances
    for i, coin in ipairs(self.coins) do
        coin:update(dt)
        if coin.y > VIRTUAL_HEIGHT then
            table.remove(self.coins, i)
        end
    end
    
    -- Check for collisions and other game logic
    self:checkCollisions()
    
    -- Handle player ultimate ability
    if self.player.score >= 600 and love.keyboard.wasPressed('x') then
        self.player:activateUltimate()
        love.audio.play(self.ultimateSound)
    end
    
    -- Spawning fireballs
    if math.random() < dt * FIREBALL_SPAWN_CHANCE then
        local fireballX = math.random(VIRTUAL_WIDTH - FIREBALL_WIDTH)
        local fireballY = 0
        local fireball = Fireball(fireballX, fireballY)
        table.insert(self.fireballs, fireball)
    end
    
    -- Spawning coins
    if math.random() < dt * COIN_SPAWN_CHANCE then
        local coinX = math.random(VIRTUAL_WIDTH - COIN_WIDTH)
        local coinY = math.random(VIRTUAL_HEIGHT - COIN_HEIGHT)
        local coin = Coin(coinX, coinY)
        table.insert(self.coins, coin)
    end
end

function GameState:checkCollisions()
    -- Check player collision with objects
    if self.player:collides(self.princess) then
        love.audio.play(self.levelCompletedSound)
        stateMachine:change('enterhighscore', {
            score = self.player.score
        })
    end
    
    if self.player:collides(self.garmadon) then
        love.audio.play(self.deathSound)
        stateMachine:change('enterhighscore', {
            score = self.player.score
        })
    end
    
    -- Check fireball collision with player
    for i, fireball in ipairs(self.fireballs) do
        if fireball:collides(self.player) then
            if self.player.isUltimate then
                table.remove(self.fireballs, i)
            else
                love.audio.play(self.deathSound)
                stateMachine:change('enterhighscore', {
                    score = self.player.score
                })
            end
        end
    end
    
    -- Check coin collision with player
    for i, coin in ipairs(self.coins) do
        if coin:collides(self.player) then
            self.player:addScore(100)
            table.remove(self.coins, i)
        end
    end
end

function GameState:render()
    -- Render background
    self.background:render()
    
    -- Render game objects
    self.princess:render()
    self.garmadon:render()
    self.player:render()
    
    -- Render fireball instances
    for _, fireball in ipairs(self.fireballs) do
        fireball:render()
    end
    
    -- Render coin instances
    for _, coin in ipairs(self.coins) do
        coin:render()
    end
    
    -- Render other game elements (score, ult timer, etc.)
    love.graphics.setFont(fonts['small'])
    love.graphics.print('Score: ' .. self.player.score, VIRTUAL_WIDTH - 100, 5)
    
    if self.player.isUltimate then
        love.graphics.print('Ultimate: ' .. math.ceil(self.player.ultTimer), VIRTUAL_WIDTH - 100, 20)
    end
    
    -- ...
end
