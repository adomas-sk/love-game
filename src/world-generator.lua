local forma = require("libs.forma")

local Composable = require("src.composables.composable")
local addSprite = require("src.composables.adders.add-sprite")

local worldGenerator = {
  chunks = {},
  CHUNKX = 30,
  CHUNKY = 30,
  BLOCKX = 10,
  BLOCKY = 10,
  baseChunk = nil
}

function worldGenerator.init(initialSeed)
  if initialSeed == nil or initialSeed == "" then initialSeed = math.random(999999) end
  worldGenerator.seed = initialSeed
  love.math.setRandomSeed(initialSeed)

  worldGenerator.baseChunk = forma.primitives.square(worldGenerator.CHUNKX, worldGenerator.CHUNKY)
end

function worldGenerator:generateChunk(chunkX, chunkY)
  local chunkName = chunkX .. "-" .. chunkY
  print(chunkX * 1, chunkY * 1)
  local domain = forma.pattern.shift(
    self.baseChunk,
    chunkX * 1,
    chunkY * 1
  )
  local frequency, depth = 0.2, 1
  local thresholds = { 0, 0.455, 0.7 }
  local noise = forma.subpattern.perlin(domain, frequency, depth, thresholds, love.math.random)

  local result = {}
  for y=0,self.CHUNKY - 1 do
    result[y] = {}
  end

  local chars = {".", "|", "M"}
  -- forma.subpattern.print_patterns(domain, noise, chars)
  -- print("")
  for k,pattern in pairs(noise) do
    for x,y in pattern:cell_coordinates() do
      result[y][x] = chars[k]
    end
  end

  self.chunks[chunkName] = result
--  debugging
  local initial = forma.primitives.square(self.CHUNKX, self.CHUNKY)
  local domain = initial
  local frequency, depth = 0.2, 1
  local thresholds = { 0, 0.455, 0.7 }
  local noise = forma.subpattern.perlin(domain, frequency, depth, thresholds, love.math.random)
  forma.subpattern.print_patterns(domain, noise, chars)
  print("")
  local domain1 = forma.pattern.shift(
    initial,
    0, 0
  )
  local frequency1, depth1 = 0.2, 1
  local thresholds1 = { 0, 0.455, 0.7 }
  local noise1 = forma.subpattern.perlin(domain1, frequency1, depth1, thresholds1, love.math.random)
  forma.subpattern.print_patterns(domain1, noise1, chars)
end

function worldGenerator:callbackAllChunkCells(chunkX, chunkY, callback)
  local chunkName = chunkX .. "-" .. chunkY

  for y=0,#self.chunks[chunkName] do
    for x=0,#self.chunks[chunkName][y] do
      callback(x, y, self.chunks[chunkName][y][x])
    end
  end
end

function worldGenerator:renderChunk(chunkX, chunkY)
  local renderChunk = function(x, y, value)
    local block = Composable.new("block-" .. x .. ":" .. y .. "-" ..chunkX .. "-" .. chunkY)
    local color = {0.1, 0.1, 0.5, 1}
    if value == "|" then
      color = {0.5, 0.5, 0.1, 1}
    elseif value == "M" then
      color = {0.1, 0.5, 0.1, 1}
    end
    if x == 0 and y == 30 then
      color = {1,0,0, 1}
    end
    addSprite(block, {
      getPosition = function()
        return
          chunkX * self.BLOCKX * self.CHUNKX + x * self.BLOCKX + self.BLOCKX / 2,
          chunkY * self.BLOCKY * self.CHUNKY + y * self.BLOCKY + self.BLOCKY / 2
      end,
      drawPosition = 2,
      shape = "rectangle",
      w = self.BLOCKX,
      h = self.BLOCKY,
      color = color,
    })
  end
  worldGenerator:callbackAllChunkCells(chunkX, chunkY, renderChunk)
end

return worldGenerator
