local class = require '../vendor/middleclass'
local Player = class('Player')
local step = 10

function Player:initialize(color, start)
    self.health = 1
    self.speed = 125
    self.isLoaded = true
    self.direction = "up"
    self.points = {}
    self.points[1] = {start[1],start[2]}
    self.color = color
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
  end
end

function Player:checkDirection(map, dt)

    if love.keyboard.isDown('left','a') then
        self.direction = "left"
    elseif love.keyboard.isDown('right','d') then
        self.direction = "right"
    elseif love.keyboard.isDown('up','w') then
        self.direction = "up"
    elseif love.keyboard.isDown('down','s') then
        self.direction = "down"
    end

end

function Player:checkCollision()

  if #self.points > 1 then
    last_point = self.points[#self.points]

    x = last_point[1]
    y = last_point[2]
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    -- Check for hitting edges
    if x == 0 or x == width or y == 0 or y == height then
      print ('WALL COLLISION')
      self.health = 0
    else
      for i = 1,#self.points-1,1 do
        print(self.points[i][1], self.points[2])
        if self.points[i][1] == x and self.points[i][2] == y then
          self.health = 0
          print ('SELF COLLLISION')
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
