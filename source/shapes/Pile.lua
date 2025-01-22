import "CoreLibs/object"

class("ShapePile", {
    shape = "Pile",
    width = 4,
    height = 4,
    occupiedCells = {
        [1] = { [1] = true, [2] = true, [3] = true, [4] = true },
        [2] = { [1] = true, [2] = true, [3] = true, [4] = true },
        [3] = { [1] = true, [2] = true, [3] = true, [4] = true },
        [4] = { [1] = true, [2] = true, [3] = true, [4] = true },
    },
}).extends()
