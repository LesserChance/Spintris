import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "shapes/L"
local pd <const> = playdate
local gfx = playdate.graphics

-- x and y dimensions of each cell
local CELL_SIZE <const> = 10
local DIRECTION_LEFT <const> = 0
local DIRECTION_RIGHT <const> = 1
local GRID_WIDTH = 40
local GRID_HEIGHT = 24

class("Drawable", {
    -- global cell values
    topCell = 1,
    leftCell = 1,
    bottomCell = 1,
    rightCell = 1,

    -- cell value
    width = 1,
    height = 1,
    occupiedCells = {},

    -- pixel values
    topPixel = 0,
    leftPixel = 0,
    rightPixel = 0,
    bottomPixel = 0,
}).extends(Object)

function Drawable:init(shape)
    if (shape == ShapeL.shape) then
        self.width = ShapeL.width
        self.height = ShapeL.height
        self.occupiedCells = ShapeL.occupiedCells
    end
    self:setCellPosition(self.topCell, self.leftCell)
end

function Drawable:draw()
    for row = 1, self.height do
        for column = 1, self.width do
            self:drawCell(row, column)
        end
    end
end

function Drawable:drawCell(row, column)
    if (self.occupiedCells[row] and self.occupiedCells[row][column]) then
        local position = {
            x = self.leftPixel + ((column - 1) * CELL_SIZE),
            y = self.topPixel + ((row - 1) * CELL_SIZE),
        }
        gfx.fillRoundRect(position.x, position.y, CELL_SIZE, CELL_SIZE, 5)
    else

    end
end

function Drawable:moveUp()
    self:setCellPosition(self.topCell - 1, self.leftCell)
end

function Drawable:moveDown()
    self:setCellPosition(self.topCell + 1, self.leftCell)
end

function Drawable:moveLeft()
    self:setCellPosition(self.topCell, self.leftCell - 1)
end

function Drawable:moveRight()
    self:setCellPosition(self.topCell, self.leftCell + 1)
end

function Drawable:rotateLeft()
    self:rotate(DIRECTION_LEFT)
end

function Drawable:rotateRight()
    self:rotate(DIRECTION_RIGHT)
end

function Drawable:rebound()
    while self.topCell < 1 do
        self:moveDown()
    end
    while self.bottomCell > GRID_HEIGHT do
        self:moveUp()
    end
    while self.leftCell < 1 do
        self:moveRight()
    end
    while self.rightCell > GRID_WIDTH do
        self:moveLeft()
    end
end

function Drawable:rotate(direction)
    -- remap occupiedCells into a new array
    local newWidth = self.height
    local newHeight = self.width
    local newOccupiedCells = self:getRotatedCells(direction)

    -- pivot around the center of the shape
    local rightMove = (newWidth - self.width) / 2
    local topMove = (newHeight - self.height) / 2
    rightMove = (rightMove < 0) and math.ceil(rightMove) or math.floor(rightMove)
    topMove = (topMove < 0) and math.ceil(topMove) or math.floor(topMove)

    self.width = newWidth
    self.height = newHeight
    self.occupiedCells = newOccupiedCells

    self:setCellPosition(self.topCell - topMove, self.leftCell - rightMove)
end

function Drawable:getRotatedCells(direction)
    local newOccupiedCells = {}

    for row = 1, self.height do
        for column = 1, self.width do
            if (self.occupiedCells[row] and self.occupiedCells[row][column]) then
                local newPosition = self:getRotatedPosition(row, column, self.height, self.width, direction)
                -- print(row .. "," .. column .. " -> " .. newPosition.row .. "," .. newPosition.column)

                if (not newOccupiedCells[newPosition.row]) then
                    newOccupiedCells[newPosition.row] = {}
                end
                newOccupiedCells[newPosition.row][newPosition.column] = true
            end
        end
    end

    return newOccupiedCells
end

function Drawable:getRotatedPosition(row, column, newWidth, newHeight, direction)
    if (direction == DIRECTION_RIGHT) then
        return {
            row = column,
            column = newWidth - (row - 1)
        }
    else
        return {
            row = newHeight - (column - 1),
            column = row
        }
    end
end

function Drawable:setCellPosition(top, left)
    self.topCell = top
    self.leftCell = left
    self.bottomCell = top + self.height - 1
    self.rightCell = left + self.width - 1

    self.topPixel = (self.topCell - 1) * CELL_SIZE
    self.leftPixel = (self.leftCell - 1) * CELL_SIZE
    self.bottomPixel = self.topPixel + (self.height * CELL_SIZE)
    self.rightPixel = self.leftPixel + (self.width * CELL_SIZE)

    self:rebound()
end
