--------------------------
-- Codebreaker Emulator --
--  written by HamStar  --
--------------------------
-- Loads unencrypted Codebreaker-compatible codes
-- Codes are kept in a separate file, codes.lua
-- Follow formatting in codes.lua to add your own codes


function cbStart()
  initCodes()
  windowVisible = true
end

version = ""
function checkVersion()
  local rawVersion = flycast.memory.readTable8(0x8C008040, 16)
  
  version = ""
  for i = 0x8C008040,0x8C00804F do
    version = version..string.char(rawVersion[i])
  end
end

codes = {}
gameName = nil
function initCodes()
  local loadCodes = loadfile("codes.lua")
  local allCodes = {}
  if(loadCodes) then
    allCodes = loadCodes()
  else
    flycast.emulator.displayNotification("Unable to read file codes.lua", 2000)
    return
  end
  
  codes = {}
  gameName = nil
  local numCodes = 0
  
  local gameCodes = allCodes[version]
  if(gameCodes) then
    for k,v in pairs(gameCodes) do
      if(k == "name") then
        gameName = v
      else
        codes[k] = v
        numCodes = numCodes + 1
      end
    end
  end
  
  if(numCodes > 0) then
    flycast.emulator.displayNotification(
      "Loaded "..numCodes.." codes for "..(gameName or "unknown game")..".", 2000
    )
  end
end

function runCode(code)
  local i = 1
  local skipCodes = 0
  while(code[i]) do
    while(skipCodes > 0) do
      i = i+1
      skipCodes = skipCodes - 1
    end
    if(not code[i]) then return end
    -- top byte is opcode
    local opbyte = code[i] >> 24
    if(opbyte == 0x00) then
      -- 8-bit write
      local addr = (code[i] & 0x00FFFFFF) + 0x8C000000
      i = i+1
      if(not code[i]) then return end
      local value = code[i] & 0x000000FF
      flycast.memory.write8(addr, value)
    elseif(opbyte == 0x01) then
      -- 16-bit write
      local addr = (code[i] & 0x00FFFFFF) + 0x8C000000
      i = i+1
      if(not code[i]) then return end
      local value = code[i] & 0x0000FFFF
      flycast.memory.write16(addr, value)
    elseif(opbyte == 0x02) then
      -- 32-bit write
      local addr = (code[i] & 0x00FFFFFF) + 0x8C000000
      i = i+1
      if(not code[i]) then return end
      local value = code[i]
      flycast.memory.write32(addr, value)
    elseif(opbyte == 0x03) then
      -- 03 has multiple opcodes, check second byte
      local op2 = (code[i] >> 16) & 0xFF
      if(op2 == 0x00) then
        -- 32-bit block write
        local count = code[i] & 0x0000FFFF
        i = i+1
        if(not code[i]) then return end
        local addr = code[i]
        for j = 1, count do
          i = i+1
          if(not code[i]) then return end
          flycast.memory.write32(addr, code[i])
          addr = addr + 4
        end
      elseif(op2 == 0x01) then
        -- 8-bit increment
        -- some versions of codebreaker don't implement increment operators
        local inc = code[i] & 0x000000FF
        i = i+1
        if(not code[i]) then return end
        local addr = code[i]
        local value = flycast.memory.read8(addr)
        flycast.memory.write8(addr, (value+inc)&0xFF)
      elseif(op2 == 0x02) then
        -- 8-bit decrement
        local dec = code[i] & 0x000000FF
        i = i+1
        if(not code[i]) then return end
        local addr = code[i]
        local value = flycast.memory.read8(addr)
        flycast.memory.write8(addr, (value-dec)&0xFF)
      elseif(op2 == 0x03) then
        -- 16-bit increment
        local inc = code[i] & 0x0000FFFF
        i = i+1
        if(not code[i]) then return end
        local addr = code[i]
        local value = flycast.memory.read16(addr)
        flycast.memory.write16(addr, (value+inc)&0xFFFF)
      elseif(op2 == 0x04) then
        -- 16-bit decrement
        local dec = code[i] & 0x0000FFFF
        i = i+1
        if(not code[i]) then return end
        local addr = code[i]
        local value = flycast.memory.read16(addr)
        flycast.memory.write16(addr, (value-dec)&0xFFFF)
      elseif(op2 == 0x05) then
        -- 32-bit increment
        i = i+1
        if(not code[i]) then return end
        local addr = code[i]
        local value = flycast.memory.read32(addr)
        i = i+1
        if(not code[i]) then return end
        local inc = code[i]
        flycast.memory.write32(addr, (value+inc)&0xFFFFFFFF)
      elseif(op2 == 0x06) then
        -- 32-bit decrement
        i = i+1
        if(not code[i]) then return end
        local addr = code[i]
        local value = flycast.memory.read32(addr)
        i = i+1
        if(not code[i]) then return end
        local dec = code[i]
        flycast.memory.write32(addr, (value-dec)&0xFFFFFFFF)
      end
    elseif(opbyte == 0x04) then
      -- 32-bit repeating write
      local addr = (code[i] & 0x00FFFFFF) + 0x8C000000
      i = i+1
      if(not code[i]) then return end
      local count = code[i] >> 16
      local inc = code[i] & 0x0000FFFF
      i = i+1
      if(not code[i]) then return end
      local value = code[i]
      for j = 1, count do
        flycast.memory.write32(addr, value)
        addr = addr+(inc*4)
      end
    elseif(opbyte == 0x05) then
      -- memory copy
      local fromaddr = (code[i] & 0x00FFFFFF) + 0x8C000000
      i = i+1
      if(not code[i]) then return end
      local toaddr = code[i]
      i = i+1
      if(not code[i]) then return end
      local copybytes = code[i]
      for j = 0, copybytes-1 do
        flycast.memory.write8(toaddr+j,flycast.memory.read8(fromaddr+j))
      end
