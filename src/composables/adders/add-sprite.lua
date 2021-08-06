local vector = require("../../../libs/vector")

local function addSprite(c, spriteData)
  local drawHandler = function ()
    local x, y = c.position:unpack()
    local shape = c.shape
    if spriteData["shape"] ~= nil then
      shape = spriteData.shape
    end
    if shape == "circle" then
      love.graphics.circle("fill", x, y, spriteData.radius, 20)
    elseif shape == "rectangle" then
      love.graphics.rectangle("line", x - (spriteData.w / 2), y - (spriteData.h / 2), spriteData.w, spriteData.h)
    end
  end

  c:addEventHandler("draw", drawHandler)
end

return addSprite
