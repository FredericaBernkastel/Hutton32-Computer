local g = golly()
local gp = require "gplus"

local segment_period = 264
local segment_w = 17
local segment_h = 17
local array_w = 32
local array_h = array_w
local array_tx_offset = 20
local array_ty_offset = 18

local fname = g.opendialog("Open RAW Data File", "*.*", "", "ROM.dat")
if #fname == 0 then
  g.exit("")
end

g.new("") 
g.setrule("Hutton32b")

local file = assert(io.open(fname, "rb"))

local L1 = gp.pattern("IL$JIpAIpAIpAIpAL$JLpAKpAKpAKpAK$JIpAIpAIpAIpAIpAIpAL$JLpAKpAKpAKpAKpAKpAK$JIpAIpAIpAIpAIpAIpAL$JLpAKpAKpAKpAKpAKpAK$JIpAIpAIpAIpAIpAIpAL$JLpAKpAKpAKpAKpAKpAK$JIpAIpAIpAIpAIpAIpAL$JLpAKpAKpAKpAKpAKpAK$JIpAIpAIpAIpAIpAIpAL$JLpAKpAKpAKpAKpAKpAK$JIpAIpAIpAIpAIpAL$JKpAKpAKpAKpAKpAK!")
local L2 = gp.pattern("2IM!", -3, 0)

-- 256k
for segment = 0, (1 << 10) - 1, 1 do
  
  g.show("Segment #" .. segment .. "...")

  local data_256 = file:read(32)
  local bytes = {}
  local L3 = gp.pattern({})
  
  for c in (data_256 or ''):gmatch'.' do
    bytes[#bytes + 1] = c:byte()
  end

  -- 256
  for byte = 0, 31, 1 do
    local data_8 = bytes[byte + 1]

    -- 8
    for bit = 0, 7, 1 do
      L3.array[(byte * 8 + bit) * 3 + 1] = -(byte * 8 + bit)
      L3.array[(byte * 8 + bit) * 3 + 2] = 0
      L3.array[(byte * 8 + bit) * 3 + 3] = data_8 & 0x80 == 0x80 and 13 or 9
      data_8 = data_8 << 1
    end
  end
  
  L3.array[#L3.array + 1] = 0
  L3 = L3.t(-4, 0)

  local L4 = (L1 + L2 + L3):evolve(256 + 3 + (-(segment % array_w * array_tx_offset + math.floor(segment / array_w) * array_ty_offset) % segment_period))
  
  -- there are no better ways to work with cell arrays
  for i = 0, #L4.array - 1, 3 do
    if L4.array[i + 1] < 0 then
      L4.array[i + 3] = 0
    end
  end
  
  L4.put(segment % array_w * segment_w, math.floor(segment / array_w) * segment_h)
    
end

g.select({0, 0, array_w * segment_w, array_h * segment_h})
g.fit()