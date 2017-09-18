local class = require '../vendor/middleclass'
local Player = class('Player')
local step = 10

function Player:initialize()
    self.health = 100
    self.speed = 125
    self.isLoaded = true
    self.direction = "up"
    self.points = {}
    self.points[1] = {375,550}
end

function Player:updatePosition()

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

function Player:draw()

  if #self.points > 1 then
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

return Player
