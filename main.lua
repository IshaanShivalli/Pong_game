WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

push = require 'push'
Class = require 'class'
require 'Paddle'
require 'Ball'


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    scoreFont = love.graphics.newFont('font.ttf', 32)
    largeFont = love.graphics.newFont('font.ttf', 16)
    smallFont = love.graphics.newFont('font.ttf', 8)

    love.window.setTitle('Pong')
    math.randomseed(os.time())
    player1Score = 0
    player2Score = 0

    servingPlayer = 1
    winningPlayer = 0
    player1 = Paddle(10, VIRTUAL_HEIGHT / 2 - 10, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT / 2 - 10, 5, 20)

    sounds = {
        ['paddle_impact'] = love.audio.newSource('sounds/paddle_impact.wav', 'static'),
        ['wall_impact'] = love.audio.newSource('sounds/wall_impact.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static')
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4, servingPlayer)

    gameState = 'start'
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end
    paddleCenter = player2.y + player2.h / 2
    offset = math.random(-6, 6)
    target = ball.y + offset
    distance = target - paddleCenter
    AI_SPEED = 220

    if ball.dx > 0 then
        player2.dy = distance * 7.5
        if player2.dy > AI_SPEED then
            player2.dy = AI_SPEED
        elseif player2.dy < -AI_SPEED then
            player2.dy = -AI_SPEED
        end
    else
        player2.dy = 0
    end

    player1:update(dt)
    player2:update(dt)

    if gameState == 'serve' then
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = -math.random(140, 200)
        elseif servingPlayer == 2 then
            ball.dx = math.random(140, 200)
        end

    elseif gameState == 'play' then

        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else 
                ball.dy = math.random(10, 150)
            end
            sounds['paddle_impact']:play()
        end

        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else 
                ball.dy = math.random(10, 150)
            end
            sounds['paddle_impact']:play()
        end

        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_impact']:play()
        end

        if ball.y >= VIRTUAL_HEIGHT - ball.h then
            ball.y = VIRTUAL_HEIGHT - ball.h
            ball.dy = -ball.dy
            sounds['wall_impact']:play()
        end

        if ball.x < 0 then
            player2Score = player2Score + 1
            servingPlayer = 1
            ball:reset(servingPlayer)
            gameState = 'serve'
            sounds['score']:play()
        end

        if ball.x > VIRTUAL_WIDTH then
            player1Score = player1Score + 1
            servingPlayer = 2
            ball:reset(servingPlayer)
            gameState = 'serve'
            sounds['score']:play()
        end

        if player1Score >= 10 then
            winningPlayer = 1
            gameState = 'done'
        elseif player2Score >= 10 then
            winningPlayer = 2
            gameState = 'done'
        end

        ball:update(dt)
    end
end


function love.keypressed(key)

    if key == 'escape' then
        love.event.quit()

    elseif key == 'enter' or key == 'return' then

        if gameState == 'start' then
            gameState = 'serve'

        elseif gameState == 'serve' then
            gameState = 'play'

        elseif gameState == 'done' then
            player1Score = 0
            player2Score = 0
            winningPlayer = 0
            servingPlayer = math.random(2)
            ball:reset(servingPlayer)
            gameState = 'serve'
        end
    end
end


function love.draw()
    push:start()

    love.graphics.clear(40/255, 45/255, 52/255, 1)

    scoreText = tostring(player1Score) .. "  " .. tostring(player2Score)
    textWidth = scoreFont:getWidth(scoreText)

    love.graphics.setFont(scoreFont)
    love.graphics.print(scoreText,
        VIRTUAL_WIDTH / 2 - textWidth / 2,
        80
    )

    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf("WELCOME TO PONG!", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Enter to Start!", 0, 20, VIRTUAL_WIDTH, 'center')

    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf(
            "Player " .. servingPlayer .. "'s serve!",
            0, 10, VIRTUAL_WIDTH, 'center'
        )

    elseif gameState == 'done' then
        love.graphics.setFont(smallFont)
        love.graphics.printf(
            "Player " .. winningPlayer .. " wins!",
            0, 10, VIRTUAL_WIDTH, 'center'
        )

        love.graphics.setFont(smallFont)
        love.graphics.printf("Press Enter to restart!", 0, 30, VIRTUAL_WIDTH, 'center')
    end

    player1:render()
    player2:render()
    ball:render()

    push:finish()
end