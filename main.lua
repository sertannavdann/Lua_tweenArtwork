--[[
    GD50
    chain1

    Example used to showcase a way of moving something from point to point using
    the Timer:finish function.
]]

push = require 'push'
Timer = require 'knife.timer'

VIRTUAL_WIDTH = 1920
VIRTUAL_HEIGHT = 1080

WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080

-- seconds it takes to move each step
MOVEMENT_TIME = 2 * (math.random() + 1)

function love.load()
    
    -- all of the intervals for our labels
    intervals = {2, 4, 6, 12}

    -- all of the counters for our labels
    counters = {0, 0, 0, 0}

    -- create Timer entries for each interval and counter
    for i = 1, 4 do
        -- anonymous function that gets called every intervals[i], in seconds
        Timer.every(intervals[i], function()
            counters[i] = counters[i] + 1
        end)
    end
    
    -- create flappy sprite and set it to 0, 0; top-left
    flappySprite = love.graphics.newImage('water.png')

    
    -- table to just store flappy's X and Y
    flappies = {}
    -- destinations are now just placed in Timer.tween, now with a :finish
    -- function after every tween that gets called once that tween is finished
    local finished = false
    for i = 1, 1000 do
        table.insert(flappies, {
            x = 0,
            y = math.random(VIRTUAL_HEIGHT - 24),
            rate = math.random() + math.random(MOVEMENT_TIME - 1),
        })
    end

    love.birdCount()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

local count = 0 
function love.birdCount()
    for k, flappy in pairs(flappies) do
        count = count + 1
        
        Timer.tween(MOVEMENT_TIME * flappy.rate, {
            [flappy] = {x = math.random(VIRTUAL_WIDTH - 24), y = math.random(VIRTUAL_HEIGHT - 24)}
        }):finish(function()
            Timer.tween(MOVEMENT_TIME * flappy.rate, {
                [flappy] = {x = math.random(VIRTUAL_WIDTH - 24), y = math.random(VIRTUAL_HEIGHT - 24)}
            }):finish(function()
                Timer.tween(MOVEMENT_TIME * flappy.rate, {
                    [flappy] = {x = math.random(VIRTUAL_WIDTH - 24), y = math.random(VIRTUAL_HEIGHT - 24)}
                }):finish(function()
                    Timer.tween(1, { [flappy] = {x = 0, y = 0}
                    }):finish(function()
                            tweenCall(VIRTUAL_WIDTH * math.random(), VIRTUAL_HEIGHT * math.random(), flappy, MOVEMENT_TIME)
                    end)
                end)
            end)
        end)
    end
end

function tweenCall(a , b, obj, time)
    Timer.tween(time * obj.rate, {
        [obj] = {x = a, y = b}
    })
end
local angle = 0
function love.update(dt)
    angle = (1/math.pi)
    Timer.update(dt)
end

function love.draw()
    push:start()
    for k, flappy in pairs(flappies) do
        love.graphics.translate(VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/2)
        love.graphics.rotate(angle)
        love.graphics.translate(-VIRTUAL_WIDTH/2, -VIRTUAL_HEIGHT/2)
        love.graphics.draw(flappySprite, flappy.x, flappy.y)
    end
    love.graphics.print(count, VIRTUAL_WIDTH - 40, VIRTUAL_HEIGHT - 20)
    push:finish()
end