Composable = {}
Composable.__index = Composable

function Composable.init(config)
  Composable.input = config.input
  Composable.camera = config.camera
  Composable.world = config.world
  Composable.eventEmitter = config.eventEmitter
end

function Composable.new(id, excludeFromEventEmitter)
  local composable = { id = id }
  setmetatable(composable, Composable)

  if excludeFromEventEmitter == nil then
    composable.eventEmitter:addComposable(composable)
  end
  composable.events = {
    draw = {},
    update = {},
    collide = {},
  }

  return composable
end

function Composable:addEventHandler(eventName, handler)
  table.insert(self.events[eventName], 1, handler)
end

return Composable
