-- spriteData: {
--   x = number,
--   y = number,
--   shape = "circle" | "rectangle",
--   w = number,
--   h = number,
--   radius = number,
-- }
local function addSprite(c, spriteData)
  if spriteData.getPosition == nil and c.body then
    spriteData.getPosition = function () return c.body:getPosition() end
  end
  if spriteData == nil then
    error("addSprite: no getPosition")
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

  c.eventEmitter:addDrawHandler(drawHandler, spriteData.drawPosition)
end

return addSprite
