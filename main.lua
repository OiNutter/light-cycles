debug = true

local utf8 = require 'utf8'
local server, myPlayer, initTime
local width = love.graphics.getWidth()
local height = love.graphics.getHeight()
local mainFont = love.graphics.newFont("assets/flynn.otf", 20)

function love.load()
    require("vendor/middleclass")
	  Player = require "classes/Player"
    --Map = require "classes/Map"

    love.graphics.setBackgroundColor(0,0,0)

    love.graphics.setFont(mainFont)
end

function love.keypressed(key)
    if key == 'space' then
      myPlayer = Player:new(
        {0,0,255,255},
        {(width/2)-10, height}
      )
      initTime = love.timer.getTime()
    elseif key == 'escape' then
        love.event.push('quit')
    end
end

function love.update(dt)
    if myPlayer and myPlayer:isAlive() then
        myPlayer:checkDirection(map, dt)
        local currentTime = love.timer.getTime()
        local timeDelta = currentTime - initTime
        currentNumber = timeDelta
        if timeDelta >= 0.15 then
            myPlayer:checkCollision()
            myPlayer:updatePosition()
            initTime = love.timer.getTime()
        end
    end
end

function love.draw()
  cols = width/10
  rows = height/10

  love.graphics.setColor(255,255,255, 30);
  love.graphics.setLineWidth(0.1)
  for i = 1, cols, 1 do
    x = i
    love.graphics.line(x*10,0,x*10, height)
  end
  for j = 1, rows, 1 do
    y = j
    love.graphics.line(0, y*10,width, y*10)
  end

  if not myPlayer or not myPlayer:isAlive() then
      love.graphics.setColor(0,0,255)
      love.graphics.printf("Press Space To Begin:",0, height/2, width, "center")
  elseif myPlayer and myPlayer:isAlive() then
    myPlayer:draw()
  end
end
