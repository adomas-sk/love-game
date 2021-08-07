EventEmitter = {}
EventEmitter.__index = EventEmitter

function EventEmitter.new()
  local eventEmitter = {}
  setmetatable(eventEmitter, EventEmitter)

  eventEmitter.composables = {}
  eventEmitter.drawEvents = {}
  table.insert(eventEmitter.drawEvents, {}) -- 1
  table.insert(eventEmitter.drawEvents, {}) -- 2
  table.insert(eventEmitter.drawEvents, {}) -- 3
  table.insert(eventEmitter.drawEvents, {}) -- 4
  table.insert(eventEmitter.drawEvents, {}) -- 5 Default
  table.insert(eventEmitter.drawEvents, {}) -- 6 Player
  table.insert(eventEmitter.drawEvents, {}) -- 7
  table.insert(eventEmitter.drawEvents, {}) -- 8 UI
  table.insert(eventEmitter.drawEvents, {}) -- 9 UI

  return eventEmitter
end

function EventEmitter:addComposable(c)
  if self.composables[c.id] then
    error("EventEmitter: Composable already exists - " .. c.id)
  end
  self.composables[c.id] = c
  print("added " .. c.id)
  for _, v in pairs(self.composables) do
    print(v.id)
  end
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

function EventEmitter:addDrawHandler(handler, pos)
  local position = 5
  if pos then
    position = pos
  end
  table.insert(self.drawEvents[position], 1, handler)
end

function EventEmitter:emitDraw()
  for _,v in pairs(self.drawEvents) do
    for _, drawHandler in pairs(v) do
      drawHandler()
    end
  end
end

function EventEmitter:manualEmit(c, event, payload)
  for _, eventHandler in pairs(c.events[event]) do
    eventHandler(payload)
  end
end

return EventEmitter
