import "CoreLibs/object"

class("ShapeL", {
    shape = "L",
    width = 2,
    height = 3,
    occupiedCells = {
        [1] = { [1] = true },
        [2] = { [1] = true },
        [3] = { [1] = true, [2] = true }
    },
}).extends()
