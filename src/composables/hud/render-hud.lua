local inventory = require("src.composables.inventory.inventory")
local slot = require("src.composables.inventory.slot")

-- config: {}
local function renderHUD(c, config)
  c.show = {
    inventory = false
  }
  c.dragging = nil

  local windowW, windowH = love.graphics.getDimensions()
  -- local hudW, hudH = 325, 100
  -- local hudX, hudY = windowW / 2 - hudW / 2, windowH - hudH
  -- local skillW, skillH = 50, 50

  local invW, invH = 430, 275
  local skillsW,skillsH = 225,275
  local invX, invY = windowW / 2 - invW / 2 - skillsW / 2, windowH / 2 - invH / 2
  local slotW, slotH = 30, 30
  c.inventory = inventory.new(c, {
    x = invX,
    y = invY,
    w = invW,
    h = invH,
  })

  local drawHandler = function()
    love.graphics.setColor(0,0,0,0.8)
    love.graphics.rectangle("fill",0,0,18,15)
    local fps = love.timer.getFPS()
    if fps < 50 then
      love.graphics.setColor(1,0.3,0.3,1)
    else
      love.graphics.setColor(1,1,1,1)
    end
    love.graphics.print(love.timer.getFPS())
    -- Container
    -- love.graphics.setColor(1, 1, 1, 0.8)
    -- love.graphics.rectangle("fill", hudX, hudY, hudW, hudH)

    -- -- Skills
    -- love.graphics.setColor(0.3,0.3,1,1)
    -- love.graphics.rectangle("fill", hudX + skillW / 2, hudY + skillH / 2, skillW, skillH)
    -- love.graphics.rectangle("fill", hudX + skillW * 2, hudY + skillH / 2, skillW, skillH)
    -- love.graphics.rectangle("fill", hudX + skillW * 3.5, hudY + skillH / 2, skillW, skillH)
    -- love.graphics.rectangle("fill", hudX + skillW * 5, hudY + skillH / 2, skillW, skillH)
    -- love.graphics.setColor(1,1,1,1)
    -- love.graphics.print("Q", hudX + skillW / 2, hudY + skillH / 2)
    -- love.graphics.print("W", hudX + skillW * 2, hudY + skillH / 2)
    -- love.graphics.print("E", hudX + skillW * 3.5, hudY + skillH / 2)
    -- love.graphics.print("R", hudX + skillW * 5, hudY + skillH / 2)

    -- Inventory
    if c.show.inventory then
      love.graphics.setColor(0.882,0.882,0.882,0.9)
      love.graphics.rectangle("fill", invX, invY, invW, invH)
      love.graphics.setColor(0.64,0.64,0.64,0.9)
      love.graphics.rectangle("fill", invX + invW, invY, skillsW, skillsH)

      slot.renderAll()
      if c.dragging then
        local color = c.dragging.item.color
        love.graphics.setColor(unpack(color))
        local mouseX,mouseY = love.mouse.getPosition()
        love.graphics.rectangle("fill", mouseX, mouseY, slotW, slotH)
      end
    end
  end

  local inventoryToggleHandler = function()
    c.show.inventory = not c.show.inventory
  end

  local mouse1PressedHandler = function(inputData)
    if c.show.inventory == false then
      return nil
    end
    local x,y = inputData.mouse:unpack()
    if not (x >= invX and x <= invX + invW + skillsW and y >= invY and y <= invY + invH) then
      inventoryToggleHandler()
    end
    local pressedSlot = slot.isOnSlot(x,y)
    if pressedSlot.type == slot.SLOT_TYPES.backpack then
      c.dragging = pressedSlot
    end
  end

  local mouse1ReleaseHandler = function(inputData)
    local x,y = inputData.mouse:unpack()
    if c.dragging then
      local pressedSlot = slot.isOnSlot(x,y)
      if pressedSlot.type == slot.SLOT_TYPES.backpack then
        slot.switchSlots(pressedSlot, c.dragging)
      end
    end
    c.dragging = nil
  end

  c.eventEmitter:addDrawHandler("hud", drawHandler, 1, true)
  c.input:addEventHandler(c.id, "i", inventoryToggleHandler)
  c.input:addEventHandler(c.id, "mouse1", mouse1PressedHandler)
  c.input:addEventHandler(c.id, "mouse1", mouse1ReleaseHandler, true)
end

return renderHUD
