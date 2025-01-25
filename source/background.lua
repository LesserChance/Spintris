import "CoreLibs/math"
import "CoreLibs/easing"

import "drawable"
import "crankHandler"

local pd <const> = playdate
local gfx <const> = pd.graphics

LERP_DURATION = 350

---@class Background
class("Background", {
    center = pd.geometry.point.new(DISPLAY_WIDTH / 2, DISPLAY_HEIGHT / 2),
    offsetX = 0,
    offsetY = 0,
    targetOffsetX = 0,
    targetOffsetY = 0,
    xLerpTimer,
    yLerpTimer
}).extends()

function Background:init()

end

---comment
---@param move playdate.geometry.vector2D
function Background:moveCenter(move)
    local endX = self.offsetX + move.dx
    local endY = self.offsetY + move.dy

    if (self.xLerpTimer and self.xLerpTimer.timeLeft > 0) then
        endX = self.xLerpTimer.endValue + move.dx
        endY = self.yLerpTimer.endValue + move.dy
    else
        endX = math.floor(self.offsetX + .5) + move.dx;
        endY = math.floor(self.offsetY + .5) + move.dy;
    end

    self.xLerpTimer = pd.timer.new(LERP_DURATION, self.offsetX, endX, pd.easingFunctions.inOutCubic)
    self.yLerpTimer = pd.timer.new(LERP_DURATION, self.offsetY, endY, pd.easingFunctions.inOutCubic)
end

function Background:draw()
    if (self.xLerpTimer and self.xLerpTimer.running) then
        self.offsetX = self.xLerpTimer.value
        self.offsetY = self.yLerpTimer.value
    end

    gfx.pushContext()
    gfx.setColor(gfx.kColorBlack)

    gfx.setDitherPattern(0.1, gfx.image.kDitherTypeBayer8x8)
    gfx.fillCircleAtPoint(self.center.x + (self.offsetX), self.center.y + (self.offsetY), 5)

    gfx.setDitherPattern(0.3, gfx.image.kDitherTypeBayer8x8)
    gfx.fillCircleAtPoint(self.center.x + (self.offsetX), self.center.y + (self.offsetY), 20)

    gfx.setDitherPattern(0.4, gfx.image.kDitherTypeBayer8x8)
    gfx.fillCircleAtPoint(self.center.x + (self.offsetX * .9), self.center.y + (self.offsetY * .9), 30)

    gfx.setDitherPattern(0.5, gfx.image.kDitherTypeBayer8x8)
    gfx.fillCircleAtPoint(self.center.x + (self.offsetX * .8), self.center.y + (self.offsetY * .8), 40)

    gfx.setDitherPattern(0.6, gfx.image.kDitherTypeBayer8x8)
    gfx.fillCircleAtPoint(self.center.x + (self.offsetX * .7), self.center.y + (self.offsetY * .7), 50)

    gfx.setDitherPattern(0.7, gfx.image.kDitherTypeBayer8x8)
    gfx.fillCircleAtPoint(self.center.x + (self.offsetX * .6), self.center.y + (self.offsetY * .6), 80)

    gfx.setDitherPattern(0.8, gfx.image.kDitherTypeBayer8x8)
    gfx.fillCircleAtPoint(self.center.x + (self.offsetX * .5), self.center.y + (self.offsetY * .5), 120)

    gfx.setDitherPattern(0.9, gfx.image.kDitherTypeBayer8x8)
    gfx.fillCircleAtPoint(self.center.x + (self.offsetX * .3), self.center.y + (self.offsetY * .3), 200)
    gfx.popContext()
end
