debug = true

local utf8 = require 'utf8'
local server, myPlayer, map, initTime

function love.load()
    require("vendor/middleclass")
	  Player = require "classes/Player"
    --Map = require "classes/Map"

    love.graphics.setBackgroundColor(0,0,0)
    love.graphics.setColor(0,0,255);
    myPlayer = Player:new()
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
        if timeDelta >= 0.25 then
            myPlayer:updatePosition()
            initTime = love.timer.getTime()
        end
    end
end

function love.draw()
  if myPlayer then
    myPlayer:draw()
  end
end
