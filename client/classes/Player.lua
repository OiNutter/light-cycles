local class = require '../vendor/middleclass'
local Player = class('Player')
local step = 10
local controlSets = {
  {
    ["left"]   = "a",
    ["up"]     = "w",
    ["right"] = "d",
    ["down"] = "s"
  },
  {
    ["left"]   = "left",
    ["up"]     = "up",
    ["right"] = "right",
    ["down"] = "down"
  }
}
local startPos

function Player:initialize(name, color, start, controls)
    self.name = name
    self.health = 1
    self.speed = 125
    self.isLoaded = true
    self.direction = "up"
    self.points = {}
    startPos = start
    self.points[1] = {start[1],start[2]}
    self.color = color
    if controls then self.controls = controlSets[controls] end
end

function Player:setControls(controls)
  if controls then self.controls = controlSets[controls] end
end

function Player:updatePosition()

  last_point = self.points[#self.points]

  x = last_point[1]
  y = last_point[2]

  if self.health > 0 then

    if self.direction == "left" then
      x = x - step
    elseif self.direction == "right" then
      x = x + step
    elseif self.direction == "up" then
      y = y - step
    elseif self.direction == "down" then
      y = y + step
    end

    self.points[#self.points+1] = {x, y}

  end

  return {x=x, y=y}
end

function Player:draw()
  if #self.points > 1 then
    love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.color[4])
    love.graphics.setLineWidth(2)
    for i = 2,#self.points,1 do
      love.graphics.line(
        self.points[i-1][1],
        self.points[i-1][2],
        self.points[i][1],
        self.points[i][2]
      )
    end

    self.x = self.points[#self.points][1]
    self.y = self.points[#self.points][2]
  end
end

function Player:checkDirection(map, dt)

    if love.keyboard.isDown(self.controls["left"]) and self.direction ~= "right" then
        self.direction = "left"
    elseif love.keyboard.isDown(self.controls["right"]) and self.direction ~= "left" then
        self.direction = "right"
    elseif love.keyboard.isDown(self.controls["up"]) and self.direction ~= "down" then
        self.direction = "up"
    elseif love.keyboard.isDown(self.controls["down"]) and self.direction ~= "up" then
        self.direction = "down"
    end

end

function Player:checkCollision(players)

  if #self.points > 1 then

    x = self.x
    y = self.y
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    -- Check for hitting edges
    if x == 0 or x == width or y == 0 or y == height then
      self.health = 0
      print ('WALL')
    else
      -- Check for colliding with myself
      for i = 1,#self.points-1,1 do
        print(self.points[i])
        if self.points[i][1] == x and self.points[i][2] == y then
          self.health = 0
          print('SELF')
          break
        end
      end

      -- Check for colliding with opponents
      for k,v in pairs(players) do
        if k ~= self.name then
          for i = 1,#v.points,1 do
            if v.points[i][1] == x and v.points[i][2] == y then
              self.health = 0
              print('OPPONENT')
              break
            end
          end
        end
      end
    end
  end
end

function Player:isAlive()
  return self.health > 0
end

function Player:addPoint(point)
  last_point = self.points[#self.points]
  if point[1] ~= last_point[1] or point[2] ~= last_point[2] then
    self.points[#self.points+1] = point
  end
end

function Player:reset()
  self.direction = "up"
  self.points = {}
  self.health = 1
  self.points[1] = {startPos[1],startPos[2]}
  self.x = nil
  self.y = nil
  return {x=startPos[1], y=startPos[2]}
end

return Player
