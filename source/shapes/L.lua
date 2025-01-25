import "CoreLibs/object"

local pd <const> = playdate

class("ShapeL", {
    shape = "L",
    width = 2,
    height = 3,
    occupiedCells = {
        [1] = { [1] = true },
        [2] = { [1] = true },
        [3] = { [1] = true, [2] = true }
    },
    pivotCenter = pd.geometry.point.new((2 * CELL_SIZE) / 2, (3 * CELL_SIZE) / 2)
}).extends()
