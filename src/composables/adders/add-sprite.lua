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

  if spriteData.light then
    local x,y = spriteData.getPosition();
    local ligth = c.lightWorld:newLight(x, y, 255, 127, 63, 1000)
    ligth:setGlowStrength(1)
    return nil
  end

  if spriteData.spriteName and spriteData.animation then
    local animationData = assets.images[spriteData.spriteName][spriteData.animation]
    local image = love.graphics.newImage(animationData.src)
    local normal = love.graphics.newImage(animationData.normal)
    local data = require(animationData.data)

    local lightWorldImage = c.lightWorld:newImage(image, 200, 200)
    lightWorldImage:setNormalMap(normal, 200, 200, 0, 0)
    local animations = {
      s = {},
      sw = {},
      w = {},
      nw = {},
      n = {},
      ne = {},
      e = {},
      se = {},
    }

    for index,v in ipairs(animationData.directions.s) do
      local frame = data.frames[v].frame
      local quad = love.graphics.newQuad(frame.x, frame.y, frame.w, frame.h, image:getDimensions())
      animations.s[index] = quad
    end

    local currentFrame = 3
    local drawHandler = function ()
      local x, y = spriteData.getPosition()
      love.graphics.setColor(1,1,1,1)

      local normalFrame = data.frames[animationData.directions.s[currentFrame]].frame
      local normalX, normalY = normalFrame.x, normalFrame.y
      lightWorldImage:setNormalMapOffset(normalX, normalY)
      lightWorldImage:setPosition(x - 100, y - 100)
      love.graphics.draw(image, animations.s[currentFrame], x - 100, y - 100)
    end
    local second = 0
    local updateHandler = function(dt)
      second = second + dt
      print(second, dt)
      if second >= 0.1 then
        second = 0
        currentFrame = currentFrame + 1
        if currentFrame > 15 then
          currentFrame = 1
        end
      end
    end
    c.eventEmitter:addDrawHandler(c.id, drawHandler, spriteData.drawPosition)
    c:addEventHandler("update", updateHandler)
    return nil
  end

  -- THIS IS FOR DEBUGGING AND PRIMITIVES

  local lightShape = nil
  local shape = c.shape
  if spriteData.shape ~= nil then
    shape = spriteData.shape
  end
  if shape == "rectangle" then
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
