local vector = require("libs.vector")

local inputManagement = {}
inputManagement.__index = inputManagement

local mouseNames = {
  [1] = "mouse1",
  [2] = "mouse2",
  [3] = "mouse3"
}

function inputManagement.new()
  local function createHandlers(key)
    return {
      pressed = {},
      release = {}
    }
  end
  local events = {
    q = createHandlers("q"),
    w = createHandlers("w"),
    e = createHandlers("e"),
    r = createHandlers("r"),
    i = createHandlers("i"),
    escape = createHandlers("escape"),
    [mouseNames[1]] = createHandlers(mouseNames[1]),
    [mouseNames[2]] = createHandlers(mouseNames[2]),
    [mouseNames[3]] = createHandlers(mouseNames[3]),
  }

  inputManagement.events = events
  return inputManagement
end

function inputManagement:addEventHandler(id, event, handler, release)
  if self.events[event] then
    if release then
      table.insert(self.events[event].release, { id = id, handler = handler })
    else
      table.insert(self.events[event].pressed, { id = id, handler = handler })
    end
  else
    error("inputManagement: tried to add event: " .. event .." , which doesn't exist")
  end
end

-- TODO: removing event reduces event handler list which makes the last event not trigger
-- add removed events to some list and only remove them after all handlers have been called
function inputManagement:removeEventHandler(id)
  for _,event in pairs(self.events) do
    for _,interaction in pairs(event) do
      local handlersToRemove = {}
      for index,handler in pairs(interaction) do
        if handler.id == id then
          table.insert(handlersToRemove, index)
        end
      end
      for _,index in pairs(handlersToRemove) do
        table.remove(interaction, index)
      end
    end
  end
end

function inputManagement:keypressed(key)
  if self.events[key] then
    for _i, value in pairs(self.events[key].pressed) do
      value.handler(self:getInputData())
    end
  end
end

function inputManagement:keyrelease(key)
  if self.events[key] then
    for _i, value in pairs(self.events[key].release) do
      value.handler(self:getInputData())
    end
  end
end

function inputManagement:mousepressed(button)
  self:keypressed(mouseNames[button])
end

function inputManagement:mouserelease(button)
  self:keyrelease(mouseNames[button])
end

function inputManagement:getInputData()
  local mouseX,mouseY = love.mouse.getPosition()
  local cameraX,cameraY = Camera:position()
  local windowW,windowH = love.graphics.getDimensions()
  local destination = vector(mouseX + cameraX - windowW / 2, mouseY + cameraY - windowH / 2)

  local inputData = {
    mouse = vector(mouseX,mouseY),
    destination = destination
  }
  return inputData
end

return inputManagement
