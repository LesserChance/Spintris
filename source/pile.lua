import "drawable"
import "crankHandler"
import "shapes/Pile"

local pd <const> = playdate

---@class Pile
class("Pile", {
    crankHandler = nil
}).extends(Drawable)

function Pile:init()
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
