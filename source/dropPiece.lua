-- import "CoreLibs/object"
-- import "CoreLibs/graphics"
-- import "CoreLibs/sprites"
-- import "CoreLibs/timer"
-- import "shapes/O"
-- import "shapes/L"

-- local gfx = playdate.graphics
-- local center = { x = (playdate.display.getWidth() / 2), y = (playdate.display.getHeight() / 2) }
-- -- How far from zero before we should rotate
-- local rotateRegion = 25
-- -- x and y dimensions of each cell
-- local cellSize = 10

-- class("DropPiece", {
--     location = 0,                -- 0 is top
--     distance = 0,                -- in cells
--     position = { x = 0, y = 0 }, -- in pixels
--     zeroPosition = 0,
--     distanceFromZero = 0,
--     shape = {}
-- }).extends(Object)

-- function DropPiece:init(location, shape)
--     self.location = location

--     if (shape == ShapeO.shape) then
--         self.shape = ShapeO()
--     elseif (shape == ShapeL.shape) then
--         self.shape = ShapeL()
--     end
-- end

-- function DropPiece:tick()
--     print("tick", location)
--     self.distance += 1
-- end

-- function DropPiece:crankHandler(change, acceleratedChange)
--     local crankPosition = playdate.getCrankPosition()
--     if (change <= 0) then
--         self.distanceFromZero += change
--         print(crankPosition, self.distanceFromZero)

--         if (self.distanceFromZero < -1 * rotateRegion) then
--             local rotations = (math.floor(-1 * self.distanceFromZero / 90) + 1)
--             for rotation = 1, rotations do
--                 self:rotate(crankPosition)
--             end
--         end
--     else
--         self:resetZeroPosition(crankPosition)
--     end
-- end

-- function DropPiece:resetZeroPosition(crankPosition)
--     self.zeroPosition = math.floor(crankPosition / 90) * 90
--     self.distanceFromZero = crankPosition - self.zeroPosition

--     -- print("resetZeroPosition", crankPosition, self.zeroPosition, self.distanceFromZero)
-- end

-- function DropPiece:rotate(crankPosition)
--     self.location = (self.location - 90) % 360
--     self.zeroPosition = (self.zeroPosition - 90) % 360
--     self.distanceFromZero = crankPosition - self.zeroPosition

--     -- print(self.location, self.zeroPosition, self.distanceFromZero)
-- end

-- function DropPiece:update()
--     local x = self:getDrawX()
--     local y = self:getDrawY()

--     for row = 1, self.shape.rows do
--         for column = 1, self.shape.columns do
--             local cellBounds = self:getXYOffset(row, column)
--             self:drawCell(row, column, cellBounds.x + x, cellBounds.y + y)
--         end
--     end
-- end

-- function DropPiece:drawCell(row, column, x, y)
--     if (self.shape.pieces[self:getIndex(row, column)]) then
--         gfx.fillRoundRect(x, y, cellSize, cellSize, 5)
--     end
-- end

-- function DropPiece:getXYOffset(row, column)
--     return {
--         x = (column - 1) * cellSize,
--         y = (row - 1) * cellSize,
--     }
-- end

-- function DropPiece:getDrawX()
--     return self:getXAtDistance(self.distance, 0)
-- end

-- function DropPiece:getDrawY()
--     return self:getYAtDistance(self.distance, 0)
-- end

-- function DropPiece:getXAtDistance(distance, xOffset)
--     if self.location == 90 then
--         return playdate.display.getWidth() - self:getDrawWidth() - (distance * cellSize) + xOffset
--     elseif self.location == 270 then
--         return 0 + (distance * cellSize) + xOffset
--     end

--     return center.x + xOffset
-- end

-- function DropPiece:getYAtDistance(distance, yOffset)
--     if self.location == 0 then
--         return 0 + (distance * cellSize) + yOffset
--     elseif self.location == 180 then
--         return playdate.display.getHeight() - self:getDrawHeight() - (distance * cellSize) + yOffset
--     end

--     return center.y + yOffset
-- end

-- function DropPiece:getIndex(row, column)
--     return column + ((row - 1) * self.shape.columns)
-- end

-- function DropPiece:getDrawWidth()
--     return self.shape.columns * cellSize
-- end

-- function DropPiece:getDrawHeight()
--     return self.shape.rows * cellSize
-- end

-- function DropPiece:getGlobalGridPieceLocationsAtDistance(distance)
--     local colliderPositions = {}
--     for row = 1, self.shape.rows do
--         for column = 1, self.shape.columns do
--             if (self.shape.pieces[self:getIndex(row, column)]) then
--                 -- check collisions for this cell
--                 local offset = self:getXYOffset(row, column)
--                 local globalGrid = {
--                     row = (self:getYAtDistance(distance, offset.y) / cellSize) + 1,
--                     column = (self:getXAtDistance(distance, offset.x) / cellSize) + 1
--                 }

--                 table.insert(colliderPositions, globalGrid)
--             end
--         end
--     end

--     return colliderPositions
-- end

-- function DropPiece:checkCollisions(blockColliderPositions)
--     local pieceColliderPositions = self:getGlobalGridPieceLocationsAtDistance(self.distance + 1)

--     for i, collider in ipairs(pieceColliderPositions) do
--         print("collider row", collider.row, "collider column", collider.column)
--         for j, blockCollider in ipairs(blockColliderPositions) do
--             if (collider.row == blockCollider.row and collider.column == blockCollider.column) then
--                 return true
--             end
--         end
--     end

--     return false
-- end
