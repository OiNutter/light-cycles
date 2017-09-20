debug = true

local utf8 = require 'utf8'
local myPlayer, udpUpdateTime, playerUpdateTime
local width = love.graphics.getWidth()
local height = love.graphics.getHeight()
local mainFont = love.graphics.newFont("assets/flynn.otf", 20)

local socket = require "socket"

-- the address and port of the server
local address, port = "localhost", 12345

local entity -- entity is what we'll be controlling
local updaterate = 0.1 -- how long to wait, in seconds, before requesting an update

local players = {}
local numPlayers = 0
local name

function love.load()
    require("vendor/middleclass")
	  Player = require "classes/Player"
    --Map = require "classes/Map"

    love.graphics.setBackgroundColor(0,0,0)
    love.graphics.setFont(mainFont)

    udp = socket.udp()
    udp:settimeout(0)
    udp:setpeername(address, port)
    udpUpdateTime = love.timer.getTime()
    playerUpdateTime = love.timer.getTime()
    text = ""
end

function love.textinput(t)
    if not myPlayer then
      text = text .. t
    end
end

function love.keypressed(key)
  if key == "backspace" then
    -- get the byte offset to the last UTF-8 character in the string.
    local byteoffset = utf8.offset(text, -1)

    if byteoffset then
        -- remove the last UTF-8 character.
        -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
        text = string.sub(text, 1, byteoffset - 1)
    end
  elseif key == 'return' and not myPlayer then
    local dg = string.format("new-player|%s|%f,%f", text, width, height)
    udp:send(dg)
    name = text
    text = ""
  elseif key == 'space' then

    local dg = string.format("reset|%s|", myPlayer.name)
    udp:send(dg)

  elseif key == 'escape' then
    love.event.push('quit')
  end
end

function love.update(dt)
  local currentTime = love.timer.getTime()
  local udpTimeDelta = currentTime - udpUpdateTime
  local playerTimeDelta = currentTime - playerUpdateTime

  if name then

    if myPlayer and myPlayer:isAlive() then
      myPlayer:checkDirection()
    end

    if udpTimeDelta >= 0.05 then
      local dg = string.format("update|%s|", name)
  		udp:send(dg)

      repeat
        data, msg = udp:receive()

        if data then -- you remember, right? that all values in lua evaluate as true, save nil and false?
          player, cmd, params = data:match("^(%S*)|(%S*)|(.*)")
          if cmd == 'update' then
            local x, y, health, r, g, b = params:match("^(%-?[%d.e]*),(%-?[%d.e]*),(%-?[%d.e]*),(%-?[%d.e]*),(%-?[%d.e]*),(%-?[%d.e]*)$")
            assert(x and y and health and r and g and b)
  			    x, y, health, r, g, b = tonumber(x), tonumber(y), tonumber(health), tonumber(r), tonumber(g), tonumber(b)

            if not players[player] then
              newPlayer = Player:new(
                player,
                {r,g,b,255},
                {x, y}
              )
              players[player] = newPlayer
              numPlayers = numPlayers + 1

              if player == name then
                myPlayer = newPlayer
                myPlayer:setControls(2)
              end
            end

            if player ~= name then
              players[player]:addPoint({x,y})
              if health ~= players[player].health then
                players[player].health = health
              end
            end
          elseif cmd == "reset" then
            print ('RESET')

            local startPos = myPlayer:reset()
            players = {
              name = myPlayer
            }
            udpUpdateTime = love.timer.getTime()
            playerUpdateTime = love.timer.getTime()
          else
            print("unrecognised command:", cmd, data)
          end

        elseif msg ~= 'timeout' then
  			  error("Network error: "..tostring(msg))
  		  end
  	  until not data

      udpUpdateTime = love.timer.getTime()
    end

    if playerTimeDelta >= 0.15 then

      -- Check players still alive?
      local gameOver = false

      for k,v in pairs(players) do
        gameOver = not v:isAlive()

        if gameOver then break end
      end

      if numPlayers == 2 and not gameOver then
        myPlayer:checkCollision(players)


        local position = myPlayer:updatePosition()

        if position then
          local dg = string.format("move|%s|%d,%d,%d", myPlayer.name, position.x, position.y, myPlayer.health)
          udp:send(dg)
        end
      end

      playerUpdateTime = love.timer.getTime()
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

  if numPlayers > 0 then

    -- Check players still alive?
    local gameOver = false

    for k,v in pairs(players) do
      gameOver = not v:isAlive()

      if gameOver then break end
    end

    if not gameOver then
      for k,v in pairs(players) do
        v:draw()
      end
    else

      local winner = nil
      for k,v in pairs(players) do
        if v:isAlive() then winner = v end
      end

      if winner then
        love.graphics.setColor(winner.color[1], winner.color[2], winner.color[3])
        love.graphics.printf(winner.name .. " wins",0, height/4, width, "center")
      else
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf("Draw",0, height/4, width, "center")
      end

      love.graphics.setColor(0,0,255)
      love.graphics.printf("Press Space To Restart",0, height/2, width, "center")

    end

  else
    love.graphics.setColor(0,0,255)
    love.graphics.printf("Please enter your name",0, height/3, width, "center")
    love.graphics.printf(text, width/4, (height/3)*2, width/2, "center")
    love.graphics.rectangle("line", width/4, (height/3)*2, width/2,25)
  end
end

function love.quit()
  local dg = string.format("leave|%s|", name)
  udp:send(dg)
end
