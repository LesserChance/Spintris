import "CoreLibs/object"

local pd <const> = playdate

class("ShapeO", {
    shape = "O",
    width = 2,
    height = 2,
    occupiedCells = {
        [1] = { [1] = true, [2] = true },
        [2] = { [1] = true, [2] = true }
    },
    pivotCenter = pd.geometry.point.new((2 * CELL_SIZE) / 2, (2 * CELL_SIZE) / 2)
}).extends()
