debug = true

local utf8 = require 'utf8'
local server, myPlayer, initTime
local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

function love.load()
    require("vendor/middleclass")
	  Player = require "classes/Player"
    --Map = require "classes/Map"

    love.graphics.setBackgroundColor(0,0,0)
    myPlayer = Player:new(
      {0,0,255,255},
      {(width/2)-10, height}
    )
    initTime = love.timer.getTime()
end

function love.keypressed(key)
      --[[if key == "backspace" then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(text, -1)

        if byteoffset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            text = string.sub(text, 1, byteoffset - 1)
        end
    elseif key == 'return' then
        myPlayer = Player:new(text)
        socket.
        text = ""
    elseif key == 'escape' then
        love.event.push('quit')
    end]]--
end

function love.update(dt)
    if myPlayer then
        myPlayer:checkDirection(map, dt)
        local currentTime = love.timer.getTime()
        local timeDelta = currentTime - initTime
        currentNumber = timeDelta
        if timeDelta >= 0.15 then
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

  if myPlayer and myPlayer:isAlive() then
    myPlayer:draw()
    myPlayer:checkCollision()
  end
end
