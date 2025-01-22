import "CoreLibs/object"

class("ShapeO", {
    shape = "O",
    width = 2,
    height = 2,
    occupiedCells = {
        [1] = { [1] = true, [2] = true },
        [2] = { [1] = true, [2] = true }
    },
}).extends()
