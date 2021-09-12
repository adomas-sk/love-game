local vector = require("libs/vector")

local function addPlayerControl(c)
  assert(c.body ~= nil, "Tried to add playerControl to composable that does not have body")

  c.playerControl = {
    x = 0,
    y = 0
  }

  local updateHandler = function()
    local direction = vector(c.playerControl.x, c.playerControl.y)
    c.body:setLinearVelocity(direction:setmag(100):unpack())
  end
  local downHandler = function()
    c.playerControl.y = c.playerControl.y + 1
  end
  local upHandler = function()
    c.playerControl.y = c.playerControl.y - 1
  end
  local rightHandler = function()
    c.playerControl.x = c.playerControl.x + 1
  end
  local leftHandler = function()
    c.playerControl.x = c.playerControl.x - 1
  end

  c.input:addEventHandler(c.id, "w", upHandler)
  c.input:addEventHandler(c.id, "w", downHandler, true)

  c.input:addEventHandler(c.id, "s", downHandler)
  c.input:addEventHandler(c.id, "s", upHandler, true)

  c.input:addEventHandler(c.id, "a", leftHandler)
  c.input:addEventHandler(c.id, "a", rightHandler, true)

  c.input:addEventHandler(c.id, "d", rightHandler)
  c.input:addEventHandler(c.id, "d", leftHandler, true)
  c:addEventHandler("update", updateHandler)
end

return addPlayerControl
