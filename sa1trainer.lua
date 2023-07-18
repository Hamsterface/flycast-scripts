------------------------
--    SA1 Trainer     --
--  work in progress  --
-- written by HamStar --
------------------------
-- Currently has four options:
-- Respawn: instantly respawn your character, useful for skipping cutscenes
-- Clear level: instantly exit level and progress story
-- Level select: activate internal level select, only visible on JP 1.0
--    - prone to crashes, recommend to reset and use from title screen
-- Free movement: enable free movement mode for Sonic, Knuckles, and Amy

addr = {
  ["HDR-0001  V1.007"] = {
    name = "JP 1.0",
    
    p1Obj = 0x8C795180,
    status = 0x8C751F14,
    lives = 0x8C75B744,
    levelSelect = 0x8C7694D0,
    
    level = 0x8C751F1A, act = 0x8C
    
  },
  ["MK-51000  V1.005"] = {
    name = "US 1.1",
    
    p1Obj = 0x8C78C608,
    status = 0x8C7493B4,
    lives = 0x8C752BE0,
    levelSelect = 0x8C760970
  },
  ["MK-51000  V1.004"] = {
    name = "US 1.0",
    
    p1Obj = 0x8C790688,
    status = 0x8C74D434,
    lives = 0x8C756C60,
    levelSelect = 0x8C7649F0
  },
  ["HDR-0043  V1.003"] = {
    name = "JP International",
    
    p1Obj = 0x8C78DF88,
    status = 0x8C74AD34,
    lives = 0x8C754560,
    levelSelect = 0x8C7622F0
  },
  ["MK-5100050V1.003"] = {
    name = "PAL",
    
    p1Obj = 0x8C78C548,
    status = 0x8C7492F4,
    lives = 0x8C752B20,
    levelSelect = 0x8C7608B0
  },
}

charObj1 = {
  ACTION      = 0x00,
  NEXT_ACTION = 0x01,
  BITFIELD    = 0x04,
  INVULN      = 0x06,
  CHAR_IDX    = 0x08,
  CHAR_ID     = 0x09,
  ROTATION    = 0x14,
  POSITION    = 0x20
}

char_id = {
  SONIC    = 0x0,
  EGGMAN   = 0x1,
  TAILS    = 0x2,
  KNUCKLES = 0x3,
  TIKAL    = 0x4,
  AMY      = 0x5,
  GAMMA    = 0x6,
  BIG      = 0x7
}

version = ""
function checkVersion()
  local rawVersion = flycast.memory.readTable8(0x8C008040, 16)
  
  version = ""
  for i = 0x8C008040,0x8C00804F do
    version = version..string.char(rawVersion[i])
  end
end

function debugFly()
  local pointers = addr[version]
  if(not pointers) then return end
  
  local p1Obj = flycast.memory.read32(pointers.p1Obj)
  if((p1Obj < 0x8C000000) or (p1Obj > 0x8D000000)) then return end
  
  local character = flycast.memory.read8(p1Obj + charObj1.CHAR_ID)
  
  if(character == char_id.SONIC) then
    flycast.memory.write8(p1Obj + charObj1.ACTION, 83)
  elseif(character == char_id.KNUCKLES) then
    flycast.memory.write8(p1Obj + charObj1.ACTION, 53)
  elseif(character == char_id.AMY) then
    flycast.memory.write8(p1Obj + charObj1.ACTION, 49)
  else
    flycast.emulator.displayNotification("Only Sonic, Knuckles, and Amy can use free move.", 2000)
  end
end

function clearLevel()
  local pointers = addr[version]
  if(not pointers and pointers.status) then return end
  
  flycast.memory.write8(pointers.status, 5)
end

function levelSelect()
  local pointers = addr[version]
  if(not pointers and pointers.levelSelect) then return end
  
  flycast.memory.write8(pointers.levelSelect, 2)
end

function reloadLevel()
  local pointers = addr[version]
  if(not (pointers and
    pointers.level and pointers.act and
    pointers.nextLevel and pointer.nextAct and
    pointers.status))
  then return end
  
  local level = flycast.memory.read8(pointers.level)
  local act = flycast.memory.read8(pointers.act)
  flycast.memory.write8(pointers.nextLevel, level)
  flycast.memory.write8(pointers.nextAct, act)
end

function respawn()
  local pointers = addr[version]
  if(not pointers and pointers.lives and pointers.status) then return end
  
  local lives = flycast.memory.read8(pointers.lives)
  flycast.memory.write8(pointers.lives, lives+1)
  flycast.memory.write8(pointers.status, 6)
end

timer = 0
function cbVBlank()
  timer = timer-1
  if(timer <= 0) then
    checkVersion()
    timer = 60
  end
end

function cbOverlay()
  local ui = flycast.ui
  ui.beginWindow("SA1 Trainer", 10, 10, 200, 0)
  ui.text((addr[version] and addr[version].name) or version)
  ui.button("Respawn", respawn)
  ui.button("Clear Level", clearLevel)
  ui.button("Level Select", levelSelect)
  ui.button("Free Movement", debugFly)
  ui.endWindow()
end

flycast_callbacks = {
  vblank = cbVBlank,
  overlay = cbOverlay
}