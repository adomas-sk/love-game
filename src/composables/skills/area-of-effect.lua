-- WIP

local vector = require("libs.vector")

local addSprite = require("src.composables.adders.add-sprite")
local addCollision = require("src.composables.adders.add-collision")
local composable = require("src.composables.composable")
-- skillLifeCycle = {
--   precast = function(),
--   contact = function(),
--   destruct = function(),
-- }
-- aoeData = {
--   from = string
--   masks = categories[]
--   categories = categories[]
--   damage = number
-- }
-- handlerConfig = {
--   getSource = function(): vector
--   offset = number
--   maxLifeSpan = number
--   lifeCycle = skillLifeCycle
-- }
local AOECount = 0
local function createAOESkill(aoeData)
  local createCastHandler = function(handlerConfig)
    return function(inputData)
      AOECount = AOECount + 1
      if AOECount > 100000 then
        AOECount = 0
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
      if handlerConfig.lifeCycle and handlerConfig.lifeCycle.precast then
        handlerConfig.lifeCycle.precast()
      end
      local endOfLifeHandler = function ()
        projectile.eventEmitter:emitTo(projectileId, "destroy")
        if handlerConfig.lifeCycle and handlerConfig.lifeCycle.destruct then
          handlerConfig.lifeCycle.destruct()
        end
      end
      local collisionHandler = function ()
        if handlerConfig.lifeCycle and handlerConfig.lifeCycle.contact then
          handlerConfig.lifeCycle.contact()
        end
        endOfLifeHandler()
      end
      local updateHandler = function(delta)
        if lifeSpan > handlerConfig.maxLifeSpan then
          endOfLifeHandler()
        end
        lifeSpan = lifeSpan + delta
      end
      projectile:addEventHandler("update", updateHandler)
      projectile:addEventHandler("collide", collisionHandler)
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
