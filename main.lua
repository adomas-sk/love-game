local camera = require("libs.camera")

local Composable = require("src.composables.composable")
local InputManagement = require("src.composables.input-management")
local EE = require("src.composables.event-emitter")

local renderHUD = require("src.composables.hud.render-hud")

local addPlayerControl = require("src.composables.adders.add-player-control")
local addPlayerGuns = require("src.composables.adders.add-player-guns")
local addSprite = require("src.composables.adders.add-sprite")
local addCollision = require("src.composables.adders.add-collision")

local createCollisionHandler = require("src.composables.collision-handler")

local buildGrid = require("src.composables.builders.grid")
local buildEnemy = require("src.composables.builders.enemy")
local buildRobot = require("src.composables.builders.robot")
local buildBuilding = require("src.composables.builders.building")
local buildDroppedItem = require("src.composables.builders.dropped-item")

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

function love.load()
  local dispW, dispH = love.window.getDesktopDimensions()
  love.window.setMode(dispW - 600, dispH-53-200)
  Input = InputManagement.new()
  Input:addEventHandler("esc", "escape", function() love.event.quit(0) end)
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
    categories = {"player"},
    masks = {"playerProjectile"}
  })
  addSprite(Player, {
    -- spriteName = "walk",
    -- animation = "walk"
    drawPosition = 6,
    radius = 50,
    color = {1, 0, 0.5, 1,}
  })
  -- TODO: Fix this \/ - Add possibility to run some input handler before others
  -- addPlayerControl needs to be before renderHUD, because then playerControl mouse event handler runs before renderHUDs
  -- and if user clicks outside inventory the player doesn't start instantly walking
  addPlayerControl(Player)
  addPlayerGuns(Player)
  renderHUD(Player, {})

  buildRobot({
    initialCoords = {30, 30}
  })
  buildRobot({
    initialCoords = {400, 400}
  })
  buildBuilding({
    initialCoords = {10, 10}
  })
  buildBuilding({
    initialCoords = {450, 400}
  })
  buildEnemy({
    initialCoords = {100,100}
  })

  buildDroppedItem({
    x = 500,
    y = 450,
    text = "SUPER MEGA ITEM",
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
