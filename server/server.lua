local socket = require "socket"
local udp = socket.udp()
udp:settimeout(0)
udp:setsockname('*', 12345)

local world = {} -- the empty world-state
local numPlayers = 0
local data, msg_or_ip, port_or_nil
local entity, cmd, parms

local running = true

local colors = {
  {0, 0, 255},
  {255, 0, 0}
}

print "Beginning server loop."
while running do
  data, msg_or_ip, port_or_nil = udp:receivefrom()
	if data then
		-- more of these funky match paterns!

		cmd, player, parms = data:match("^(%S*)|(%S*)|(.*)")
    if cmd == 'new-player' then
      print (data)
      if not world[player] and numPlayers < 2 then
        local width, height = parms:match("^(%-?[%d.e]*),(%-?[%d.e]*)$")
        width, height = tonumber(width), tonumber(height)
        x = width/2
        if numPlayers == 0 then
          x = x - 10
        else
          x = x + 10
        end
        numPlayers = numPlayers + 1
        world[player] = {
          health = 1,
          x = x,
          y = height,
          color = colors[numPlayers]
        }
      end
    elseif cmd == 'move' then
      print (data)
      local x, y, health = parms:match("^(%-?[%d.e]*),(%-?[%d.e]*),(%-?[%d.e]*)$")
      assert(x and y and health) -- validation is better, but asserts will serve.
      -- don't forget, even if you matched a "number", the result is still a string!
      -- thankfully conversion is easy in lua.
      x, y, health = tonumber(x), tonumber(y), tonumber(health)
      -- and finally we stash it away
      if world[player] then
        local p = world[player]
        p.x = x
        p.y = y
        p.health = health
        world[player] = p
        print (player, p.health)
      end
    elseif cmd == 'update' then
      for k, v in pairs(world) do
        if v then
          udp:sendto(string.format("%s|%s|%d,%d,%d,%d,%d,%d", k, 'update', v.x, v.y,v.health, v.color[1],v.color[2], v.color[3]), msg_or_ip,  port_or_nil)
        end
      end
    elseif cmd == 'leave' then
      if player and world[player] then
        world[player] = nil
        numPlayers = numPlayers - 1
      end
    elseif cmd == 'quit' then
      running = false;
    else
    	--print("unrecognised command:", cmd)
    end
  elseif msg_or_ip ~= 'timeout' then
  	error("Unknown network error: "..tostring(msg))
  end

  socket.sleep(0.01)
end

print "Thank you."
