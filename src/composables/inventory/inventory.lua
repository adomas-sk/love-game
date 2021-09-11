local addActiveSkill = require("src.composables.adders.add-active-skill")
local slot = require("src.composables.inventory.slot")

local inventory = {}
inventory.__index = inventory
-- container = {
--   x = number,
--   y = number,
--   h = number,
--   w = number,
-- }
function inventory.new(c, container)
  local inv = {}
  setmetatable(inv, inventory)

  inv.backpack = {}
  inv.weapons = {}
  inv.equipment = {}
  inv.skills = {}
  inv.rows = 6
  inv.cols = 8
  inv.gear = 6
  inv.skillCount = 4
  inv.currentWeapon = 1
  inv.c = c

  slot.init(inv)

  local slotW,slotH = 30,30
  for row=1,inv.rows do
    inv.backpack[row] = {}
    for col=1,inv.cols do
      inv.backpack[row][col] = slot.new(
        container.x + 10 + (col - 1) * slotW * 1.5,
        container.y + 10 + (row - 1) * slotH * 1.5,
        slotH,
        slotW,
        slot.SLOT_TYPES.backpack
      )
    end
  end
  local armourOffset = 385
  for slotIndex=1,inv.gear do
    inv.equipment[slotIndex] = slot.new(
      container.x + armourOffset,
      container.y + 10 + (slotIndex - 1) * slotH * 1.5,
      slotW,
      slotH,
      slot.SLOT_TYPES.armour
    )
  end
  local skillsOffset = 65
  for slotIndex=1,inv.gear do
    inv.weapons[slotIndex] = slot.new(
      container.x + container.w + 15,
      container.y + 10 + (slotIndex - 1) * slotH * 1.5,
      slotW,
      slotH,
      slot.SLOT_TYPES.weapon
    )
    inv.skills[slotIndex] = {}
    for skill=1,inv.skillCount do
      inv.skills[slotIndex][skill] = slot.new(
        container.x + container.w + skillsOffset + (skill - 1) * slotW * 1.33333,
        container.y + 10 + (slotIndex - 1) * slotH * 1.5,
        slotW,
        slotH,
        slot.SLOT_TYPES.skillDisabled
      )
    end
  end

  inv.backpack[1][1].item = {color = {1,1,1,1}}
  inv.backpack[2][2].item = {color = {0.4,1,1,1}}
  inv.backpack[5][7].item = {color = {1,0.5,1,1}}

  return inv
end

function inventory:addToFirst(item)
  for col=1,self.cols do
    for row=1,self.rows do
      if self.backpack[row][col].item == nil then
        self.backpack[row][col].item = item
        return true
      end
    end
  end
  return false
end

function inventory:parseEquipment()
  -- TODO: Make this less stupid
  self.c.input:removeEventHandlerForKey("q")
  self.c.input:removeEventHandlerForKey("w")
  self.c.input:removeEventHandlerForKey("e")
  self.c.input:removeEventHandlerForKey("r")

  for slotIndex=1,self.gear do
    local skillsType = slot.SLOT_TYPES.skillDisabled
    if self.weapons[slotIndex].item then
      skillsType = slot.SLOT_TYPES.skillEnabled
      if self.weapons[slotIndex].item.skill then
        addActiveSkill(self.c,
          "q",
          self.weapons[slotIndex].item.skill(
            {
              from = "player",
              damage = 1,
              masks = { "player", "playerProjectile" },
              categories = { "playerProjectile" }
            }
          )
        )
      end
    end
    for skill=1,self.skillCount do
      self.skills[slotIndex][skill].type = skillsType
    end
  end
end

return inventory
