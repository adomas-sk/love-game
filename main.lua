local camera = require("libs.camera")

local Composable = require("src.composables.composable")
local InputManagement = require("src.composables.input-management")
local EE = require("src.composables.event-emitter")

local renderHUD = require("src.composables.hud.render-hud")

local addPlayerControl = require("src.composables.adders.add-player-control")
local addSprite = require("src.composables.adders.add-sprite")
local addCollision = require("src.composables.adders.add-collision")
local addActiveSkill = require("src.composables.adders.add-active-skill")

local createBasicProjectileSkill = require("src.composables.skills.basic-projectile")
local createCollisionHandler = require("src.composables.collision-handler")

function love.load()
  Input = InputManagement.new()
  World = love.physics.newWorld(0, 0, true)
  EventEmitter = EE.new()
  Camera = camera.new(0,0)
  createCollisionHandler(World, EventEmitter)
  Composable.init({
    world = World,
    input = Input,
    camera = Camera,
    eventEmitter = EventEmitter,
  })

  local static = Composable.new("static")
  addCollision(static, {
    x = 400,
    y = 400,
    w = 200,
    h = 50,
    type = "static",
    shape = "rectangle",
  })
  addSprite(static, {
    drawPosition = 3,
    w = 200,
    h = 50,
    color = {0, 1, 0.5, 1,}
  })

  Player = Composable.new("player")
  addCollision(Player, {
    x = 400,
    y = 200,
    radius = 50,
    shape = "circle",
    type = "dynamic",
    
  })
  addSprite(Player, {
    drawPosition = 6,
    radius = 50,
    color = {1, 0, 0.5, 1,}
  })
  -- renderHUD needs to be before addPlayerControl, because then playerControl mouse event handler runs before renderHUDs
  -- and if user clicks outside inventory the player doesn't start instantly walking
  renderHUD(Player, {})
  addPlayerControl(Player)
  addActiveSkill(Player, "q", createBasicProjectileSkill())
end

function love.update(dt)
  World:update(dt)
  EventEmitter:emit("update")
  Camera:lookAt(Player.body:getPosition())
end

function love.draw()
  Camera:attach()
  EventEmitter:emitDraw()
  Camera:detach()
  EventEmitter:emitDraw(true)
end

function love.mousepressed(x, y, button)
  Input:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
  Input:mouserelease(x, y, button)
end

function love.keypressed(key)
  Input:keypressed(key)
end

function love.keyreleased(key)
  Input:keyrelease(key)
end
