local hitables = {player = true, baddie = true}

local function createCollisionHandler (world, eventEmitter)
  local handleBeingHit = function(cId, damage)
    eventEmitter:emitTo(cId, "takeDamage", damage)
  end

  local beginContact = function(fixture1, fixture2)
    local fixture1Data = fixture1:getUserData()
    local fixture2Data = fixture2:getUserData()
    eventEmitter:emitTo(fixture1Data.id, "collide")
    eventEmitter:emitTo(fixture2Data.id, "collide")
    if fixture1Data.from ~= nil and fixture1Data.from == fixture2Data.dmgBy then
      handleBeingHit(fixture2Data.id, fixture1Data.damage)
    elseif fixture2Data.from ~= nil and fixture2Data.from == fixture1Data.dmgBy then
      handleBeingHit(fixture1Data.id, fixture2Data.damage)
    end
  end
  
  world:setCallbacks(beginContact)
end


return createCollisionHandler
