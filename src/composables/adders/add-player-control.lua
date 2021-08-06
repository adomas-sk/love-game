local vector = require("../../../libs/vector")

local function addPlayerControl(c, controlData)
  if c.position == nil then
    error("Tried to add playerControl to composable that does not have position")
  end

  c.playerControl = {
    lastPosition = c.position:clone()
  }

  local mouse1Handler = function (x, y)
    local cameraX, cameraY = c.camera:position()
    local windowW, windowH = love.graphics.getDimensions()
    local destination = vector(x, y) + vector(cameraX - windowW / 2, cameraY - windowH / 2)
    c.playerControl.currentVelocity = (destination - c.position):setmag(3)
    c.playerControl.destination = destination
  end

  local updateHandler = function ()
    if c.playerControl.currentVelocity ~= nil then
      if c.playerControl.destination:dist(c.position) < 2 then
        c.playerControl.currentVelocity = nil
      else
        c.position = c.position + c.playerControl.currentVelocity
      end
    end
    c.playerControl.lastPosition = c.position:clone()
  end

  local collisionHandler = function(collisionObject)
    print(collisionObject.shape)
    c.playerControl.currentVelocity = nil
    c.position = c.playerControl.lastPosition
  end

  c.input:addEventHandler("mouse1", mouse1Handler)
  c:addEventHandler("update", updateHandler)
  c:addEventHandler("collide", collisionHandler)
end

return addPlayerControl
