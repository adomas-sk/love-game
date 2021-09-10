local addActiveSkill = require("src.composables.adders.add-active-skill")

local inventory = {}
inventory.__index = inventory

function inventory.new(c)
  local inv = {}
  setmetatable(inv, inventory)

  inv.backpack = {}
  inv.equipment = {}
  inv.rows = 6
  inv.cols = 8
  inv.gear = 6
  inv.c = c

  for row=1,inv.rows do
    inv.backpack[row] = {}
    for col=1,inv.cols do
      inv.backpack[row][col] = {}
    end
  end
  for slot=1,inv.gear do
    inv.equipment[slot] = {}
  end

  inv.backpack[1][1].item = {color = {r = 1, g = 1, b = 1, a = 1}}
  inv.backpack[2][2].item = {color = {r = 0.4, g = 1, b = 1, a = 1}}
  inv.backpack[5][7].item = {color = {r = 1, g = 1, b = 1, a = 1}}

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
  for slot=1,self.gear do
    if self.equipment[slot].item and self.equipment[slot].item.skill then
      addActiveSkill(self.c,
        "q",
        self.equipment[slot].item.skill(
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
end

return inventory
