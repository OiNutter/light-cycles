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

function Player:initialize(name, color, start, controls)
    self.name = name
    self.health = 1
    self.speed = 125
    self.isLoaded = true
    self.direction = "up"
    self.points = {}
    self.points[1] = {start[1],start[2]}
    self.color = color
    self.controls = controlSets[controls]
end

function Player:updatePosition()

  if self.health > 0 then
    last_point = self.points[#self.points]

    x = last_point[1]
    y = last_point[2]

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

function Player:checkCollision(otherPlayer)

  if #self.points > 1 then

    x = self.x
    y = self.y
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    -- Check for hitting edges
    if x == 0 or x == width or y == 0 or y == height then
      self.health = 0
    else
      -- Check for colliding with myself
      for i = 1,#self.points-1,1 do
        if self.points[i][1] == x and self.points[i][2] == y then
          self.health = 0
          break
        end
      end

      -- Check for colliding with opponent
      for i = 1,#otherPlayer.points,1 do
        if otherPlayer.points[i][1] == x and otherPlayer.points[i][2] == y then
          self.health = 0
          break
        end
      end
    end
  end
end

function Player:isAlive()
  return self.health > 0
end

return Player
