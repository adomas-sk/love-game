local camera = require("libs.camera")
local lightWorld = require("libs.light-world")

local Composable = require("src.composables.composable")
local InputManagement = require("src.composables.input-management")
local EE = require("src.composables.event-emitter")
local worldGenerator = require("src.world-generator")

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
  local screenW, screenH = dispW - 600, dispH-53-200
  love.window.setMode(screenW, screenH)
  -- worldGenerator.init(0)
  -- worldGenerator:generateChunk(0, 0)
  -- worldGenerator:generateChunk(-1, 0)
  -- worldGenerator:generateChunk(0, -1)
  Input = InputManagement.new()
  Input:addEventHandler("esc", "escape", function() love.event.quit(0) end)
  World = love.physics.newWorld(0, 0, true)
  EventEmitter = EE.new()
  Camera = camera.new(0, 0)
  createCollisionHandler(World, EventEmitter)
  LightWorld = lightWorld({
    ambient = {55,55,55},
    refractionStrength = 32.0,
    reflectionVisibility = 0.75,
    shadowBlur = 0.0
  })
  LightWorld:refreshScreenSize(screenW, screenH)
  Composable.init({
    world = World,
    input = Input,
    camera = Camera,
    eventEmitter = EventEmitter,
    lightWorld = LightWorld,
  })

  local light = Composable.new("light")
  addSprite(light, {
    getPosition= function() return 100,100 end,
    light = true,
  })

  Player = Composable.new("player")
  addCollision(Player, {
    x = 100,
    y = 100,
    h = 50,
    w = 30,
    shape = "rectangle",
    type = "dynamic",
    categories = {"player"},
    masks = {"playerProjectile"}
  })
  addSprite(Player, {
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
  addPlayerControl(Player)
  addPlayerGuns(Player)
  renderHUD(Player, {})

  local debug = Composable.new("debug")
  addSprite(debug, {
    getPosition = function()
      return 0 , 0
    end,
    drawPosition = 1,
    shape = "rectangle",
    w = 1000,
    h = 1000,
    color = {0.2, 0.2, 0.2},
  })
  local debug = Composable.new("debug2")
  addSprite(debug, {
    getPosition = function()
      return 0, 0
    end,
    drawPosition = 6,
    shape = "circle",
    radius = 2,
    color = {1, 1, 1,1},
  })

  -- worldGenerator:renderChunk(0, 0)
  -- worldGenerator:renderChunk(-1, 0)
  -- worldGenerator:renderChunk(-1, -1)
  -- worldGenerator:renderChunk(0, -1)

  -- buildRobot({
  --   initialCoords = {300, 30}
  -- })
  -- buildRobot({
  --   initialCoords = {400, 400}
  -- })
  -- buildBuilding({
  --   initialCoords = {200, 10}
  -- })
  -- buildBuilding({
  --   initialCoords = {450, 400}
  -- })
  -- buildEnemy({
  --   initialCoords = {100,100}
  -- })

  -- buildDroppedItem({
  --   x = 500,
  --   y = 450,
  --   text = "SUPER MEGA ITEM",
  -- })
end

function love.update(dt)
  World:update(dt)
  EventEmitter:emit("update", dt)
  local x,y = Player.body:getPosition()
  local centerX,centerY = (love.graphics.getWidth() / 2) - x, (love.graphics.getHeight() / 2) - y
  Camera:lookAt(x,y)
  LightWorld:update(dt)
  LightWorld:setTranslation(centerX,centerY, 1)
end

function love.draw()
  Camera:attach()
  LightWorld:draw(function()
    EventEmitter:emitDraw()
  end)
  Camera:detach()
  EventEmitter:emitDraw(true)
end
