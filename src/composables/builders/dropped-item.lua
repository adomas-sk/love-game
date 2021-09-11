local Composable = require("src.composables.composable")
local addSprite = require("src.composables.adders.add-sprite")
local addClickHandler = require("src.composables.adders.add-click-handler")
local addText = require("src.composables.adders.add-text")
local createBasicProjectileSkill = require("src.composables.skills.basic-projectile")

-- config: {
--   x = number,
--   y = number,
--   text = string,
-- }
local droppedItemCount = 0
local function buildDroppedItem(config)
  local font = love.graphics.getFont()
  local plainText = love.graphics.newText(font, config.text)
  local itemId = "itemOnTheGround" .. droppedItemCount
  local itemOnTheGround = Composable.new(itemId)
  local w,h = plainText:getWidth(),plainText:getHeight()
  addSprite(itemOnTheGround, {
    getPosition = function() return config.x, config.y end,
    shape = "rectangle",
    w = w,
    h = h,
    color = {0.7,0.7,0.7,0.7}
  })
  addText(itemOnTheGround, plainText, {
    x = config.x - w/2,
    y = config.y - h/2,
    color = {0,0,0,1}
  })
  local clickPickup = function()
    local pickedUp = Player.inventory:addToFirst({
      color = {1,0,0,1},
      skill = createBasicProjectileSkill
    })
    if pickedUp then
      itemOnTheGround.eventEmitter:emitTo(itemId, "destroy")
    end
  end
  addClickHandler(itemOnTheGround, {
    top = config.y - h/2,
    bottom = config.y + h/2,
    left = config.x - w/2,
    right = config.x + w/2,
    callback = clickPickup,
  })
  droppedItemCount = droppedItemCount + 1
end

return buildDroppedItem
