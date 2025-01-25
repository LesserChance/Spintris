import "CoreLibs/object"

local pd <const>  = playdate
local gfx <const> = pd.graphics

---@class Drawable
class("Drawable", {
    deleted = false,
    shape = nil,

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
}).extends()

---Initailize
---@param shape? table
---@param rotations? integer How many rotations to perform on the base shape
---@param top? integer initial top cell position
---@param left? integer initial left cell position
function Drawable:init(shape, rotations, top, left)
    if (shape) then
        self.shape = shape.shape
        self.width = shape.width
        self.height = shape.height
        self.occupiedCells = shape.occupiedCells
    end

    self:setCellPosition(self.topCell, self.leftCell)

    if (rotations) then
        while rotations >= 1 do
            self:rotateRight()
            rotations -= 1
        end
    end

    -- position is set after rotation, assuming caller wants top left of expected rotation
    if (top or left) then
        self:setCellPosition(top or self.topCell, left or self.leftCell)
    end
end

---Draw the drawable to the display
function Drawable:draw()
    if (self.deleted) then
        return
    end
    for row, r in ipairs(self.occupiedCells) do
        for column in pairs(r) do
            self:drawCell(row, column)
        end
    end
end

---Draw an individual cell to the display
---@param row integer
---@param column integer
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

---move up one cell
function Drawable:moveUp()
    self:setCellPosition(self.topCell - 1, self.leftCell)
end

---move down one cell
function Drawable:moveDown()
    self:setCellPosition(self.topCell + 1, self.leftCell)
end

---move left one cell
function Drawable:moveLeft()
    self:setCellPosition(self.topCell, self.leftCell - 1)
end

---move right one cell
function Drawable:moveRight()
    self:setCellPosition(self.topCell, self.leftCell + 1)
end

---rotate counter clockwise
function Drawable:rotateLeft()
    self:rotate(DIRECTION_LEFT)
end

---rotate clockwise
function Drawable:rotateRight()
    self:rotate(DIRECTION_RIGHT)
end

---ensure the drawable stays within the bounds of the grid
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

---rotate
---@param direction any
function Drawable:rotate(direction)
    local newTopRight = pd.geometry.point.new(self.leftPixel, self.topPixel)

    -- remap occupiedCells into a new array
    local newWidth = self.height
    local newHeight = self.width
    local newOccupiedCells = self:getRotatedCells(direction)

    self.width = newWidth
    self.height = newHeight
    self.occupiedCells = newOccupiedCells

    local transform = pd.geometry.affineTransform.new()
    if (direction == DIRECTION_LEFT) then
        transform:rotate(-90, DISPLAY_CENTER)
    else
        transform:rotate(90, DISPLAY_CENTER)
    end
    transform:transformPoint(newTopRight)

    local newTop = self:getNearestCell(newTopRight.y)
    local newLeft = self:getNearestCell(newTopRight.x - (self.width * CELL_SIZE))

    self:setCellPosition(newTop, newLeft)
end

---get all new positions for cells after a rotate
---@param direction any
---@return table
function Drawable:getRotatedCells(direction)
    local newOccupiedCells = {}

    for row, r in ipairs(self.occupiedCells) do
        for column in pairs(r) do
            local newPosition = self:getRotatedPosition(row, column, self.height, self.width, direction)
            -- print(row .. "," .. column .. " -> " .. newPosition.row .. "," .. newPosition.column)

            if (not newOccupiedCells[newPosition.row]) then
                newOccupiedCells[newPosition.row] = {}
            end
            newOccupiedCells[newPosition.row][newPosition.column] = true
        end
    end

    return newOccupiedCells
end

---if a cell were to be rotated which position would it then be in
---@param row integer
---@param column integer
---@param newWidth integer
---@param newHeight integer
---@param direction any
---@return table
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

---Set the drawable's position properties based on a new top-left position
---@param top integer
---@param left integer
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

---check if this drawable is colliding with another
---@param collider Drawable
---@return boolean
function Drawable:collidesWith(collider, direction)
    if (collider.deleted) then
        return false
    end
    for row, r in ipairs(self.occupiedCells) do
        for column in pairs(r) do
            local gridRow = self.topCell + (row - 1)
            local gridColumn = self.leftCell + (column - 1)

            if (collider:isGridEdgeOccupied(gridRow, gridColumn, direction)) then
                return true
            end
        end
    end

    return false
end

---check if the given cell on the full grid shares an edge with an occupied cell of this drawable
---@param object Drawable
---@return boolean
function Drawable:isGridEdgeOccupied(gridRow, gridColumn, direction)
    local localRow = gridRow - self.topCell + 1
    local localColumn = gridColumn - self.leftCell + 1

    local adjacentRow, adjacentColumn

    if (direction == DIRECTION_DOWN) then
        -- Only look at cells above this
        adjacentRow = localRow - 1
        adjacentColumn = localColumn
    elseif (direction == DIRECTION_UP) then
        -- Only look at cells below this
        adjacentRow = localRow + 1
        adjacentColumn = localColumn
    elseif (direction == DIRECTION_LEFT) then
        -- Only look at cells right of this
        adjacentRow = localRow
        adjacentColumn = localColumn + 1
    elseif (direction == DIRECTION_RIGHT) then
        -- Only look at cells left of this
        adjacentRow = localRow
        adjacentColumn = localColumn - 1
    end

    if (self.occupiedCells[adjacentRow] and self.occupiedCells[adjacentRow][adjacentColumn]) then
        print("BAM")
        return true
    end

    return false
end

---check if the given cell on the full grid is occupied by this drawable
---@param object Drawable
---@return boolean
function Drawable:isGridCellOccupied(gridRow, gridColumn)
    local localRow = gridRow - self.topCell + 1
    local localColumn = gridColumn - self.leftCell + 1

    return (self.occupiedCells[localRow] and self.occupiedCells[localRow][localColumn])
end

---stick that object onto this object
---@param collider Drawable
function Drawable:mergeIn(collider)
    if (collider.deleted) then
        return false
    end

    local newTop = math.min(collider.topCell, self.topCell)
    local newLeft = math.min(collider.leftCell, self.leftCell)
    local newBottom = math.max(collider.bottomCell, self.bottomCell)
    local newRight = math.max(collider.rightCell, self.rightCell)
    local newHeight = newBottom - newTop + 1
    local newWidth = newRight - newLeft + 1
    local newOccupiedCells = {}

    -- travserse the global grid, and translate all occupied spaces of both drawales into this one
    local localRow = 0
    local localColumn = 0
    for row = newTop, newBottom do
        localRow = localRow + 1
        localColumn = 0
        for column = newLeft, newRight do
            localColumn = localColumn + 1

            if (self:isGridCellOccupied(row, column) or collider:isGridCellOccupied(row, column)) then
                if (not newOccupiedCells[localRow]) then
                    newOccupiedCells[localRow] = {}
                end
                newOccupiedCells[localRow][localColumn] = true
            end
        end
    end

    self.width = newWidth
    self.height = newHeight
    self.occupiedCells = newOccupiedCells
    self:setCellPosition(newTop, newLeft)
end

function Drawable:getNearestCell(pos, direction)
    if (direction == DIRECTION_UP) then
        return math.ceil(pos / CELL_SIZE) + 1
    end

    return math.floor(pos / CELL_SIZE) + 1
end

function Drawable:delete()
    self.deleted = true
end
