-- config: {}
local function renderHUD(c, config)
  c.show = {
    inventory = false
  }
  c.inventory = {
    dragging = { color = nil, from = {} },
    backpack = {
      {{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}},
      {{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}},
      {{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}},
      {{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}},
      {{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}},
      {{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}},
    },
    equipment = {
      {},{},{},{},{},{},
    }
  }
  
  c.inventory.backpack[1][1].color = {r = 1, g = 1, b = 1, a = 1}
  c.inventory.backpack[2][2].color = {r = 0.4, g = 1, b = 1, a = 1}
  c.inventory.backpack[5][7].color = {r = 1, g = 1, b = 1, a = 1}

  local windowW, windowH = love.graphics.getDimensions()
  local hudW, hudH = 325, 100
  local hudX, hudY = windowW / 2 - hudW / 2, windowH - hudH
  local skillW, skillH = 50, 50
  
  local invW, invH = 500, 275
  local invX, invY = windowW / 2 - invW / 2, windowH / 2 - invH / 2
  local slotW, slotH = 30, 30
  local rows, cols, equipment = 6, 8, 6

  local drawHandler = function()
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

      for col=1,cols do
        for row=1,rows do
          if c.inventory.backpack[row][col].color ~= nil then
            local color = c.inventory.backpack[row][col].color
            love.graphics.setColor(color.r, color.g, color.b, color.a)
          else
            love.graphics.setColor(0.6,0.6,0.6,1)
          end
          love.graphics.rectangle("fill", invX + 10 + (col - 1) * slotW * 1.5, invY + 10 + (row - 1) * slotH * 1.5, slotW, slotH)
        end
      end
      
      for slot =1,equipment do
        if c.inventory.equipment[slot].color then
          local color = c.inventory.equipment[slot].color
          love.graphics.setColor(color.r, color.g, color.b, color.a)
        else
          love.graphics.setColor(0.6,0.6,0.6,1)
        end
        love.graphics.rectangle("fill", invX + 10 + 405, invY + 10 + (slot - 1) * slotH * 1.5, slotW, slotH)
      end
    end
  end

  local inventoryToggleHandler = function()
    if c.show.inventory == true then
      c.show.inventory = false
    else
      c.show.inventory = true
    end
  end

  local function mouseOnInventorySlot(x, y)
    for col=1,cols do
      for row=1,rows do
        local slotX, slotY = invX + 10 + (col - 1) * slotW * 1.5, invY + 10 + (row - 1) * slotH * 1.5
        if x >= slotX and x <= slotX + slotW and y >= slotY and y <= slotY + slotH then
          return row,col
        end
      end
    end
  end

  local function mouseOnEquipmentSlot(x, y)
    for slot=1,equipment do
      local slotX, slotY = invX + 10 + 405, invY + 10 + (slot - 1) * slotH * 1.5
      if x >= slotX and x <= slotX + slotW and y >= slotY and y <= slotY + slotH then
        return slot
      end
    end
  end

  local mouse1PressedHandler = function(x, y)
    if c.show.inventory == false then
      return nil
    end
    local row,col = mouseOnInventorySlot(x, y)
    if row and col and c.inventory.backpack[row][col].color then
      c.inventory.dragging.color = c.inventory.backpack[row][col].color
      c.inventory.dragging.from.row = row
      c.inventory.dragging.from.col = col
      return nil
    end
    local equipementSlot = mouseOnEquipmentSlot(x, y)
    if equipementSlot and c.inventory.equipment[equipementSlot].color then
      c.inventory.dragging.color = c.inventory.equipment[equipementSlot].color
      c.inventory.dragging.from.slot = equipementSlot
      return nil
    end
  end

  local mouse1ReleaseHandler = function(x, y)
    if c.inventory.dragging.color then
      local row,col = mouseOnInventorySlot(x, y)
      local equipementSlot = mouseOnEquipmentSlot(x, y)
      if row and col then
        -- If destination empty
        if c.inventory.backpack[row][col].color == nil then
          c.inventory.backpack[row][col].color = c.inventory.dragging.color
          if c.inventory.dragging.from.row and c.inventory.dragging.from.col then
            c.inventory.backpack[c.inventory.dragging.from.row][c.inventory.dragging.from.col].color = nil
          else
            c.inventory.equipment[c.inventory.dragging.from.slot].color = nil
          end
        else
          -- Switch
          local temp = c.inventory.backpack[row][col].color
          if c.inventory.dragging.from.row and c.inventory.dragging.from.col then
            c.inventory.backpack[c.inventory.dragging.from.row][c.inventory.dragging.from.col].color = temp
          else
            c.inventory.equipment[c.inventory.dragging.from.slot].color = temp
          end
          c.inventory.backpack[row][col].color = c.inventory.dragging.color
        end
      else
        if equipementSlot then
          -- If destination empty
          if c.inventory.equipment[equipementSlot].color == nil then
            c.inventory.equipment[equipementSlot].color = c.inventory.dragging.color
            if c.inventory.dragging.from.row and c.inventory.dragging.from.col then
              c.inventory.backpack[c.inventory.dragging.from.row][c.inventory.dragging.from.col].color = nil
            else
              c.inventory.equipment[c.inventory.dragging.from.slot].color = nil
            end
          else
            -- Switch
            local temp = c.inventory.equipment[equipementSlot].color
            if c.inventory.dragging.from.row and c.inventory.dragging.from.col then
              c.inventory.backpack[c.inventory.dragging.from.row][c.inventory.dragging.from.col].color = temp
            else
              c.inventory.equipment[c.inventory.dragging.from.slot].color = temp
            end
            c.inventory.equipment[equipementSlot].color = c.inventory.dragging.color
          end
        end
      end
    end
    c.inventory.dragging.from = {}
    c.inventory.dragging.color = nil
  end

  c.eventEmitter:addDrawHandler(drawHandler, 1, true)
  c.input:addEventHandler("i", inventoryToggleHandler)
  c.input:addEventHandler("mouse1", mouse1PressedHandler)
  c.input:addEventHandler("mouse1", mouse1ReleaseHandler, true)
end

return renderHUD
