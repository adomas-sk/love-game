Composable = {}
Composable.__index = Composable

function Composable.init(config)
  Composable.input = config.input
  Composable.camera = config.camera
  Composable.worldCollider = config.worldCollider
  Composable.eventEmitter = config.eventEmitter
end

function Composable.new(id)
  local composable = { id = id }
  setmetatable(composable, Composable)

  composable.eventEmitter:addComposable(composable)
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
