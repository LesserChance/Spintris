-- import "CoreLibs/object"
-- import "CoreLibs/graphics"
-- import "CoreLibs/sprites"
-- import "CoreLibs/timer"

-- local gfx = playdate.graphics
-- local center = { x = (playdate.display.getWidth() / 2), y = (playdate.display.getHeight() / 2) }

-- -- x and y dimensions of each cell
-- local cellSize = 10

-- -- How far from zero before we should rotate
-- local rotateRegion = 25

-- class("Block", {
--     rotation = 0,
--     columns = 4,
--     rows = 4,
--     zeroPosition = 0,
--     distanceFromZero = 0,
--     x = 0,
--     y = 0,
--     -- index position of filed pieces, tl to br
--     pieces = {}
-- }).extends(Object)

-- function Block:init()
--     self.zeroPosition = playdate.getCrankPosition()

--     self.pieces = {
--         [3] = true,
--         [7] = true,
--         [8] = true,
--         [9] = true,
--         [10] = true,
--         [12] = true,
--         [13] = true,
--         [14] = true
--     }
--     self.x = self:getDrawX()
--     self.y = self:getDrawY()
-- end

-- function Block:crankHandler(change, acceleratedChange)
--     local crankPosition = playdate.getCrankPosition()
--     if (change >= 0) then
--         self.distanceFromZero += change

--         if (self.distanceFromZero > rotateRegion) then
--             local rotations = (math.floor(self.distanceFromZero / 90) + 1)
--             for rotation = 1, rotations do
--                 self:rotate(crankPosition)
--             end
--         end
--     else
--         self:resetZeroPosition(crankPosition)
--     end
-- end

-- function Block:resetZeroPosition(crankPosition)
--     local newZeroPosition = (math.floor((crankPosition + 90) / 90) * 90)

--     self.zeroPosition = newZeroPosition % 360
--     self.distanceFromZero = crankPosition - newZeroPosition
-- end

-- function Block:rotate(crankPosition)
--     local newZeroPosition = (self.zeroPosition + 90)
--     self.rotation = (self.rotation + 90) % 360
--     self.zeroPosition = newZeroPosition % 360
--     self.distanceFromZero = crankPosition - newZeroPosition
-- end

-- function Block:getIndex(row, column)
--     return column + ((row - 1) * self.columns)
-- end

-- --- Draw a cell to the screen
-- --- @param row integer
-- --- @param column integer
-- --- @param x integer left position (in pixels)
-- --- @param y integer top position (in pixels)
-- --- @void
-- function Block:drawCell(row, column, x, y)
--     if (self.pieces[self:getIndex(row, column)]) then
--         gfx.fillRoundRect(x, y, cellSize, cellSize, 5)
--     end
-- end

-- --- Returns and Object with x and y measurements (in pixels) of the entire block
-- --- @param row integer
-- --- @param column integer
-- --- @return Object {x: Integer, y: Integer}
-- function Block:getXYOffset(row, column)
--     local cellBounds = { x = 0, y = 0 }

--     if (self.rotation == 0) then
--         cellBounds.x = (column - 1) * cellSize
--         cellBounds.y = (row - 1) * cellSize
--     elseif (self.rotation == 90) then
--         cellBounds.x = (self.rows * cellSize) - (row * cellSize)
--         cellBounds.y = (column - 1) * cellSize
--     elseif (self.rotation == 180) then
--         cellBounds.x = (self.columns * cellSize) - (column * cellSize)
--         cellBounds.y = (self.rows * cellSize) - (row * cellSize)
--     elseif (self.rotation == 270) then
--         cellBounds.x = (row - 1) * cellSize
--         cellBounds.y = (self.columns * cellSize) - (column * cellSize)
--     end
--     return cellBounds
-- end

-- function Block:update()
--     for row = 1, self.rows do
--         for column = 1, self.columns do
--             local cellBounds = self:getXYOffset(row, column)
--             self:drawCell(row, column, cellBounds.x + self.x, cellBounds.y + self.y)
--         end
--     end
-- end

-- function Block:getDrawX()
--     return center.x - (self:getDrawWidth() / 2)
-- end

-- function Block:getDrawY()
--     return center.y - (self:getDrawHeight() / 2)
-- end

-- function Block:getDrawWidth()
--     if (self.rotation == 0 or self.rotation == 180) then
--         return self.columns * cellSize
--     else
--         return self.rows * cellSize
--     end
-- end

-- function Block:getDrawHeight()
--     if (self.rotation == 0 or self.rotation == 180) then
--         return self.rows * cellSize
--     else
--         return self.columns * cellSize
--     end
-- end

-- function Block:getGlobalGridPieceLocations()
--     local colliderPositions = {}
--     for row = 1, self.rows do
--         for column = 1, self.columns do
--             if (self.pieces[self:getIndex(row, column)]) then
--                 local offset = self:getXYOffset(row, column)
--                 -- self:drawCell(row, column, cellBounds.x + x, cellBounds.y + y)
--                 -- local offset = self:getXYOffset(row, column)
--                 local globalGrid = {
--                     row = ((self.y + offset.y) / cellSize) + 1,
--                     column = ((self.x + offset.x) / cellSize) + 1,
--                 }

--                 -- print("block row", globalGrid.row, "block column", globalGrid.column)

--                 table.insert(colliderPositions, globalGrid)
--             end
--         end
--     end

--     return colliderPositions
-- end

-- function Block:collideWith(piece)
--     -- add all of piece's peces to the block in their current position
-- end
