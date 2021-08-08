local function createCollisionHandler (world, eventEmitter)
  local beginContact = function(fixture1, fixture2)
    eventEmitter:emitTo(fixture1:getUserData(), "collide")
    eventEmitter:emitTo(fixture2:getUserData(), "collide")
  end
  
  world:setCallbacks(beginContact)
end


return createCollisionHandler
