local inputManagement = {}
inputManagement.__index = inputManagement

local mouseNames = {
  [1] = "mouse1",
  [2] = "mouse2",
  [3] = "mouse3"
}

function inputManagement.new()
  -- local input = {
  --   q = 0,
  --   w = 0,
  --   e = 0,
  --   r = 0,
  --   i = 0,
  -- }
  -- local function pressedHandler(key)
  --   return function()
  --     if input[key] == false then
  --       input.w = true
  --     end
  --   end
  -- end
  -- local function releaseHandler(key)
  --   return function()
  --     if input[key] then
  --       input.w = false
  --     end
  --   end
  -- end
  local function createHandlers(key)
    -- return {
    --   pressed = { pressedHandler(key) },
    --   release = { releaseHandler(key) }
    -- }
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
    [mouseNames[1]] = createHandlers(mouseNames[1]),
    [mouseNames[2]] = createHandlers(mouseNames[2]),
    [mouseNames[3]] = createHandlers(mouseNames[3]),
  }

  -- inputManagement.input = input
  inputManagement.events = events
  return inputManagement
end

function inputManagement:addEventHandler(id, event, handler, release)
  if self.events[event] then
    if release then
      table.insert(self.events[event].release, 1, { id = id, handler = handler })
    else
      table.insert(self.events[event].pressed, 1, { id = id, handler = handler })
    end
  else
    error("inputManagement: tried to add event: " .. event .." , which doesn't exist")
  end
end

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

function inputManagement:keypressed(key, x, y)
  if self.events[key] then
    for _i, value in pairs(self.events[key].pressed) do
      value.handler(x, y)
    end
  end
end

function inputManagement:keyrelease(key, x, y)
  if self.events[key] then
    for _i, value in pairs(self.events[key].release) do
      value.handler(x, y)
    end
  end
end

function inputManagement:mousepressed(x, y, button)
  self:keypressed(mouseNames[button], x, y)
end

function inputManagement:mouserelease(x, y, button)
  self:keyrelease(mouseNames[button], x, y)
end

return inputManagement
