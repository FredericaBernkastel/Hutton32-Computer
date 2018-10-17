local g = golly()
local gp = require "gplus"
local pattern = gp.pattern
local fname = g.opendialog("Open RAW Data File", "*.*", "", "ROM.dat")
if #fname == 0 then
  g.exit("")
end

g.new("256k mem") 
g.setrule("Hutton32")

local file = assert(io.open(fname, "rb"))

local patt = pattern({3,0,10,2,1,9,3,1,10,0,2,11,1,2,25,2,2,11,3,2,25})

-- 256 columns
for i=0,7,1 do
  patt = patt + patt.t(math.pow(2,i) * 4,0)
end

-- 1024 rows
for i=0,9,1 do
  patt = patt + patt.t(0,math.pow(2,i) * 3)
end

patt.display("")

-- 32K block
for row=0,1023,1 do
  local block = file:read(32)
  local bytes = {}
  for c in (block or ''):gmatch'.' do
    bytes[#bytes+1] = c:byte()
  end

  -- 256 block
  for _byte=0,31,1 do
    local block_8 = bytes[_byte+1]

    -- 8 block
    for bit=7,0,-1 do
      if (block_8 & 0x01) == 0x01 then
        g.setcell(_byte*32 + bit*4 + 1, row*3 + 1, 9)
      end
      block_8 = block_8 >> 1
    end
  end
end

g.setcell(0,0,8)
g.select({0,0,256 * 4, 1024 * 3})