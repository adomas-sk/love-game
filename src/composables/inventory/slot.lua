local slot = {
  SLOT_TYPES = {
    backpack = "backpack",
    armour = "armour",
    weapon = "weapon",
    skillDisabled = "skillDisabled",
    skillEnabled = "skillEnabled",
  },
  SLOT_COLORS = {
    backpack = {0.69,0.69,0.69,0.9},
    armour = {0.756,0.525,0.172,1},
    weapon = {0.831,0.325,0.290,1},
    skillDisabled = {0.517,0.643,0.713,1},
    skillEnabled = {0.309,0.627,0.803,1},
  },
  SLOTS = {},
}
slot.__index = slot

function slot.init(inventory)
  slot.inventory = inventory
end

function slot.new(x, y, h, w, type)
  local slt = {}
  slt.x = x
  slt.y = y
  slt.h = h
  slt.w = w
  slt.type = type
  setmetatable(slt, slot)
  table.insert(slot.SLOTS, slt)
  return slt
end

function slot:render()
  if self.item and self.item.color then
    love.graphics.setColor(self.item.color)
  else
    love.graphics.setColor(slot.SLOT_COLORS[self.type])
  end
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function slot.switchSlots(slot1, slot2)
  local index1 = nil
  local index2 = nil
  for k,v in ipairs(slot.SLOTS) do
    if v == slot1 then
      index1 = k
    elseif v == slot2 then
      index2 = k
    end
  end

  assert(index1 ~= nil, "index1 equal nil")
  assert(index2 ~= nil, "index2 equal nil")
  local temp = slot.SLOTS[index1].item
  slot.SLOTS[index1].item = slot.SLOTS[index2].item
  slot.SLOTS[index2].item = temp

  if
    slot.SLOTS[index1].type == slot.SLOT_TYPES.weapon or
    slot.SLOTS[index2].type == slot.SLOT_TYPES.weapon then
      slot.inventory:parseEquipment()
  end
end

function slot.isOnSlot(x, y)
  for _k,v in ipairs(slot.SLOTS) do
    if x >= v.x and x <= v.x + v.w and y >= v.y and y <= v.y + v.h then
      return v
    end
  end
end

function slot.renderAll()
  for _k,v in ipairs(slot.SLOTS) do
    slot.render(v)
  end
end

return slot
