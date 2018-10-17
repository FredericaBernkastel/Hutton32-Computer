# Uses PIL (Python Imaging Library) to save the current selection or pattern
# in a user-specified image file (.png/.bmp/.gif/.tif/.jpg).
# See http://www.pythonware.com/products/pil/ for more info about PIL.
# Author: Andrew Trevorrow (andrew@trevorrow.com), Oct 2009.

import golly as g
import os.path
import webbrowser
import urllib

try:
   from PIL import Image
except:
   g.exit("You need to install PIL (Python Imaging Library).")

if g.empty(): g.exit("There is no pattern.")

prect = g.getrect()
srect = g.getselrect()
if len(srect) > 0: prect = srect    # save selection rather than pattern
x = prect[0]
y = prect[1]
wd = prect[2]
ht = prect[3]

# prevent Image.new allocating a huge amount of memory
if wd * ht >= 100000000:
   g.exit("Image area is restricted to < 100 million cells.")

# create RGB image filled initially with state 0 color
multistate = g.numstates() > 2
colors = g.getcolors()          # [0,r0,g0,b0, ... N,rN,gN,bN]
g.show("Creating image...")
im = Image.new("RGB", (wd,ht), (colors[1],colors[2],colors[3]))

# get a row of cells at a time to minimize use of Python memory
cellcount = 0
for row in xrange(ht):
   cells = g.getcells( [ x, y + row, wd, 1 ] )
   clen = len(cells)
   if clen > 0:
      inc = 2
      if multistate:
         # cells is multi-state list (clen is odd)
         inc = 3
         if clen % 3 > 0: clen -= 1    # ignore last 0
      for i in xrange(0, clen, inc):
         if multistate:
            n = cells[i+2] * 4 + 1
            im.putpixel((cells[i]-x,row), (colors[n],colors[n+1],colors[n+2]))
         else:
            im.putpixel((cells[i]-x,row), (colors[5],colors[6],colors[7]))
         cellcount += 1
         if cellcount % 1000 == 0:
            # allow user to abort huge pattern/selection
            g.dokey( g.getkey() )

if cellcount == 0: g.exit("Selection is empty.")
g.show("")

# set initial directory for the save dialog
initdir = ""
savename = g.getdir("data") + "save-image.ini"
try:
   # try to get the directory saved by an earlier run
   f = open(savename, 'r')
   initdir = f.readline()
   f.close()
except:
   # this should only happen the very 1st time
   initdir = g.getdir("data")

# remove any existing extension from layer name and append .png
initfile = g.getname().split('.')[0] + ".png"

# prompt user for output file (image type depends on extension)
outfile = g.savedialog("Save image file",
                       "PNG (*.png)|*.png|BMP (*.bmp)|*.bmp|GIF (*.gif)|*.gif" +
                       "|TIFF (*.tif)|*.tif|JPEG (*.jpg)|*.jpg",
                       initdir, initfile)
if len(outfile) > 0:
   im.save(outfile)
   g.show("Image saved as " + outfile)
   
   # remember file's directory for next time
   try:
      f = open(savename, 'w')
      f.write(os.path.dirname(outfile))
      f.close()
   except:
      g.warn("Unable to save directory to file:\n" + savename)
   
   # on Mac OS X this opens the image file in Preview
   # but it causes an error on Windows
   # webbrowser.open("file://" + urllib.pathname2url(outfile))
