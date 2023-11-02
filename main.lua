local Button = require("Button")

local button1

local logoimage
local eyeimage
local screenWidth 
local screenHeight


local ball = {}
ball.radius = 20
ball.speed = 1000
ball.direction = 1
ball.directionX = 1
ball.directionY = 1 
local angle = 0
local radius = 500
local angularSpeed = math.rad(200)
local shrinkSpeed = 50 
local exerciseIndex = 1
local currentTimer = nil
local instructionsDisplayed = nil
local resultsDisplayed = nil
local speedX = 800
local speedY = 800

_G.startExercise = false

local exercises = {
    {
        instructions = "Follow the ball as it moves horizontally.",
        start = nil,
        stop = 20,
        NoBall = false,
        update = function(dt)
            ball.x = ball.x + ball.speed * dt * ball.direction
            if ball.x <= 0 or ball.x >= love.graphics.getWidth() then
                ball.direction = -ball.direction
            end
        end
    },
    {
        instructions = "Close and Relax your eyes and wait for the ding",
        NoBall = true,
        start = nil,
        stop = 5,
        update = function(dt)
 
        end
    },
    {
        instructions = "Follow the ball as it moves vertically.",
        start = nil,
        stop = 20,
        NoBall = false,
        update = function(dt)
            ball.y = ball.y + ball.speed * dt * ball.direction
            if ball.y <= 0 or ball.y >= love.graphics.getHeight() then
                ball.direction = -ball.direction
            end
        end
    },
    {
        instructions = "Relax your eyes and wait for the ding",
        NoBall = true,
        start = nil,
        stop = 5,
        update = function(dt)
 
        end
    },
    {

        instructions = "Follow the ball as it moves in a random pattern.",
        start = nil,
        stop = 20,
        NoBall = false,
        update = function(dt)

            local dx = speedX * dt
            local dy = speedY * dt
        
            -- Move the ball
            ball.x = ball.x + dx
            ball.y = ball.y + dy
        
            -- Check if the ball is about to go out of bounds
            if ball.x < 0 or ball.x > love.graphics.getWidth() then
                speedX = -speedX  -- Reverse the horizontal direction
            end
            if ball.y < 0 or ball.y > love.graphics.getHeight() then
                speedY = -speedY  -- Reverse the vertical direction
            end
        end
    },
    {
        instructions = "Close and Relax your eyes and wait for the ding",
        NoBall = true,
        start = nil,
        stop = 5,
        update = function(dt)
 
        end
    },
    {
        instructions = "Follow the ball as it moves Clockwise.",
        start = nil,
        stop = 20,
        NoBall = false,
        update = function(dt)
            local radius = 500  -- Adjust the radius as needed
            local angularSpeed = math.rad(200) -- Adjust the angular speed as needed (90 degrees per second)
            angle = angle + angularSpeed * dt
            ball.x = love.graphics.getWidth() / 2 + radius * math.cos(angle)
            ball.y = love.graphics.getHeight() / 2 + radius * math.sin(angle)
        end
    },
    {
        instructions = "Close and Relax your eyes and wait for the ding",
        NoBall = true,
        start = nil,
        stop = 5,
        update = function(dt)
 
        end
    },
    {
        instructions = "Follow the ball as it moves Counter Clockwise.",
        start = nil,
        stop = 20,
        NoBall = false,
        update = function(dt)
            local radius = 500  -- Adjust the radius as needed
            local angularSpeed = -math.rad(200) -- Adjust the angular speed as needed (90 degrees per second)
            angle = angle + angularSpeed * dt
            ball.x = love.graphics.getWidth() / 2 + radius * math.cos(angle)
            ball.y = love.graphics.getHeight() / 2 + radius * math.sin(angle)
        end
    },
    {
        instructions = "Close and Relax your eyes and wait for the ding",
        NoBall = true,
        start = nil,
        stop = 5,
        update = function(dt)
 
        end
    },

    {
        instructions = "Follow the ball as it moves Spirally.",
        start = nil,
        stop = 20,
        NoBall = false,
        update = function(dt)
            angle = angle + angularSpeed * dt
            radius = radius - shrinkSpeed * dt
        
            if radius <= 0 then
                radius = 500  -- Reset the radius when it becomes zero
            end
        
            ball.x = love.graphics.getWidth() / 2 + radius * math.cos(angle)
            ball.y = love.graphics.getHeight() / 2 + radius * math.sin(angle)
        end
    },
    {
        instructions = "Close and Relax your eyes and wait for the ding",
        NoBall = true,
        start = nil,
        stop = 5,
        update = function(dt)
 
        end
    },
}


function love.load()
    

    love.window.setMode(1920, 1080, {fullscreen = true, resizable = true}) 

    ball.x = (love.graphics.getWidth() / 2)
ball.y = love.graphics.getHeight() / 2
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    
    local font = love.graphics.newFont(24)
    button1 = Button:new(0, 0
, "startbutton.png", font, {0.7, 0.7, 0.7}, {0.3, 0.3, 0.3})
    button1.x = (screenWidth - button1.image:getWidth()) / 2
    button1.y = ((screenHeight - button1.image:getHeight()) / 2) + 55


    logoimage = love.graphics.newImage("logo.png")
    eyeimage = love.graphics.newImage("Eye.png")

end