--  elseif(opbyte == 0x07) then
      -- decryption type (not implemented)
--  elseif(opbyte == 0B) then
      -- initial delay (not implemented)
    elseif(opbyte == 0x0C) then
      local addr = (code[i] & 0x00FFFFFF) + 0x8C000000
      i = i+1
      if(not code[i]) then return end
      if(flycast.memory.read32(addr) ~= code[i]) then return end
    elseif(opbyte == 0x0D) then
      local addr = (code[i] & 0x00FFFFFF) + 0x8C000000
      i = i+1
      if(not code[i]) then return end
      local test = code[i] & 0xFFFF
      local cond = code[i] >> 16
      local value = flycast.memory.read16(addr)
      if(
        ((cond == 0) and (value ~= test)) or
        ((cond == 1) and (value == test)) or
        ((cond == 2) and (value >= test)) or
        ((cond == 3) and (value <= test)) or
        ((cond >  3) and (value ~= test))
      ) then
        skipCodes = 1
      end
    elseif(opbyte == 0x0E) then
      local numLines = (code[i] >> 16) & 0xFF
      local test = code[i] & 0xFFFF
      i = i+1
      if(not code[i]) then return end
      local cond = code[i] >> 24
      local addr = (code[i] & 0x00FFFFFF) + 0x8C000000
      local value = flycast.memory.read16(addr)
      if(
        ((cond == 0) and (value ~= test)) or
        ((cond == 1) and (value == test)) or
        ((cond == 2) and (value >= test)) or
        ((cond == 3) and (value <= test)) or
        ((cond >  3) and (value ~= test))
      ) then
        skipCodes = numLines
      end
    elseif(opbyte == 0x0F) then
      -- 16-bit patch (not implemented)
      i = i+1
    end
    i = i+1
  end
end

timer = 0
function cbVBlank()
  -- check game every 60 frames
  timer = timer-1
  if(timer <= 0) then
    oldVersion = version
    checkVersion()
    if(version ~= oldVersion) then initCodes() end
    timer = 60
  end

  -- run codes every frame
  for k,v in pairs(codes) do
    if(v.enabled) then
      runCode(v)
    end
  end
end

windowVisible = true
function cbOverlay()
  if(flycast.input.getButtons(1)&1 == 0) then windowVisible = true end
  if(not windowVisible) then return end
  local ui = flycast.ui
  ui.beginWindow("Codebreaker", 10, 10, 0, 0)
  ui.text(gameName or version)
  for k,v in pairs(codes) do
    ui.button(k.." "..((v.enabled and "ON") or "OFF"), function() v.enabled = not v.enabled end)
  end
  ui.button("Reload Codes", initCodes)
  ui.button("Hide Window", function() 
    windowVisible = false
    flycast.emulator.displayNotification("Press C button to re-open window.", 2000)
  end)
  ui.endWindow()
end

flycast_callbacks = {
  start = cbStart,
  vblank = cbVBlank,
  overlay = cbOverlay
}

