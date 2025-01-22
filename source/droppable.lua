import "drawable"
import "crankHandler"

local pd <const> = playdate

---@class Droppable
class("Droppable", {
    speed = 100,
    crankHandler = nil,
    pivotPosition = nil,
    moveDirection = nil
}).extends(Drawable)

function Droppable:init(moveDirection, shape, rotations, top, left)
    Droppable.super.init(self, shape, rotations, top, left)

    self.moveDirection = moveDirection
    self.speed = math.random(500, 1500)
    pd.timer.new(self.speed, function() self:tick() end)

    if (self.moveDirection == DIRECTION_UP) then
        self.pivotPosition = POSITION_DOWN
    elseif (self.moveDirection == DIRECTION_DOWN) then
        self.pivotPosition = POSITION_UP
    elseif (self.moveDirection == DIRECTION_LEFT) then
        self.pivotPosition = POSITION_RIGHT
    elseif (self.moveDirection == DIRECTION_RIGHT) then
        self.pivotPosition = POSITION_LEFT
    end

    self.crankHandler = CrankHandler(DIRECTION_LEFT, function(rotations)
        self:handleCrankRotations(rotations)
    end)
end

function Droppable:tick()
    if (self.moveDirection == DIRECTION_UP) then
        self:moveUp()
    elseif (self.moveDirection == DIRECTION_DOWN) then
        self:moveDown()
    elseif (self.moveDirection == DIRECTION_LEFT) then
        self:moveLeft()
    elseif (self.moveDirection == DIRECTION_RIGHT) then
        self:moveRight()
    end
    pd.timer.new(self.speed, function() self:tick() end)
end

function Droppable:handleCrankRotations(rotations)
    for rotation = 1, rotations do
        self:pivotLeft()
    end
end

---rotate around the center of the screen
function Droppable:pivotLeft()
    local newBottomLeft = pd.geometry.point.new(self.leftPixel, self.topPixel)

    local transform = pd.geometry.affineTransform.new()
    transform:rotate(-90, DISPLAY_CENTER)
    transform:transformPoint(newBottomLeft)

    local newTop = self:getNearestCell(newBottomLeft.y - (self.height * CELL_SIZE), DIRECTION_UP)
    local newLeft = self:getNearestCell(newBottomLeft.x, DIRECTION_UP)

    self:setCellPosition(newTop, newLeft)

    if (self.pivotPosition == POSITION_DOWN) then
        self.pivotPosition = POSITION_RIGHT
        self.moveDirection = DIRECTION_LEFT
    elseif (self.pivotPosition == POSITION_UP) then
        self.pivotPosition = POSITION_LEFT
        self.moveDirection = DIRECTION_RIGHT
    elseif (self.pivotPosition == POSITION_RIGHT) then
        self.pivotPosition = POSITION_UP
        self.moveDirection = DIRECTION_DOWN
    elseif (self.pivotPosition == POSITION_LEFT) then
        self.pivotPosition = POSITION_DOWN
        self.moveDirection = DIRECTION_UP
    end
end
