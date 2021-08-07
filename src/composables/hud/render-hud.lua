-- config: {}
local function renderHUD(c, config)
  c.show = {
    inventory = false
  }
  c.inventory = {
    grid = {
      {{}, {}, {}, {}},
      {{}, {}, {}, {}},
      {{}, {}, {}, {}},
      {{}, {}, {}, {}},
      {{}, {}, {}, {}},
    }
  }
  local drawHandler = function()
    local windowW, windowH = love.graphics.getDimensions()
    local cameraX, cameraY = c.camera:position()
    local hudW, hudH = 325, 100
    local hudX, hudY = cameraX - hudW / 2, cameraY - hudH + windowH / 2
  
    -- Container
    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.rectangle("fill", hudX, hudY, hudW, hudH)
  
    -- Slots
    local slotW, slotH = 50, 50
    love.graphics.setColor(0,0,1,1)
    love.graphics.rectangle("fill", hudX + slotW / 2, hudY + slotH / 2, slotW, slotH)
    love.graphics.rectangle("fill", hudX + slotW * 2, hudY + slotH / 2, slotW, slotH)
    love.graphics.rectangle("fill", hudX + slotW * 3.5, hudY + slotH / 2, slotW, slotH)
    love.graphics.rectangle("fill", hudX + slotW * 5, hudY + slotH / 2, slotW, slotH)
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("Q", hudX + slotW / 2, hudY + slotH / 2)
    love.graphics.print("W", hudX + slotW * 2, hudY + slotH / 2)
    love.graphics.print("E", hudX + slotW * 3.5, hudY + slotH / 2)
    love.graphics.print("R", hudX + slotW * 5, hudY + slotH / 2)

    if c.show.inventory then
      local invW, invH = 500, 300
      local invX, invY = cameraX - invW / 2, cameraY - invH / 2
      love.graphics.setColor(1, 1, 1, 0.8)
      love.graphics.rectangle("fill", invX, invY, invW, invH)
    end
  end
  
  local inventoryToggleHandler = function ()
    if c.show.inventory == true then
      c.show.inventory = false
    else
      c.show.inventory = true
    end
  end

  c.eventEmitter:addDrawHandler(drawHandler, 8)
  c.input:addEventHandler("i", inventoryToggleHandler)
end

return renderHUD
