--- Lazy import into global space of all forma modules.
-- The more rigourous procedure of
--  local cell = require('libs.forma.cell')
-- is recommended.
return {
  cell          = require('libs.forma.cell'),
  pattern       = require('libs.forma.pattern'),
  primitives    = require('libs.forma.primitives'),
  subpattern    = require('libs.forma.subpattern'),
  automata      = require('libs.forma.automata'),
  neighbourhood = require('libs.forma.neighbourhood'),
}
