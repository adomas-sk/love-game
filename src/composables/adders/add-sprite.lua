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

  -- TODO: move this to another adder
  if spriteData.light then
    local sun = c.lightWorld:newLight(0,0, 255, 127, 63, 10000)
    sun:setGlowStrength(0.3)
    local updateHandler = function (dt)
      local x, y = Player.body:getPosition()
      sun:setPosition(x + 5000, y + 3000, 200)
    end

    c:addEventHandler("update", updateHandler)
    return nil
  end

  if spriteData.spriteName then
    local animationData = assets.images[spriteData.spriteName][spriteData.animation]
    local image = love.graphics.newImage(animationData.src)
    local normal = love.graphics.newImage(animationData.normal)

    -- TODO: figure out how to draw shadow
    local animation = c.lightWorld:newAnimationGrid(image, 0, 0)
    animation:setNormalMap(normal)
    local grid = animation:newGrid(200, 200)

    animation:addAnimation("walk-s", grid("1-15", 1), 0.1)
    animation:addAnimation("walk-sw", grid("1-15", 2), 0.1)
    animation:addAnimation("walk-w", grid("1-15", 3), 0.1)
    animation:addAnimation("walk-nw", grid("1-15", 4), 0.1)
    animation:addAnimation("walk-n", grid("1-15", 5), 0.1)
    animation:addAnimation("walk-ne", grid("1-15", 6), 0.1)
    animation:addAnimation("walk-e", grid("1-15", 7), 0.1)
    animation:addAnimation("walk-se", grid("1-15", 8), 0.1)

    local drawHandler = function ()
      love.graphics.setColor(1,1,1,1)
      local x, y = spriteData.getPosition()
      animation:setPosition(x, y)
      animation:drawAnimation()
    end

    c.eventEmitter:addDrawHandler(c.id, drawHandler, spriteData.drawPosition)
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
