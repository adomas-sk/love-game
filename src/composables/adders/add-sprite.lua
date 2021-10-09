local vector = require("libs.vector")
local anim8 = require("libs.anim8")

local assets = require("src.assets.assets")

-- spriteData: {
--   spriteName = string,
--   shape = "circle" | "rectangle",
--   animation = string,
--   w = number,
--   h = number,
--   radius = number,
--   color = {1,1,1,1}
--   getPosition = function(): x, y
-- }
local function addSprite(c, spriteData)
  if spriteData.getPosition == nil and c.body then
    spriteData.getPosition = function () return c.body:getPosition() end
  end
  assert(spriteData.getPosition ~= nil, "addSprite: no getPosition")

  if spriteData.spriteName then
    local animationData = assets.images[spriteData.spriteName][spriteData.animation]
    local image = love.graphics.newImage(animationData.src)

    local grid = anim8.newGrid(200, 200, image:getWidth(), image:getHeight())

    local animations = {}
    local updateAnimation = {}
    local currentAnimation = "walk-sd"
    for k,v in pairs(animationData.directions) do
      animations[k] = anim8.newAnimation(grid(v.range[1], v.range[2]), v.speed)
      updateAnimation[v.rot] = k
    end

    local drawHandler = function ()
      love.graphics.setColor(1,1,1,1)
      local x, y = spriteData.getPosition()
      animations[currentAnimation]:draw(image, x - 100, y - 100)
    end

    local updateHandler = function (dt)
      animations[currentAnimation]:update(dt)
    end

    local moveHandler = function(direction)
      if not (direction.x == 0 and direction.y == 0) then
        local rotation = math.atan2(direction.y, direction.x) / math.pi
        if updateAnimation[rotation] then
          currentAnimation = updateAnimation[rotation]
        end
      end
    end

    c.eventEmitter:addDrawHandler(c.id, drawHandler, spriteData.drawPosition)
    c:addEventHandler("update", updateHandler)
    c:addEventHandler("move", moveHandler)
    return nil
  end

  -- THIS IS FOR DEBUGGING AND PRIMITIVES

  local lightShape = nil
  local shape = c.shape
  if spriteData.shape ~= nil then
    shape = spriteData.shape
  end
  if shape == "rectangle" and spriteData.shadowBody then
    local x, y = spriteData.getPosition()
    lightShape = c.lightWorld:newRectangle(x, y, spriteData.w, spriteData.h)
    local drawHandler = function ()
      love.graphics.polygon("fill", lightShape:getPoints())
    end
    c.eventEmitter:addDrawHandler(c.id, drawHandler, spriteData.drawPosition)
    return nil
  end

  local drawHandler = function ()
    local x, y = spriteData.getPosition()
    if x == nil and y == nil then
      return nil
    end
    love.graphics.setColor(spriteData.color[1],spriteData.color[2],spriteData.color[3],spriteData.color[4])
    if shape == "circle" then
      love.graphics.circle("fill", x, y, spriteData.radius, 20)
    elseif shape == "rectangle" then
      love.graphics.rectangle("fill", x - (spriteData.w / 2), y - (spriteData.h / 2), spriteData.w, spriteData.h)
    end
  end

  c.eventEmitter:addDrawHandler(c.id, drawHandler, spriteData.drawPosition)
end

return addSprite
