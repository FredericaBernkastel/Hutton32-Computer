-- Use multiple layers to create a history of the current pattern.
-- The "envelope" layer remembers all live cells.

local g = golly()
local gp = require "gplus"

local generating = false

if g.empty() then g.exit("There is no pattern.") end

local currindex = g.getlayer()
local envindex
local startname = "starting pattern"
local envname = "envelope"

if g.numlayers() > 1 and g.getname(0) == envname then
    envindex = 0
    currindex = 1
else
    -- start a new envelope using pattern in current layer
    if g.numlayers() + 1 > g.maxlayers() then
        g.exit("You need to delete a couple of layers.")
    end
    if g.numlayers() + 2 > g.maxlayers() then
        g.exit("You need to delete a layer.")
    end
    
    envindex = g.addlayer()         -- create layer for remembering all live cells
    g.setcell(0,0,1) -- crashes in tiled view, if layer is empty xd
    
    g.setcolors({
      -1,0,0,0,
      13,0,255,0,
      14,0,255,0,
      15,0,255,0,
      16,0,255,0,
      21,255,0,0,
      22,255,0,0,
      23,255,0,0,
      24,255,0,0,
      26,255,255,0,
      27,255,255,0,
      28,255,255,0,
      29,0,255,0,
      30,0,255,0,
      31,0,255,0,
    })
   
    
    -- move currindex to above the envelope pattern
    g.movelayer(currindex, envindex)
    currindex = envindex
    envindex = currindex - 1
    
    -- name the starting and envelope layers so user can run script
    -- again and continue from where it was stopped
    g.setname(envname, envindex)
end

--------------------------------------------------------------------------------

local function advance(singlestep)      
  if generating or singlestep then
    g.step()
    
    -- get a selected area to supervise, otherwise entire pattern
    local rect = g.getselrect()
    if #rect == 0 then rect = g.getrect() end
    
    local currpatt = g.getcells(rect)
    local differential = {}
    local length = #currpatt
    if (math.fmod(length,2) ~= 0) then
      length = length - 1
    end
    for i = 0, length - 1, 3 do
      local state = currpatt[i + 3]
      if ((state >= 13) and (state <= 16)) or ((state >= 21) and (state <= 24)) or (state >= 26) then
         table.insert(differential, currpatt[i + 1])
         table.insert(differential, currpatt[i + 2])
         table.insert(differential, state)
      end
    end
    if(math.fmod(#differential,2) == 0) then
      table.insert(differential, 0)
    end
    g.check(false)
    g.setlayer(envindex)
    g.putcells(differential)
    g.setlayer(currindex)
    g.check(true)
    

    -- display layers (envelope, current)
    g.update()
  else
    g.sleep(5)
  end
end

--------------------------------------------------------------------------------

function envelope()
    -- draw layers using same location and scale
    g.setoption("syncviews", 1)
    g.show("Press enter to start, esc to stop the script...")
    
    while true do
    
       -- check for user input
      local event = g.getevent()
      if event == "key return none" then
          generating = not generating
      elseif event == "key space none" then
        if generating then
          generating = false
        else
          advance(true)
        end
      else
        g.doevent(event)
      end
      
      advance(false)

    end
end

--------------------------------------------------------------------------------

-- show status bar but hide layer & edit bars (faster, and avoids flashing)
local oldstatus = g.setoption("showstatusbar", 1)
local oldlayerbar = g.setoption("showlayerbar", 1)

local status, err = xpcall(envelope, gp.trace)
if err then g.continue(err) end
-- the following code is executed even if error occurred or user aborted script

-- restore original state of status/layer/edit bars
g.setoption("showstatusbar", oldstatus)
g.setoption("showlayerbar", oldlayerbar)
