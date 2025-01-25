import "CoreLibs/graphics"
import "CoreLibs/ui"
import "CoreLibs/timer"

import "globals"
import "shapes/L"
import "shapes/O"
import "shapes/Pile"

import "pile"
import "droppable"
import "background"

local pd <const>  = playdate
local gfx <const> = pd.graphics

local gridview    = pd.ui.gridview.new(CELL_SIZE, CELL_SIZE)
local pile
local droppables  = {}
local background

gridview:setNumberOfColumns(GRID_WIDTH)
gridview:setNumberOfRows(GRID_HEIGHT)

function gridview:drawCell(section, row, column, selected, x, y, width, height)
    -- gfx.drawRect(x, y, width, height)
end

local function initialize()
    local controlIndex = 1

    pile = Pile()
    background = Background()

    local inputHandlers = {
        upButtonDown = function()
            background:moveCenter(pd.geometry.vector2D.new(0, -50))
        end,
        upButtonUp = function()
            background:moveCenter(pd.geometry.vector2D.new(0, 50))
            -- droppables[controlIndex]:moveUp()
        end,
        downButtonDown = function()
            background:moveCenter(pd.geometry.vector2D.new(0, 50))
            -- for i, droppable in ipairs(droppables) do
            --     droppable:speedUp()
            -- end
        end,
        downButtonUp = function()
            background:moveCenter(pd.geometry.vector2D.new(0, -50))
            -- for i, droppable in ipairs(droppables) do
            --     droppable:slowDown()
            -- end
        end,
        leftButtonDown = function()
            background:moveCenter(pd.geometry.vector2D.new(-50, 0))
            -- droppables[controlIndex]:moveLeft()
        end,
        leftButtonUp = function()
            background:moveCenter(pd.geometry.vector2D.new(50, 0))
            -- droppables[controlIndex]:moveLeft()
        end,
        rightButtonDown = function()
            background:moveCenter(pd.geometry.vector2D.new(50, 0))
            --     droppables[controlIndex]:moveRight()
        end,
        rightButtonUp = function()
            background:moveCenter(pd.geometry.vector2D.new(-50, 0))
            --     droppables[controlIndex]:moveRight()
        end,
        AButtonUp = function()
            -- s:rotateRight()
            spawnPiece()
            -- droppables[controlIndex]:rotateRight()
        end,
        BButtonUp = function()
            -- s:rotateLeft()
            spawnPiece()
            -- droppables[controlIndex]:rotateLeft()
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

function pd.update()
    -- Clear screen
    gfx.clear()

    -- Draw grid
    gridview:drawInRect(0, 0, 400, 240)
    background:draw()

    -- Draw Pile
    pile:update()

    -- Draw droppables
    for i, droppable in ipairs(droppables) do
        droppable:update()
    end

    pd.timer:updateTimers()
end

function tick()
    checkCollisions()
    pd.timer.new(10, tick)
end

function spawnPiece()
    local position = math.random(4)
    local droppable, shape

    if (math.random(2) == 1) then
        shape = ShapeL
    else
        shape = ShapeO
    end

    local bounds = math.floor(math.max(pile.width, pile.height) / 2)

    if (position == 1) then
        droppable = Droppable(DIRECTION_DOWN, shape, math.random(3), 0, (GRID_WIDTH / 2) + math.random(-bounds, bounds))
    elseif (position == 2) then
        droppable = Droppable(DIRECTION_RIGHT, shape, math.random(3), (GRID_HEIGHT / 2) + math.random(-bounds, bounds),
            10)
    elseif (position == 3) then
        droppable = Droppable(DIRECTION_UP, shape, math.random(3), GRID_HEIGHT,
            (GRID_WIDTH / 2) + math.random(-bounds, bounds))
    elseif (position == 4) then
        droppable = Droppable(DIRECTION_LEFT, shape, math.random(3), (GRID_HEIGHT / 2) + math.random(-bounds, bounds),
            GRID_WIDTH - 10)
    end

    table.insert(droppables, droppable)
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
