debug = true

local utf8 = require 'utf8'
local server, player1, player2, initTime
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
      player1 = Player:new(
        "Player 1",
        {0,0,255,255},
        {(width/2)-10, height},
        1
      )
      player2 = Player:new(
        "Player 2",
        {255,0,0,255},
        {(width/2)+10, height},
        2
      )
      initTime = love.timer.getTime()
    elseif key == 'escape' then
        love.event.push('quit')
    end
end

function love.update(dt)
    if player1 and player1:isAlive() and player2 and player2:isAlive() then
        player1:checkDirection(map, dt)
        player2:checkDirection(map, dt)
        local currentTime = love.timer.getTime()
        local timeDelta = currentTime - initTime
        currentNumber = timeDelta
        if timeDelta >= 0.15 then
            player1:checkCollision(player2)
            player2:checkCollision(player1)
            player1:updatePosition()
            player2:updatePosition()
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

  if player1 and player1:isAlive() and player2 and player2:isAlive() then
    player1:draw()
    player2:draw()
  else
      if player1 and player2 then
        local winner
        if player1:isAlive() and not player2:isAlive() then
          print ("player 1")
          print ("player 2")
          winner = player1
        elseif player2:isAlive() and not player1:isAlive() then
          winner = player2
        else
          winner = nil
        end

        if winner then
          love.graphics.setColor(winner.color[1], winner.color[2], winner.color[3])
          love.graphics.printf(winner.name .. " wins",0, height/4, width, "center")
        else
          love.graphics.setColor(255, 255, 255)
          love.graphics.printf("Draw",0, height/4, width, "center")
        end

      end

      love.graphics.setColor(0,0,255)
      love.graphics.printf("Press Space To Begin",0, height/2, width, "center")
  end
end
