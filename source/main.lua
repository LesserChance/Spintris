import "CoreLibs/graphics"
import "CoreLibs/ui"
import "CoreLibs/timer"
import "block"
import "drawable"
import "dropPiece"
import "shapes/O"
import "shapes/L"

-- Localizing commonly used globals
local pd <const> = playdate
local gfx <const> = playdate.graphics
local gridview = playdate.ui.gridview.new(10, 10)
local block, topPiece, leftPiece, drawable

-- gridview.backgroundImage = playdate.graphics.nineSlice.new('images/shadowbox', 4, 4, 45, 45)
gridview:setNumberOfColumns(40)
gridview:setNumberOfRows(24)

function gridview:drawCell(section, row, column, selected, x, y, width, height)
    gfx.drawRect(x, y, width, height)
end

local function initialize()
    drawable = Drawable(ShapeL.shape)

    playdate.inputHandlers.push({
        upButtonUp = function()
            drawable:moveUp()
        end,
        downButtonUp = function()
            drawable:moveDown()
        end,
        leftButtonUp = function()
            drawable:moveLeft()
        end,
        rightButtonUp = function()
            drawable:moveRight()
        end,
        AButtonUp = function()
            drawable:rotateRight()
        end,
        BButtonUp = function()
            drawable:rotateLeft()
        end
    })

    -- block = Block()
    -- -- topPiece = DropPiece(0, ShapeO.shape)
    -- leftPiece = DropPiece(270, ShapeL.shape)

    -- playdate.inputHandlers.push({
    --     cranked = function(change, acceleratedChange)
    --         block:crankHandler(change, acceleratedChange)
    --         -- topPiece:crankHandler(change, acceleratedChange)
    --         leftPiece:crankHandler(change, acceleratedChange)
    --     end
    -- })
    -- playdate.timer.new(1000, tick)
end

-- playdate.update function is required in every project!
function playdate.update()
    -- Clear screen
    gfx.clear()

    -- Draw grid
    gridview:drawInRect(0, 0, 400, 240)

    drawable:draw()

    -- -- Draw Block
    -- block:update()
    -- -- topPiece:update()
    -- leftPiece:update()

    -- playdate.timer:updateTimers()
end

function tick()
    -- -- topPiece:tick()
    -- leftPiece:tick()
    -- checkCollisions()
    -- playdate.timer.new(1000, tick)
end

function checkCollisions()
    -- -- if next tick overlaps, then we've collided
    -- local colliderPositions = block:getGlobalGridPieceLocations()
    -- if (leftPiece:checkCollisions(colliderPositions)) then
    --     block:collideWith(leftPiece)
    -- end
end

initialize()