function love.update(dt)
  
    if _G.startExercise == true then

        if instructionsDisplayed == nil then
            instructionsDisplayed = love.timer.getTime()
        else
            if love.timer.getTime() - instructionsDisplayed >= 4 then
                if exerciseIndex <= #exercises then
                    local currentExercise = exercises[exerciseIndex]
                    if currentExercise.start  == nil then
                        currentExercise.start =  love.timer.getTime()
                    end
        
         
                    if love.timer.getTime() -  currentExercise.start >= currentExercise.stop then
                        local finishSoudnd = love.audio.newSource("finish.wav", "static")
                        finishSoudnd:play()
                        exerciseIndex = exerciseIndex + 1
                        if exerciseIndex <= #exercises then
                            ball.x = love.graphics.getWidth() / 2
                            ball.y = love.graphics.getHeight() / 2
                        end
                        
                    else

                        currentExercise.update(dt)
            
                    end
                else
                    if resultsDisplayed== nil then
                        resultsDisplayed = love.timer.getTime() 
                    elseif love.timer.getTime()  - resultsDisplayed >= 10 then
                        _G.startExercise  = false
                        exerciseIndex = 1
                        currentTimer = nil
                        instructionsDisplayed = nil
                        resultsDisplayed = nil

                        for i,exercise in pairs(exercises) do
                        
                            exercise.start = nil
                        end

                    end
        
                end
            end

        end


    end
 

    
    


    button1:update(love.mouse.getX(), love.mouse.getY())

end

function love.draw()
    love.graphics.setBackgroundColor(109/255, 168/255, 50/255,50/100)
    local customFont = love.graphics.newFont("KGBlankSpaceSolid.ttf", 40)
    local font = love.graphics.getFont() 
    love.graphics.setFont(customFont)


    if _G.startExercise == true then

        if resultsDisplayed ~= nil and love.timer.getTime() - resultsDisplayed < 10 then
            local textWidth = font:getWidth("You Sucessfully Completed Todays Exercise Make Sure To:")
            love.graphics.print("You Sucessfully Completed Todays Exercise Make Sure To:", (screenWidth - textWidth) / 2, (screenHeight / 2) - 300)

            local textWidth = font:getWidth("1. Drink alot of water")
            love.graphics.print("1. Drink alot of water", (screenWidth - textWidth) / 2, (screenHeight / 2) - 200)


            local textWidth = font:getWidth("2. Eat healthy")
            love.graphics.print("2. Eat healthy", (screenWidth - textWidth) / 2, (screenHeight / 2) - 100)

            local textWidth = font:getWidth("3. Minimize your screen time and turn on night mode on all your devices")
            love.graphics.print("3. Minimize your screen time and turn on night mode on all your devices", (screenWidth - textWidth) / 2, (screenHeight / 2) )

            local textWidth = font:getWidth("4. Get enough sleep everyday")
            love.graphics.print("4. Get enough sleep everyday", (screenWidth - textWidth) / 2, (screenHeight / 2) + 100 )

            local textWidth = font:getWidth("5. Consider getting blue light blocking glasses")
            love.graphics.print("5. Consider getting blue light blocking glasses", (screenWidth - textWidth) / 2, (screenHeight / 2) + 200 )

            local textWidth = font:getWidth("6. Repeat these exercises daily")
            love.graphics.print("6. Repeat these exercises daily", (screenWidth - textWidth) / 2, (screenHeight / 2) + 300 )
            return
        end

        if  instructionsDisplayed ~= nil and  love.timer.getTime() - instructionsDisplayed >= 4 then
            if exerciseIndex <= #exercises then
                local currentExercise = exercises[exerciseIndex]
        
                local textWidth = font:getWidth(currentExercise.instructions)
    
    
                
            local eyeX = screenWidth/18   
            local eyeY = (screenHeight - (screenHeight/ 2) - 500)
        
            love.graphics.draw(eyeimage, eyeX, eyeY) 
      
    
                love.graphics.print(currentExercise.instructions, (screenWidth - textWidth) / 2, (screenHeight / 2) +40)
    
                if currentExercise.start ~= nil then
    
                    if currentTimer ~= nil and currentTimer ~=math.floor(love.timer.getTime() -  currentExercise.start) then
                        local tickSound = love.audio.newSource("tick.wav", "static")
                        tickSound:play()
                    end
                    
                    love.graphics.print(tostring(math.floor(currentExercise.stop - (love.timer.getTime() -  currentExercise.start))), (screenWidth ) / 2, (screenHeight / 2) - 20 )
                    currentTimer = math.floor(love.timer.getTime() -  currentExercise.start)
                end
               
    
                
                -- Draw the ball
    
                if currentExercise.NoBall == false then
                    love.graphics.circle("fill", ball.x, ball.y, ball.radius)
                end
               
            end
         else
            local textWidth = font:getWidth("Keep your head still and only move your eyes")
            love.graphics.print("Keep your head still and only move your eyes", (screenWidth - textWidth) / 2, (screenHeight / 2))
        end
    else
        button1:draw()
    
    
        local logoX = (screenWidth - logoimage:getWidth()) / 2
        local logoY = ((screenHeight - logoimage:getHeight()) / 2) - 100
    
        love.graphics.draw(logoimage, logoX, logoY) 

        
        local textWidth = font:getWidth("By Tchouankeu Xerco")
        love.graphics.print("By Tchouankeu Xerco", (screenWidth - textWidth) / 2, (screenHeight / 2)  + 130 )
    end









    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()


    



 
end

function love.mousepressed(x, y, button)
    button1:mousepressed(x, y, button)
end


function love.mousereleased(x, y, button)

    
    button1:mousereleased(x, y, button)
end