local addPlayerControl = require("src.composables.adders.add-player-control")
local addPlayerGuns = require("src.composables.adders.add-player-guns")
local addSprite = require("src.composables.adders.add-sprite")
local addCollision = require("src.composables.adders.add-collision")

local renderHUD = require("src.composables.hud.render-hud")

local function buildPlayer(c)
  addCollision(c, {
    x = 0,
    y = 0,
    h = 50,
    w = 30,
    shape = "rectangle",
    type = "dynamic",
    categories = {"player"},
    masks = {"playerProjectile"}
  })
  addSprite(c, {
    -- light = true,
    spriteName = "char",
    animation = "walk",
    newSprite = true,
    drawPosition = 6,
    h = 50,
    w = 30,
    color = {1, 0, 0.5, 1,}
  })
  -- TODO: Fix this \/ - Add possibility to run some input handler before others
  -- addPlayerControl needs to be before renderHUD, because then playerControl mouse event handler runs before renderHUDs
  -- and if user clicks outside inventory the player doesn't start instantly walking
  addPlayerControl(c)
  addPlayerGuns(c)
  renderHUD(c, {})
end

return buildPlayer
