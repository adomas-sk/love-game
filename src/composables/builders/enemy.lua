local vector = require("libs/vector")

local Composable = require("src.composables.composable")
local addSprite = require("src.composables.adders.add-sprite")
local addCollision = require("src.composables.adders.add-collision")
local addGetInProximityBehaviour = require("src.composables.adders.add-get-in-proximity-behaviour")
local addHostileBehaviour = require("src.composables.adders.add-hostile-behaviour")
local addHealth = require("src.composables.adders.add-health")

local createBasicProjectileSkill = require("src.composables.skills.basic-projectile")
local buildDroppedItem = require("src.composables.builders.dropped-item")

-- config = {
--   initialCoords = {x,y}
-- }
local enemyCount = 0
local function buildEnemy(config)
  local baddieId = "baddie" .. enemyCount
  local baddie = Composable.new(baddieId)
  addCollision(baddie, {
    x = config.initialCoords[1],
    y = config.initialCoords[2],
    radius = 20,
    shape = "circle",
    type = "dynamic",
    fixtureData = {
      dmgBy = "player"
    },
    categories = {"enemy"},
    masks = {"enemyProjectile"}
  })
  addSprite(baddie, {
    drawPosition = 6,
    radius = 20,
    color = {1, 0, 0, 1,}
  })
  local getDestination = function ()
    local player = EventEmitter:getComposable("player")
    if player ~= nil then
      return vector(player.body:getPosition())
    end
    return nil
  end
  addGetInProximityBehaviour(baddie, {
    speed = 50,
    minDistance = 150,
    maxDistance = 300,
    getDestination = getDestination
  })
  addHostileBehaviour(baddie, {
    target = "player",
    minDistance = 150,
    skill = createBasicProjectileSkill(
      {
        from = "baddie",
        damage = 1,
        masks = { "enemy", "enemyProjectile" },
        categories = { "enemyProjectile" }
      }
    )
  })
  local deathCallback = function()
    local x,y = baddie.body:getPosition()
    buildDroppedItem({
      x = x,
      y = y,
      text = "Sword"
    })
  end
  addHealth(baddie, {
    max = 10,
    initial = 10,
    deathCallback = deathCallback,
  })
  enemyCount = enemyCount + 1
end

return buildEnemy
