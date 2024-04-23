local combat = Combat()

-- I don't know why, but this pattern almost reproduces
-- the desired effect area
local area = {
  { 0, 0, 0, 1, 0, 0, 0 },
  { 0, 0, 1, 1, 1, 0, 0 },
  { 0, 1, 1, 1, 1, 1, 0 },
  { 1, 1, 1, 1, 3, 1, 1 },
  { 0, 1, 1, 1, 1, 1, 0 },
  { 0, 0, 1, 1, 1, 0, 0 },
  { 0, 0, 0, 1, 0, 0, 0 },
}

local spellIntensity = 8

local maxDelay = 3000

-- For each tile in combat area, execute magic effect at random times
function onTargetTile(_, pos)
  addEvent(function(pos)
    pos:sendMagicEffect(CONST_ME_ICETORNADO, nil)
  end, math.random(0, maxDelay), pos)
end

combat:setArea(createCombatArea(area))
combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
  for _ = 1, spellIntensity do
    combat:execute(creature, variant)
  end
  return 0
end

-- Cast custom spell using words "frigo"
spell:name("Custom Eternal Winter")
spell:words("frigo")
spell:register()