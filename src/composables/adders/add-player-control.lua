local vector = require("libs/vector")
local Composable = require("src.composables.composable")
local addSprite = require("src.composables.adders.add-sprite")

local function addPlayerControl(c)
  if c.body == nil then
    error("Tried to add playerControl to composable that does not have body")
  end

  c.playerControl = {
    walkToPointSprite = Composable.new("walkToPoint")
  }
  local getWalkToPointSpritePosition = function()
    if c.playerControl.destination then
      return c.playerControl.destination:unpack()
    end
    return nil, nil
  end
  addSprite(c.playerControl.walkToPointSprite, {
    getPosition = getWalkToPointSpritePosition,
    shape = "circle",
    radius = 5,
    color = {1, 1, 0.5, 1}
  })

  local mouse1Handler = function(x, y)
    if c.show.inventory then
      return nil
    end
    local cameraX, cameraY = c.camera:position()
    local windowW, windowH = love.graphics.getDimensions()
    local destination = vector(x + cameraX - windowW / 2, y + cameraY - windowH / 2)
    c.playerControl.destination = destination
  end

  local updateHandler = function()
    if c.playerControl.destination ~= nil then
      if c.playerControl.destination:dist(vector(c.body:getPosition())) < 1 then
        c.playerControl.destination = nil
        c.body:setLinearVelocity(0, 0)
      else
        local velocity = (c.playerControl.destination - vector(c.body:getPosition())):setmag(100)
        c.body:setLinearVelocity(velocity:unpack())
      end
    end
  end

  c.input:addEventHandler(c.id, "mouse1", mouse1Handler)
  c:addEventHandler("update", updateHandler)
end

return addPlayerControl
