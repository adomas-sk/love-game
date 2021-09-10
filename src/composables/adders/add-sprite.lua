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

  if spriteData.spriteName and spriteData.animation then
    local image = love.graphics.newImage(assets.images[spriteData.spriteName].src)
    local animation = {}
    local currentAnimation = 1
    local lastAnimation = 0
    for _,v in pairs(assets.images[spriteData.spriteName].animations[spriteData.animation]) do
      table.insert(animation, love.graphics.newQuad(v[1], v[2], v[3], v[4], image:getDimensions()))
      lastAnimation = lastAnimation + 1
    end

    local drawHandler = function ()
      local x, y = spriteData.getPosition()
      if x == nil and y == nil then
        return nil
      end
      love.graphics.setColor(1,1,1,1)
      love.graphics.draw(image, animation[currentAnimation], x - 240, y - 240)
    end

    local changeAnimationAfterEvery = 0.016 * 8
    local lastAnimationChange = 0
    local updateHandler = function (delta)
      lastAnimationChange = lastAnimationChange + delta
      if changeAnimationAfterEvery <= lastAnimationChange then
        lastAnimationChange = 0
        currentAnimation = currentAnimation + 1
        if currentAnimation > lastAnimation then
          currentAnimation = 1
        end
      end
    end
  
    c.eventEmitter:addDrawHandler(c.id, drawHandler, spriteData.drawPosition)
    c:addEventHandler("update", updateHandler)
    return nil
  end

  local drawHandler = function ()
    local x, y = spriteData.getPosition()
    if x == nil and y == nil then
      return nil
    end
    local shape = c.shape
    if spriteData["shape"] ~= nil then
      shape = spriteData.shape
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
