local UnitGUID, CombatLogGetCurrentEventInfo, format =
      UnitGUID, CombatLogGetCurrentEventInfo, format


local spellSchools = {
  [1] = "Physical", [2] = "Holy", [3] = "Holy/Physical", [4] = "Fire",
  [5] = "Fire/Physical", [6] = "Fire/Holy", [8] = "Nature", [9] = "Nature/Physical",
  [10] = "Nature/Holy", [12] = "Nature/Fire", [16] = "Frost", [17] = "Frost/Physical",
  [18] = "Frost/Holy", [20] = "Frost/Fire", [24] = "Frost/Nature", [28] = "Elemental", [32] = "Shadow",
  [33] = "Shadow/Physical", [34] = "Shadow/Holy", [36] = "Shadow/Fire", [40] = "Shadow/Nature",
  [48] = "Shadow/Frost", [64] = "Arcane", [65] = "Arcane/Physical", [66] = "Arcane/Holy",
  [68] = "Arcane/Fire", [72] = "Arcane/Nature", [80] = "Arcane/Frost", [96] = "Arcane/Shadow",
  [124] = "Chaos (All Schools)", [126] = "Magic (All Schools)", [127] = "Chaos (All Schools)"
}


local spellSchoolColors = {
  [1] = "FFFFFF00", [2] = "FFFFE680",
  [4] = "FFFF8000", [8] = "FF4DFF4D",
  [16] = "FF80FFFF", [32] = "FF8080FF",
  [64] = "FFFF80FF"
}


local msgTypePrefixes = {
  ["SPELL_INTERRUPT"] = "Interrupted",
  ["SPELL_DISPEL"] = "Dispelled",
  ["SPELL_STOLEN"] = "Stole",
}


function Interrupts:LogEvent(event, destName, spellSchool, spellName)
  local msgPrefix, msgString = msgTypePrefixes[event], nil
  local school, schoolColor = spellSchools[spellSchool], spellSchoolColors[spellSchool]
  if ( school and schoolColor ) then
    msgString = format("%s %s's %s (|c%s%s|r)", msgPrefix, destName, spellName, schoolColor, school)
  else
    msgString = format("%s %s's %s", msgPrefix, destName, spellName)
  end
  self.InterruptMsgFrame:AddMessage(msgString)
end


function Interrupts:COMBAT_LOG_EVENT_UNFILTERED()
  local _, event, _, sourceGUID, _, _, _, _, destName, _, _, _, _, _, _, extraSpellName, extraSpellSchool = CombatLogGetCurrentEventInfo()
  if ( sourceGUID ~= self.playerGUID or not msgTypePrefixes[event] ) then
    return
  end
  self:LogEvent(event, destName, extraSpellSchool, extraSpellName)
end


function Interrupts:PLAYER_LOGIN()
  self.playerGUID = UnitGUID("player")
end
