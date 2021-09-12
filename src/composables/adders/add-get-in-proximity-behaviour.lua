local vector = require("libs/vector")

-- config = {
--   speed = number,
--   minDistance = number, -- at what distance aggresion starts
--   maxDistnace = number -- at what distance body starts moving towards aggresee
--   getDestination = function()
-- }
local function addGetInProximityBehaviour(c, config)
  assert(c.body ~= nil, "Tried to add GetInProximity behaviour to composable without body")

  c.getInProximityBehaviour = {
    destination = nil,
  }
  local updateTick = 0
  local updateHandler = function()
    if updateTick > 10 then
      local destination = config.getDestination()
      if destination ~= nil then
        local position = vector(c.body:getPosition())
        local distance = position:dist(destination)
        if config.minDistance and distance < config.minDistance then
          c.getInProximityBehaviour.destination = nil
        elseif config.maxDistance and distance > config.maxDistance then
          c.getInProximityBehaviour.destination = nil
        else
          c.getInProximityBehaviour.destination = destination
        end
      end
      updateTick = 0
    end
    if c.getInProximityBehaviour.destination ~= nil then
      local velocity = (c.getInProximityBehaviour.destination - vector(c.body:getPosition())):setmag(config.speed)
      c.body:setLinearVelocity(velocity:unpack())
    else
      c.body:setLinearVelocity(0, 0)
    end
    updateTick = updateTick + 1
  end
  c:addEventHandler("update", updateHandler)
end

return addGetInProximityBehaviour;
