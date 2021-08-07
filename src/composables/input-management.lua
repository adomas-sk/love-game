InputManagement = {}
InputManagement.__index = InputManagement

local mouseNames = {
  [1] = "mouse1",
  [2] = "mouse2",
  [3] = "mouse3"
}

function InputManagement.new()
  local inputManagement = {}
  setmetatable(inputManagement, InputManagement)

  local input = {
    w = 0
  }
  local function pressedHandler(key)
    return function()
      if input[key] == false then
        input.w = true
      end
    end
  end
  local function releaseHandler(key)
    return function()
      if input[key] then
        input.w = false
      end
    end
  end
  local function createHandlers(key)
    return {
      pressed = { pressedHandler(key) },
      release = { releaseHandler(key) }
    }
  end
  local events = {
    w = createHandlers("w"),
    [mouseNames[1]] = createHandlers(mouseNames[1]),
    [mouseNames[2]] = createHandlers(mouseNames[2]),
    [mouseNames[3]] = createHandlers(mouseNames[3]),
  }

  inputManagement.input = input
  inputManagement.events = events
  return inputManagement
end

function InputManagement:addEventHandler(event, handler)
  if self.events[event] then
    table.insert(self.events[event].pressed, 1, handler)
  else
    error("InputManagement: tried to add event: " .. event .." , which doesn't exist")
  end
end

function InputManagement:keypressed(key, x, y)
  if self.events[key] then
    for _i, value in pairs(self.events[key].pressed) do
      value(x, y)
    end
  end
end

function InputManagement:keyrelease(key, x, y)
  if self.events[key] then
    for _i, value in pairs(self.events[key].release) do
      value(x, y)
    end
  end
end

function InputManagement:mousepressed(x, y, button)
  self:keypressed(mouseNames[button], x, y)
end

function InputManagement:mouserelease(x, y, button)
  self:keyrelease(mouseNames[button], x, y)
end

return InputManagement
