local vector = require("libs.vector")

local addSprite = require("src.composables.adders.add-sprite")
local addCollision = require("src.composables.adders.add-collision")
local composable = require("src.composables.composable")

-- projectileData: {
--   from = string
--   masks = categories[]
--   categories = categories[]
--   damage = number
-- }
-- handlerConfig: {
--   getSource = function(): vector
--   offset = number
--   maxLifeSpan = number
-- }
local projectileCount = 0
local function createBasicProjectileSkill(projectileData)
  local createCastHandler = function(handlerConfig)
    return function(inputData)
      projectileCount = projectileCount + 1
      if projectileCount > 100000 then
        projectileCount = 0
      end
      local destination = inputData.destination
      local source = handlerConfig.getSource()
      local direction = (destination - source):norm()
      local lifeSpan = 0

      local projectileRadius = 5
      local projectilePos =
        source +
        (
          direction:clone():setmag(1) *
          vector(
            handlerConfig.offset + projectileRadius + 2,
            handlerConfig.offset + projectileRadius + 2
          )
        )
      local initX,initY = projectilePos:unpack()

      local projectileId = "projectile" .. projectileCount

      local projectile = composable.new(projectileId)
      addCollision(projectile, {
        x = initX,
        y = initY,
        radius = projectileRadius,
        type = "dynamic",
        shape = "circle",
        fixtureData = {
          from = projectileData.from,
          damage = projectileData.damage
        },
        masks = projectileData.masks,
        categories = projectileData.categories,
      })
      addSprite(projectile, {
        drawPosition = 4,
        radius = 5,
        color = {0.5, 1, 0.5, 1}
      })

      projectile.body:setLinearVelocity(direction:setmag(100):unpack())

      local endOfLifeHandler = function ()
        projectile.eventEmitter:emitTo(projectileId, "destroy")
      end
      local updateHandler = function(delta)
        if lifeSpan > handlerConfig.maxLifeSpan then
          endOfLifeHandler()
        end
        lifeSpan = lifeSpan + delta
      end
      projectile:addEventHandler("update", updateHandler)
      projectile:addEventHandler("collide", endOfLifeHandler)
    end
  end

  local config = {
    id = "basicProjectile",
    speed = 10,
    createCastHandler = createCastHandler,
  }

  return config
end

return createBasicProjectileSkill
