-- config = {
--   x = number,
--   y = number,
--   color = {1,1,1,1}
-- }
local function addText(c, drawble, config)
  local drawHandler = function()
    love.graphics.setColor(unpack(config.color))
    love.graphics.draw(drawble, config.x, config.y)
  end
  c.eventEmitter:addDrawHandler(c.id, drawHandler, 7)
end

return addText
