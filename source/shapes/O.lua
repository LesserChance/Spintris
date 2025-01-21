import "CoreLibs/object"

class("ShapeO", {
    shape = "O",
    size = 4,
    rows = 2,
    columns = 2,
    pieces = {
        [1] = true,
        [2] = true,
        [3] = true,
        [4] = true
    }
}).extends(Object)
