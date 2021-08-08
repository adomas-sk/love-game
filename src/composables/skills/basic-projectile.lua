local vector = require("libs.vector")

local addSprite = require("src.composables.adders.add-sprite")
local addCollision = require("src.composables.adders.add-collision")
local composable = require("src.composables.composable")

local function createBasicProjectileSkill()
  local projectileCount = 0
  local castHandler = function()
    projectileCount = projectileCount + 1
    if projectileCount > 100000 then
      projectileCount = 0
    end

    local mouseX,mouseY = love.mouse.getPosition()
    local cameraX,cameraY = Player.camera:position()
    local windowW,windowH = love.graphics.getDimensions()
    local destination = vector(mouseX + cameraX - windowW / 2, mouseY + cameraY - windowH / 2)
    local velocity = (destination - vector(Player.body:getPosition())):setmag(150)

    local projectileRadius = 5
    local playerRadius = Player.collider:getRadius()
    local playerPos = vector(Player.body:getPosition()) + (velocity:clone():setmag(1) * vector(playerRadius + projectileRadius + 2,playerRadius + projectileRadius + 2))
    local initX,initY = playerPos:unpack()
    
    local projectileId = "projectile" .. projectileCount

    local projectile = composable.new(projectileId)
    addCollision(projectile, {
      x = initX,
      y = initY,
      radius = projectileRadius,
      type = "dynamic",
      shape = "circle",
    })
    addSprite(projectile, {
      drawPosition = 4,
      radius = 5,
      color = {0.5, 1, 0.5, 1}
    })

    projectile.body:setLinearVelocity(velocity:unpack())

    local collisionHandler = function ()
      projectile.eventEmitter:emitTo(projectileId, "destroy")
    end
    projectile:addEventHandler("collide", collisionHandler)
  end
  

  local config = {
    id = "basicProjectile",
    speed = 10,
    castHandler = castHandler,
  }
  
  -- TODO figure out how to fix memory leak here
  return config
end

return createBasicProjectileSkill
