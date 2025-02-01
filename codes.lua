return {
  ["HDR-0001  V1.007"] = {
    name = "Sonic Adventure (JPN)",
    -- Press Start to skip cutscenes
    ["Cutscene Skip"] = {
      0x0E0A000E, 0x00751F14,
      0x0E080002, 0x0175DA20,
      0x0E060002, 0x0075DA18,
      0x0E040008, 0x0075D9A4,
      0x00751F14, 0x00000006,
      0x0075B744, 0x00000005
    },
    -- Press Start to skip Sky Chase
    ["Skip Sky Chase"] = {
      0x0E040024, 0x00751F1A, -- 0E080008 0075D9A4
      0x0D75D9A4, 0x00000008, -- 0E06000E 00751F14
      0x02751F14, 0x00210005, -- 0E020024 01751F1A
      0x0E040025, 0x00751F1A, -- 0D751F1A 00000025
      0x0D75D9A4, 0x00000008, -- 00751F14 00000005
      0x02751F14, 0x00210005
    },
    -- Press Start to skip Chaos 4
    ["Skip Chaos 4"] = {
      0x0E040011, 0x001B52D4,
      0x0D8C178C, 0x00000008,
      0x02751F14, 0x00210005
    },
    -- Select Restart in Twinkle Circuit and hold A, B, X, Y, L, or R to select level
    ["Twinkle Circuit Track Select"] = {
      0x0E28000A, 0x00751F14,
      0x0E260023, 0x00751F1A,
      0x0E040004, 0x0075D9A4,
      0x00751F24, 0x00000000,
      0x0E1C0000, 0x00751F1A,
      0x0E040002, 0x0075D9A4,
      0x00751F24, 0x00000001,
      0x0E160000, 0x00751F1A,
      0x0E040400, 0x0075D9A4,
      0x00751F24, 0x00000002,
      0x0E100000, 0x00751F1A,
      0x0E040200, 0x0075D9A4,
      0x00751F24, 0x00000003,
      0x0E0A0000, 0x00751F1A,
      0x0E040002, 0x0075D9A6,
      0x00751F24, 0x00000004,
      0x0E040000, 0x00751F1A,
      0x0E060001, 0x0075D9A6,
      0x00751F24, 0x00000005,
      0x00751F22, 0x00000023,
      0x00751F14, 0x00000008
    },
    -- Press Y+Start to access Level Select
    ["Level Select (Y+Start)"] = {
      0x0E020208, 0x0075D9A4,
      0x007694D0, 0x00000002
    },
    -- Disables all music and dialogue
    ["Disable Music and Voices"] = {
      0x026124F0, 0x00000000
    },
    ["Skip Any Level (Y+Start)"] = {
      0x0E04000E, 0x00751F14,
      0x0E020208, 0x0075D9A4,
      0x00751F14, 0x00000005
    },
    ["Infinite Restarts"] = {
      0x0D751F14, 0x00000006,
      0x0075B744, 0x00000005
    }
  },
  ["MK-51000  V1.005"] = {
    name = "Sonic Adventure (US 1.1)",
    -- Press Start to skip cutscenes
    ["Cutscene Skip"] = {
      0x0E0A000F, 0x007493B4,
      0x0E080002, 0x01754EC4,
      0x0E060002, 0x00754EBC,
      0x0E040008, 0x00754E4C,
      0x007493B4, 0x00000006,
      0x00752BE0, 0x00000005
    },
    -- Press Start to skip Sky Chase
    ["Skip Sky Chase"] = {
      0x0E040024, 0x0019E970,
      0x0E020008, 0x00754E4C,
      0x027493B4, 0x00210005,
      0x0E040025, 0x0019E970,
      0x0E020008, 0x00754E4C,
      0x027493B4, 0x00210005
    },
    -- Press Start to skip Chaos 4
    ["Skip Chaos 4"] = {
      0x0E040011, 0x0019E970,
      0x0E020008, 0x00754E4C,
      0x027493B4, 0x00210005
    },
    -- Press Y+Start to access Level Select
    ["Level Select (Y+Start)"] = {
      0x0D754E4C, 0x00000208,
      0x00760970, 0x00000002
    }
  },
  ["MK-51058  V1.005"] = {
    name = "Jet Grind Radio (USA)",
    -- Unlock all graffiti
    ["All Graffiti"] = {
      0x0110F42E, 0x00000101,
      0x0410F430, 0x00190001, 0x01010101
    }
  },
  ["T9717N    V1.001"] = {
    name = "Ready 2 Rumble Round 2 (USA)",
    ["All Boxers Unlocked"] = {
      0x0415996C, 0x000C0001, 0x001F001F
    }
  },
  ["T3601M    V1.002"] = {
    name = "Dead or Alive 2 Limited Edition",
    ["All Fighters Unlocked"] = {
      0x01239CEA, 0X00000101
    },
    ["All Costumes Unlocked"] = {
      0x01239CEE, 0x0000FFFF,
      0x04239CF0, 0x00030001, 0xFFFFFFFF
    },
    ["Enable CG Gallery"] = {
      0x01239CEC, 0x00000563
    }
  }
}