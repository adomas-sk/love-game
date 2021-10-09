local composable = {}
composable.__index = composable

function composable.init(config)
  composable.input = config.input
  composable.camera = config.camera
  composable.world = config.world
  composable.eventEmitter = config.eventEmitter
end
-- config: {
--   excludeFromEventEmitter = bool,
-- }
function composable.new(id, config)
  local comp = { id = id }
  setmetatable(comp, composable)

  if not config or config.excludeFromEventEmitter == nil then
    comp.eventEmitter:addComposable(comp)
  end
  comp.events = {
    draw = {},
    update = {},
    collide = {},
    destroy = {},
    takeDamage = {},
    move = {},
  }
  table.insert(comp.events.destroy, 1, function ()
    comp.input:removeEventHandler(id)
    comp.eventEmitter:removeComposable(id)
    comp = nil
  end)

  return comp
end

function composable:addEventHandler(eventName, handler)
  table.insert(self.events[eventName], 1, handler)
end

return composable
