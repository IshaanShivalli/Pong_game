Ball = Class{}

function Ball:init(x, y, w, h, sevingPlayer)
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    self.speed = 120
    self:reset(sevingPlayer)
end


function Ball:collides(paddle)
    if self.x >= paddle.x + paddle.w or paddle.x >= self.x + self.w then
        return false
    end

    if self.y >= paddle.y + paddle.h or paddle.y >= self.y + self.h then
        return false
    end
    return true
end


function Ball:reset(servingPlayer)
    self.x = VIRTUAL_WIDTH/2 - self.w / 2 
    self.y = VIRTUAL_HEIGHT/2 - self.h/2

    angle = math.rad(math.random(-45, 45))

    local direction
    
    if sevingPlayer == 1 then
        direction = 1
    elseif sevingPlayer == 2 then
        direction = -1
    else 
        direction = math.random(2) == 1 and 1 or -1
    end

    self.dx = math.cos(angle) * self.speed * direction
    self.dy = math.sin(angle) * self.speed
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end
