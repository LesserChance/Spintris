local pd <const>  = playdate
local gfx <const> = pd.graphics

---@class CrankHandler
class("CrankHandler", {
    direction = DIRECTION_LEFT,
    crankPosition = 0,
    zeroPosition = 0,
    distanceFromZero = 0,
    rotationCallback = nil
}).extends()

function CrankHandler:init(direction, rotationCallback)
    self.direction = direction
    self.rotationCallback = rotationCallback
end

function CrankHandler:handleCrankRotations(rotations)
    self.rotationCallback(rotations)
end

function CrankHandler:crankInputHandler(change, acceleratedChange)
    self.crankPosition = playdate.getCrankPosition()
    self.distanceFromZero += change

    if (self.direction == DIRECTION_RIGHT) then
        if (change >= 0) then
            -- checking right going right
            if (self.distanceFromZero > CRANK_ROTATE_DISTANCE) then
                local rotations = (math.floor(self.distanceFromZero / 90) + 1)
                self:handleCrankRotations(rotations)
                self:adjustCrankZeroPoint(rotations)
            end
        else
            -- checking right going left
            self:resetZeroPositionToCurrent()
        end
    else
        if (change <= 0) then
            -- checking left going left
            if (self.distanceFromZero < -1 * CRANK_ROTATE_DISTANCE) then
                local rotations = (math.floor(-1 * self.distanceFromZero / 90) + 1)
                self:handleCrankRotations(rotations)
                self:adjustCrankZeroPoint(rotations)
            end
        else
            -- checking left going right
            self:resetZeroPositionToCurrent()
        end
    end
end

function CrankHandler:adjustCrankZeroPoint(rotations)
    if (self.direction == DIRECTION_RIGHT) then
        local newZeroPosition = (self.zeroPosition + (90 * rotations))
        self.zeroPosition = newZeroPosition % 360
        self.distanceFromZero = self.crankPosition - newZeroPosition
    else
        self.zeroPosition = (self.zeroPosition - (90 * rotations)) % 360
        self.distanceFromZero = self.crankPosition - self.zeroPosition
    end
end

function CrankHandler:resetZeroPositionToCurrent()
    if (self.direction == DIRECTION_RIGHT) then
        local newZeroPosition = (math.floor((self.crankPosition + 90) / 90) * 90)
        self.zeroPosition = newZeroPosition % 360
        self.distanceFromZero = self.crankPosition - newZeroPosition
    else
        self.zeroPosition = math.floor(self.crankPosition / 90) * 90
        self.distanceFromZero = self.crankPosition - self.zeroPosition
    end
end
