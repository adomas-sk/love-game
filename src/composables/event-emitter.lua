EventEmitter = {}
EventEmitter.__index = EventEmitter

function EventEmitter.new()
  local eventEmitter = {}
  setmetatable(eventEmitter, EventEmitter)
  
  eventEmitter.composables = {}

  return eventEmitter
end

function EventEmitter:addComposable(c)
  if self.composables[c.id] then
    error("EventEmitter: Composable already exists - $c.id")
  end
  self.composables[c.id] = c
end

function EventEmitter:emitTo(cId, key, payload)
  if self.composables[cId] == nil then
    error("EventEmitter: emitting event to non existing composable")
  end
  for _, eventHandler in pairs(self.composables[cId].events[key]) do
    eventHandler(payload)
  end
end

function EventEmitter:emit(key, payload)
  for _, c in pairs(self.composables) do
    for _, eventHandler in pairs(c.events[key]) do
      eventHandler(payload)
    end
  end
end

return EventEmitter
