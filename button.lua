local Button = {}

function Button:new(x, y, imageFilename, font, hoverColor, clickColor)
    local button = {
        x = x,
        y = y,
        image = love.graphics.newImage(imageFilename),
        font = font,
        hoverColor = hoverColor,
        clickColor = clickColor,
        isHovered = false,
        isClicked = false,
    }


    button.width = button.image:getWidth()
    button.height = button.image:getHeight()

    setmetatable(button, self)
    self.__index = self

    return button
end

function Button:draw()
    local color = {1, 1, 1}

    if self.isClicked then
        color = self.clickColor
    elseif self.isHovered then
        color = self.hoverColor
    end

    love.graphics.setColor(color)
    love.graphics.draw(self.image, self.x, self.y)

    love.graphics.setColor(1, 1, 1)


    love.graphics.setFont(self.font)
end

function Button:update(mouseX, mouseY)

    if mouseX >= self.x and mouseX <= self.x + self.width and mouseY >= self.y and mouseY <= self.y + self.height then
        self.isHovered = true
    else
        self.isHovered = false
    end
end

function Button:mousepressed(x, y, button)
    if x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height then
        self.isClicked = true
        local clickSound = love.audio.newSource("click.mp3", "static")
        clickSound:play()
        _G.startExercise = true

    else
        self.isClicked = false
    end
end

function Button:mousereleased(x, y, button)
    self.isClicked = false
end

return Button