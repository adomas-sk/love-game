local eventEmitter = {}
eventEmitter.__index = eventEmitter

function eventEmitter.new()
  eventEmitter.composables = {}
  eventEmitter.drawEvents = {}
  table.insert(eventEmitter.drawEvents, {}) -- 1
  table.insert(eventEmitter.drawEvents, {}) -- 2
  table.insert(eventEmitter.drawEvents, {}) -- 3
  table.insert(eventEmitter.drawEvents, {}) -- 4
  table.insert(eventEmitter.drawEvents, {}) -- 5 Default
  table.insert(eventEmitter.drawEvents, {}) -- 6 Player
  table.insert(eventEmitter.drawEvents, {}) -- 7
  eventEmitter.hudDrawEvents = {}
  table.insert(eventEmitter.hudDrawEvents, {}) -- 1 UI
  table.insert(eventEmitter.hudDrawEvents, {}) -- 2 UI

  return eventEmitter
end

function eventEmitter:addComposable(c)
  if self.composables[c.id] then
    error("eventEmitter: Composable already exists - " .. c.id)
  end
  self.composables[c.id] = c
end

function eventEmitter:getComposable(cId)
  return self.composables[cId]
end

function eventEmitter:getComposables(cId)
  local composables = {}
  for k,v in pairs(self.composables) do
    if string.find(k, cId) then
      composables[k] = v
    end
  end
  return composables
end

function eventEmitter:removeComposable(cId)
  assert(self.composables[cId], "eventEmitter: Trying to remove non existing composable - " .. cId)
  self.composables[cId] = nil
  self:removeDrawHandler(cId)
end

-- TODO: Some composables (eg. projectiles) are destroyed after collision, but
-- they can have collisions with 2 colliders at the same time
-- whick would cause the projectile to emit destroy multiple times
function eventEmitter:emitTo(cId, key, payload)
  if self.composables[cId] == nil then
    print("eventEmitter WARNING: emitting event to non existing composable - " .. cId .. ", key - " .. key)
  else
    for _, eventHandler in pairs(self.composables[cId].events[key]) do
      eventHandler(payload)
    end
  end
end

function eventEmitter:emit(key, payload)
  for _, c in pairs(self.composables) do
    for _, eventHandler in pairs(c.events[key]) do
      eventHandler(payload)
    end
  end
end

function eventEmitter:addDrawHandler(id, handler, pos, hud)
  local position = pos or 5
  if hud then
    table.insert(self.hudDrawEvents[position], 1, { id = id, handler = handler })
  else
    table.insert(self.drawEvents[position], 1, { id = id, handler = handler })
  end
end

function eventEmitter:removeDrawHandler(id)
  for _,event in pairs(self.drawEvents) do
    local handlersToRemove = {}
    for index,handler in pairs(event) do
      if handler.id == id then
        table.insert(handlersToRemove, index)
      end
    end
    for _,index in pairs(handlersToRemove) do
      table.remove(event, index)
    end
  end
  for _,event in pairs(self.hudDrawEvents) do
    local handlersToRemove = {}
    for index,handler in pairs(event) do
      if handler.id == id then
        table.insert(handlersToRemove, index)
      end
    end
    for _,index in pairs(handlersToRemove) do
      table.remove(event, index)
    end
  end
end

function eventEmitter:emitDraw(hud)
  if hud then
    for _,v in pairs(self.hudDrawEvents) do
      for _, drawHandler in pairs(v) do
        drawHandler.handler()
      end
    end
  else
    for _,v in pairs(self.drawEvents) do
      for _, drawHandler in pairs(v) do
        drawHandler.handler()
      end
    end
  end
end

function eventEmitter:manualEmit(c, event, payload)
  for _, eventHandler in pairs(c.events[event]) do
    eventHandler(payload)
  end
end

return eventEmitter
