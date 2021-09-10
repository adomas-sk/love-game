-- config = {
--   left = number,
--   right = number,
--   top = number,
--   bottom = number,
--   callback = function(),
-- }
local function addClickHandler(c, config)
  assert(config.callback ~= nil, "addClickHandler: callback is nil")

  local mouse1Handler = function(inputData)
    local x,y = inputData.destination:unpack()
    if x >= config.left and x <= config.right and y <= config.bottom and y >= config.top then
      config.callback()
    end
  end

  c.input:addEventHandler(c.id, "mouse1", mouse1Handler)
end

return addClickHandler
