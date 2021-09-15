local Composable = require("src.composables.composable")
local addSprite = require("src.composables.adders.add-sprite")
local addCollision = require("src.composables.adders.add-collision")
local addHealth = require("src.composables.adders.add-health")

-- config = {
--   initialCoords = {x,y}
--   buildingType = string
-- }
local buildingCount = 0
local function buildBuilding(config)
  local buildingId = "building" .. buildingCount
  if config.buildingType then
    buildingId = "building-".. config.buildingType .. buildingCount
  end
  local building = Composable.new(buildingId)
  buildingCount = buildingCount + 1
  addCollision(building, {
    x = config.initialCoords[1],
    y = config.initialCoords[2],
    h = 20,
    w = 20,
    shape = "rectangle",
    type = "static",
    fixtureData = {
      dmgBy = "enemy"
    },
    categories = {"building"},
    masks = {}
  })
  addSprite(building, {
    h = 20,
    w = 20,
    drawPosition = 6,
    color = {1,1,1,1,}
  })
  local deathCallback = function()
    print("building ded")
  end
  addHealth(building, {
    max = 10,
    initial = 10,
    deathCallback = deathCallback,
  })
end

return buildBuilding
