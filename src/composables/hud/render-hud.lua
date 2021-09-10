local inventory = require("src.composables.inventory.inventory")

-- config: {}
local function renderHUD(c, config)
  c.show = {
    inventory = false
  }
  c.dragging = { item = nil, from = {} }
  c.inventory = inventory.new(c)

  local windowW, windowH = love.graphics.getDimensions()
  local hudW, hudH = 325, 100
  local hudX, hudY = windowW / 2 - hudW / 2, windowH - hudH
  local skillW, skillH = 50, 50

  local invW, invH = 500, 275
  local invX, invY = windowW / 2 - invW / 2, windowH / 2 - invH / 2
  local slotW, slotH = 30, 30

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
    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.rectangle("fill", hudX, hudY, hudW, hudH)

    -- Skills
    love.graphics.setColor(0,0,1,1)
    love.graphics.rectangle("fill", hudX + skillW / 2, hudY + skillH / 2, skillW, skillH)
    love.graphics.rectangle("fill", hudX + skillW * 2, hudY + skillH / 2, skillW, skillH)
    love.graphics.rectangle("fill", hudX + skillW * 3.5, hudY + skillH / 2, skillW, skillH)
    love.graphics.rectangle("fill", hudX + skillW * 5, hudY + skillH / 2, skillW, skillH)
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("Q", hudX + skillW / 2, hudY + skillH / 2)
    love.graphics.print("W", hudX + skillW * 2, hudY + skillH / 2)
    love.graphics.print("E", hudX + skillW * 3.5, hudY + skillH / 2)
    love.graphics.print("R", hudX + skillW * 5, hudY + skillH / 2)
    -- Inventory
    if c.show.inventory then
      love.graphics.setColor(1, 1, 1, 0.8)
      love.graphics.rectangle("fill", invX, invY, invW, invH)

      for col=1,c.inventory.cols do
        for row=1,c.inventory.rows do
          if c.inventory.backpack[row][col].item ~= nil then
            local color = c.inventory.backpack[row][col].item.color
            love.graphics.setColor(color.r, color.g, color.b, color.a)
          else
            love.graphics.setColor(0.6,0.6,0.6,1)
          end
          love.graphics.rectangle("fill", invX + 10 + (col - 1) * slotW * 1.5, invY + 10 + (row - 1) * slotH * 1.5, slotW, slotH)
        end
      end

      for slot =1,c.inventory.gear do
        if c.inventory.equipment[slot].item then
          local color = c.inventory.equipment[slot].item.color
          love.graphics.setColor(color.r, color.g, color.b, color.a)
        else
          love.graphics.setColor(0.6,0.6,0.6,1)
        end
        love.graphics.rectangle("fill", invX + 10 + 405, invY + 10 + (slot - 1) * slotH * 1.5, slotW, slotH)
      end

      if c.dragging.item then
        local color = c.dragging.item.color
        love.graphics.setColor(color.r, color.g, color.b, color.a)
        local mouseX,mouseY = love.mouse.getPosition()
        love.graphics.rectangle("fill", mouseX, mouseY, slotW, slotH)
      end
    end
  end

  local inventoryToggleHandler = function()
    c.show.inventory = not c.show.inventory
  end

  local function mouseOnInventorySlot(x, y)
    for col=1,c.inventory.cols do
      for row=1,c.inventory.rows do
        local slotX, slotY = invX + 10 + (col - 1) * slotW * 1.5, invY + 10 + (row - 1) * slotH * 1.5
        if x >= slotX and x <= slotX + slotW and y >= slotY and y <= slotY + slotH then
          return row,col
        end
      end
    end
  end

  local function mouseOnEquipmentSlot(x, y)
    for slot=1,c.inventory.gear do
      local slotX, slotY = invX + 10 + 405, invY + 10 + (slot - 1) * slotH * 1.5
      if x >= slotX and x <= slotX + slotW and y >= slotY and y <= slotY + slotH then
        return slot
      end
    end
  end

  local mouse1PressedHandler = function(inputData)
    local x,y = inputData.mouse:unpack()
    if c.show.inventory == false then
      return nil
    end
    if not (x >= invX and x <= invX + invW and y >= invY and y <= invY + invH) then
      inventoryToggleHandler()
    end
    local row,col = mouseOnInventorySlot(x, y)
    if row and col and c.inventory.backpack[row][col].item then
      c.dragging.item = c.inventory.backpack[row][col].item
      c.dragging.from.row = row
      c.dragging.from.col = col
      return nil
    end
    local equipementSlot = mouseOnEquipmentSlot(x, y)
    if equipementSlot and c.inventory.equipment[equipementSlot].item then
      c.dragging.item = c.inventory.equipment[equipementSlot].item
      c.dragging.from.slot = equipementSlot
      return nil
    end
  end

  local mouse1ReleaseHandler = function(inputData)
    local x,y = inputData.mouse:unpack()
    if c.dragging.item then
      local row,col = mouseOnInventorySlot(x, y)
      if row and col then
        -- If destination empty
        if c.inventory.backpack[row][col].item == nil then
          c.inventory.backpack[row][col].item = c.dragging.item
          if c.dragging.from.row and c.dragging.from.col then
            c.inventory.backpack[c.dragging.from.row][c.dragging.from.col].item = nil
          else
            c.inventory.equipment[c.dragging.from.slot].item = nil
          end
        else
          -- Switch
          local temp = c.inventory.backpack[row][col].item
          if c.dragging.from.row and c.dragging.from.col then
            c.inventory.backpack[c.dragging.from.row][c.dragging.from.col].item = temp
          else
            c.inventory.equipment[c.dragging.from.slot].item = temp
          end
          c.inventory.backpack[row][col].item = c.dragging.item
        end
        c.inventory:parseEquipment()
      else
        local equipementSlot = mouseOnEquipmentSlot(x, y)
        if equipementSlot then
          -- If destination empty
          if c.inventory.equipment[equipementSlot].item == nil then
            c.inventory.equipment[equipementSlot].item = c.dragging.item
            if c.dragging.from.row and c.dragging.from.col then
              c.inventory.backpack[c.dragging.from.row][c.dragging.from.col].item = nil
            else
              c.inventory.equipment[c.dragging.from.slot].item = nil
            end
          else
            -- Switch
            local temp = c.inventory.equipment[equipementSlot].item
            if c.dragging.from.row and c.dragging.from.col then
              c.inventory.backpack[c.dragging.from.row][c.dragging.from.col].item = temp
            else
              c.inventory.equipment[c.dragging.from.slot].item = temp
            end
            c.inventory.equipment[equipementSlot].item = c.dragging.item
          end
        end
        c.inventory:parseEquipment()
      end
    end
    c.dragging.from = {}
    c.dragging.item = nil
  end

  c.eventEmitter:addDrawHandler("hud", drawHandler, 1, true)
  c.input:addEventHandler(c.id, "i", inventoryToggleHandler)
  c.input:addEventHandler(c.id, "mouse1", mouse1PressedHandler)
  c.input:addEventHandler(c.id, "mouse1", mouse1ReleaseHandler, true)
end

return renderHUD
