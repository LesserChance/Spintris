import "CoreLibs/graphics"
import "CoreLibs/ui"
import "CoreLibs/timer"

import "globals"
import "shapes/L"
import "shapes/O"

import "pile"
import "droppable"

local pd <const>  = playdate
local gfx <const> = pd.graphics

local gridview    = pd.ui.gridview.new(CELL_SIZE, CELL_SIZE)
local pile
local droppables  = {}

-- gridview.backgroundImage = pd.graphics.nineSlice.new('images/shadowbox', 4, 4, 45, 45)
gridview:setNumberOfColumns(GRID_WIDTH)
gridview:setNumberOfRows(GRID_HEIGHT)

function gridview:drawCell(section, row, column, selected, x, y, width, height)
    -- gfx.drawRect(x, y, width, height)
end

local function initialize()
    local controlIndex = 4

    droppables[1] = Droppable(DIRECTION_DOWN, ShapeL, 1, 0, 18)
    droppables[2] = Droppable(DIRECTION_RIGHT, ShapeL, 0, 10, 0)
    droppables[3] = Droppable(DIRECTION_UP, ShapeO, 2, 30, 18)
    droppables[4] = Droppable(DIRECTION_LEFT, ShapeO, 0, 10, 35)
    pile = Pile()

    local inputHandlers = {
        upButtonUp = function()
            droppables[controlIndex]:moveUp()
            checkCollisions()
        end,
        downButtonUp = function()
            droppables[controlIndex]:moveDown()
            checkCollisions()
        end,
        leftButtonUp = function()
            droppables[controlIndex]:moveLeft()
            checkCollisions()
        end,
        rightButtonUp = function()
            droppables[controlIndex]:moveRight()
            checkCollisions()
        end,
        AButtonUp = function()
            droppables[controlIndex]:rotateRight()
            checkCollisions()
        end,
        BButtonUp = function()
            droppables[controlIndex]:rotateLeft()
            checkCollisions()
        end,
        cranked = function(change, acceleratedChange)
            for i, droppable in ipairs(droppables) do
                droppable.crankHandler:crankInputHandler(change, acceleratedChange)
            end

            pile.crankHandler:crankInputHandler(change, acceleratedChange)
        end
    }
    pd.inputHandlers.push(inputHandlers)
    pd.timer.new(10, tick)
end

-- pd.update function is required in every project!
function pd.update()
    -- Clear screen
    gfx.clear()

    -- Draw grid
    gridview:drawInRect(0, 0, 400, 240)

    -- Draw Pile
    pile:draw()

    -- Draw droppables
    for i, droppable in ipairs(droppables) do
        droppable:draw()
    end

    pd.timer:updateTimers()
end

function tick()
    checkCollisions()
    pd.timer.new(10, tick)
end

function checkCollisions()
    for i, droppable in ipairs(droppables) do
        if (pile:collidesWith(droppable, droppable.moveDirection)) then
            pile:mergeIn(droppable)
            droppable:delete()
        end
    end
end

initialize()
