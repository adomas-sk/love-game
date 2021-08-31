local camera = require("libs.camera")

local Composable = require("src.composables.composable")
local InputManagement = require("src.composables.input-management")
local EE = require("src.composables.event-emitter")

local renderHUD = require("src.composables.hud.render-hud")

local addPlayerControl = require("src.composables.adders.add-player-control")
local addSprite = require("src.composables.adders.add-sprite")
local addCollision = require("src.composables.adders.add-collision")
local addActiveSkill = require("src.composables.adders.add-active-skill")
local addGetInProximityBehaviour = require("src.composables.adders.add-get-in-proximity-behaviour")
local addHostileBehaviour = require("src.composables.adders.add-hostile-behaviour")
local addHealth = require("src.composables.adders.add-health")

local createBasicProjectileSkill = require("src.composables.skills.basic-projectile")
local createCollisionHandler = require("src.composables.collision-handler")

local buildGrid = require("src.composables.builders.grid")

function love.load()
  local dispW, dispH = love.window.getDesktopDimensions()
  love.window.setMode(dispW - 600, dispH-53-200)
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

  buildGrid()

  Player = Composable.new("player")
  addCollision(Player, {
    x = 400,
    y = 200,
    radius = 50,
    shape = "circle",
    type = "dynamic",
  })
  addSprite(Player, {
    -- spriteName = "walk",
    -- animation = "walk"
    drawPosition = 6,
    radius = 50,
    color = {1, 0, 0.5, 1,}
  })
  -- renderHUD needs to be before addPlayerControl, because then playerControl mouse event handler runs before renderHUDs
  -- and if user clicks outside inventory the player doesn't start instantly walking
  renderHUD(Player, {})
  addPlayerControl(Player)
  addActiveSkill(Player,
    "q",
    createBasicProjectileSkill({ from = "player", damage = 1 })
  )

  local baddie = Composable.new("baddie")
  addCollision(baddie, {
    x = 100,
    y = 100,
    radius = 20,
    shape = "circle",
    type = "dynamic",
    fixtureData = {
      dmgBy = "player"
    }
  })
  addSprite(baddie, {
    drawPosition = 6,
    radius = 20,
    color = {1, 0, 0, 1,}
  })
  addGetInProximityBehaviour(baddie, {
    speed = 50,
    minDistance = 150,
    maxDistance = 300
  })
  addHostileBehaviour(baddie, {
    target = "player",
    minDistance = 150,
    skill = createBasicProjectileSkill({ from = "baddie", damage = 1 })
  })
  addHealth(baddie, {
    max = 10,
    initial = 10
  })
end

function love.update(dt)
  World:update(dt)
  EventEmitter:emit("update", dt)
  Camera:lookAt(Player.body:getPosition())
end

function love.draw()
  Camera:attach()
  EventEmitter:emitDraw()
  Camera:detach()
  EventEmitter:emitDraw(true)
end

function love.mousepressed(x, y, button)
  Input:mousepressed(button)
end

function love.mousereleased(x, y, button)
  Input:mouserelease(button)
end

function love.keypressed(key)
  Input:keypressed(key)
end

function love.keyreleased(key)
  Input:keyrelease(key)
end
