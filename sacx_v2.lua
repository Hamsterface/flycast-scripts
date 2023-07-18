-------------------------
-- EMU-CXv2 Lua Script --
--  Script By HamStar  --
--  Original codes by  --
--  Speeps and SQeefy  --
-------------------------
-- Installation:
-- Place in flycast's config folder
-- In advanced settings, set Lua Filename to this file
-- Bind the "C" button on player 1 to access the menu
-------------------------
-- Works on all major versions except Limited Edition
-- Version is selected automatically
-------------------------

-- Update version number any time this script is modified
CX_VERSION_NUMBER = "2.0"

addr = {
  ["HDR-0001  V1.007"] = {
    name = "JP 1.0",
    
    buttons = 0x8C75D9A4,
    
    action = 0x8C751F14,
    normalAction = 0xE,
    cxFlag2 = 0x8C75DA20,
    cxFlag3 = 0x8C75DA18,
    
    lives = 0x8C75B744,
    level = 0x8C1B52D4
  },
  ["MK-51000  V1.005"] = {
    name = "US 1.1",
    
    buttons = 0x8C754E4C,
    
    action = 0x8C7493B4,
    normalAction = 0xF,
    cxFlag2 = 0x8C754EC4,
    cxFlag3 = 0x8C754EBC,
    
    lives = 0x8C752BE0,
    level = 0x8C19E970
  },
  ["MK-51000  V1.004"] = {
    name = "US 1.0",
    
    buttons = 0x8C758ECC,
    
    action = 0x8C74D434,
    normalAction = 0xF,
    cxFlag2 = 0x8C758F44,
    cxFlag3 = 0x8C758F3C,
    
    lives = 0x8C756C60,
    level = 0x8C1A26A8
  },
  ["HDR-0043  V1.003"] = {
    name = "JP International",
    
    buttons = 0x8C7567CC,
    
    action = 0x8C74AD34,
    normalAction = 0xF,
    cxFlag2 = 0x8C756844,
    cxFlag3 = 0x8C75683C,
    
    lives = 0x8C754560,
    level = 0x8C19ED50
  },
  ["MK-5100050V1.003"] = {
    name = "PAL",
    
    buttons = 0x8C754D8C,
    
    action = 0x8C7492F4,
    normalAction = 0xF,
    cxFlag2 = 0x8C754E04,
    cxFlag3 = 0x8C754DFC,
    
    lives = 0x8C752B20,
    level = 0x8C19E8B0
  },
}

function cbStart()
  flycast.emulator.displayNotification("EMU-CX v"..CX_VERSION_NUMBER.." loaded. Press C button for menu.", 5000)
  checkVersion()
  showMenu = false
  cxEnabled = true
  skyChaseEnabled = false
  chaos4Enabled = false
end

showMenu = false
cxEnabled = true
skyChaseEnabled = false
chaos4Enabled = false

version = ""
timer = 30

function cbVBlank()
  gameAddr = addr[version]
  if(not gameAddr) then 
    -- check version every 30 frames until it looks right
    timer = timer-1
    if(timer <= 0) then
      checkVersion()
      timer = 30
    end
    return
  end
  
  local buttons = flycast.memory.read16(gameAddr.buttons)
  local START = 0x0008
  
  -- Cutscene Skip code originally by Speeps
  if(cxEnabled and
    (flycast.memory.read16(gameAddr.action) == gameAddr.normalAction) and
    (flycast.memory.read16(gameAddr.cxFlag2) ~= 0x0002) and
    (flycast.memory.read16(gameAddr.cxFlag3) == 0x0002) and
    (buttons == START))
  then
    flycast.memory.write8(gameAddr.action,0x06)
    flycast.memory.write8(gameAddr.lives,0x05)
  end
  
  local level = flycast.memory.read8(gameAddr.level)
  local SKY_CHASE_1 = 0x24
  local SKY_CHASE_2 = 0x25
  local CHAOS_4 = 0x11
  
  -- Fast SA1 skips by SQeefy
  if(skyChaseEnabled and
    ((level == SKY_CHASE_1) or (level == SKY_CHASE_2)) and
    (buttons == START))
  then
    flycast.memory.write8(gameAddr.action, 0x05)
  end
  
  if(chaos4Enabled and
    (level == CHAOS_4) and
    (buttons == START))
  then
    flycast.memory.write8(gameAddr.action, 0x05)
  end
end

function checkVersion()
  local rawVersion = flycast.memory.readTable8(0x8c008040, 16)
  version = ""
  for i = 0x8c008040,0x8c00804F do
    version = version..string.char(rawVersion[i])
  end
end

function cbOverlay()
  if(flycast.input.getButtons(1)&1 == 0) then showMenu = true end
  if(not showMenu) then return end
  local ui = flycast.ui
  ui.beginWindow("SACX v"..CX_VERSION_NUMBER, 10, 10, 200, 0)
  if(not addr[version]) then
    ui.text("Game version not supported.")
    ui.text("CX is disabled.")
    ui.text(version)
  else
    ui.text(addr[version].name.." loaded.")
  end
  ui.button("Cutscene Skip", function() cxEnabled = not cxEnabled end)
  ui.rightText((cxEnabled and "ON") or "OFF")
  ui.button("Sky Chase Skip", function() skyChaseEnabled = not skyChaseEnabled end)
  ui.rightText((skyChaseEnabled and "ON") or "OFF")
  ui.button("Chaos 4 Skip", function() chaos4Enabled = not chaos4Enabled end)
  ui.rightText((chaos4Enabled and "ON") or "OFF")
  
  ui.button("Hide Menu", function() showMenu = false end)
  ui.endWindow()
end

flycast_callbacks = {
  start = cbStart,
  vblank = cbVBlank,
  overlay = cbOverlay
}

