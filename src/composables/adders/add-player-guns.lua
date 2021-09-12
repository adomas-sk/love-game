local vector = require("libs.vector")

local createBasicProjectileSkill = require("src.composables.skills.basic-projectile")

local PLAYER_GUNS = {
  MELEE = "MELEE",
  FIREARM = "FIREARM",
  LAZER = "LAZER",
  EXPLOSIVES = "EXPLOSIVES",
}
local function addPlayerGuns(c)
  c.playerGuns = {
    currentGun = PLAYER_GUNS.MELEE,
    cooldowns = {
      [PLAYER_GUNS.MELEE] = 0,
      [PLAYER_GUNS.FIREARM] = 0,
      [PLAYER_GUNS.LAZER] = 0,
      [PLAYER_GUNS.EXPLOSIVES] = 0,
    }
  }

  local projectile = createBasicProjectileSkill({
    from = "player",
    damage = 1,
    masks = { "player", "playerProjectile" },
    categories = { "playerProjectile" }
  })
  local fireHandler = function(inputData)
    if
      c.playerGuns.currentGun == PLAYER_GUNS.FIREARM and
      c.playerGuns.cooldowns[c.playerGuns.currentGun] <= 0 then
        projectile.createCastHandler({
          getSource = function() return vector(c.body:getPosition()) end,
          offset = 50,
          maxLifeSpan = 2,
          lifeCycle = {}
        })(inputData)
    end
  end
  local updateHandler = function(dt)
    for k,v in pairs(c.playerGuns.cooldowns) do
      if c.playerGuns.cooldowns[k] > 0 then
        c.playerGuns.cooldowns[k] = v - dt
      end
    end
  end
  local chooseMeleeHandler = function()
    c.playerGuns.currentGun = PLAYER_GUNS.MELEE
  end
  local chooseFirearmHandler = function()
    c.playerGuns.currentGun = PLAYER_GUNS.FIREARM
  end
  local chooseLazerHandler = function()
    c.playerGuns.currentGun = PLAYER_GUNS.LAZER
  end
  local chooseExplosivesHandler = function()
    c.playerGuns.currentGun = PLAYER_GUNS.EXPLOSIVES
  end

  c.input:addEventHandler(c.id, "mouse1", fireHandler)
  c.input:addEventHandler(c.id, "1", chooseMeleeHandler)
  c.input:addEventHandler(c.id, "2", chooseFirearmHandler)
  c.input:addEventHandler(c.id, "3", chooseLazerHandler)
  c.input:addEventHandler(c.id, "4", chooseExplosivesHandler)
  c:addEventHandler("update", updateHandler)
end

return addPlayerGuns
