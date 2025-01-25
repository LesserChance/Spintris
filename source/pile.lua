import "drawable"
import "crankHandler"
import "shapes/Pile"

local pd <const> = playdate
local gfx <const> = pd.graphics

---@class Pile
class("Pile", {
    crankHandler = nil,
    rotationDuration = PILE_ROTATE_DURATION
}).extends(Drawable)

function Pile:init()
    --Pile.super.init(self, ShapePile, 0, DISPLAY_GRID_CENTER.row - 1, DISPLAY_GRID_CENTER.column - 1)
    Pile.super.init(self, ShapePile, 0, DISPLAY_GRID_CENTER.row - 1, DISPLAY_GRID_CENTER.column - 1)
    self.crankHandler = CrankHandler(DIRECTION_RIGHT, function(rotations)
        self:handleCrankRotations(rotations)
    end)
end

function Pile:handleCrankRotations(rotations)
    for rotation = 1, rotations do
        self:rotateRight()
    end
end
