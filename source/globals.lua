local pd <const>                   = playdate
local gfx <const>                  = pd.graphics

-- x and y dimensions (in pixels) of each cell
CELL_SIZE                          = 10

DIRECTION_LEFT                     = 0
DIRECTION_RIGHT                    = 1
DIRECTION_UP                       = 2
DIRECTION_DOWN                     = 3

POSITION_LEFT                      = 270
POSITION_RIGHT                     = 90
POSITION_UP                        = 0
POSITION_DOWN                      = 180

MIN_DROPPABLE_SPEED                = 800
MAX_DROPPABLE_SPEED                = 150

DISPLAY_WIDTH                      = pd.display.getWidth()
DISPLAY_HEIGHT                     = pd.display.getHeight()

GRID_WIDTH                         = DISPLAY_WIDTH / CELL_SIZE
GRID_HEIGHT                        = DISPLAY_HEIGHT / CELL_SIZE

DISPLAY_CENTER                     = pd.geometry.point.new(DISPLAY_WIDTH / 2, DISPLAY_HEIGHT / 2)
DISPLAY_GRID_CENTER                = { row = math.floor(GRID_HEIGHT / 2), column = math.floor(GRID_WIDTH / 2) }

DEFAULT_DRAWABLE_ROTATION_DURATION = 1000
PILE_ROTATE_DURATION               = 150

-- How far from zero before we should rotate
CRANK_ROTATE_DISTANCE              = 25
