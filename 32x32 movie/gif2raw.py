import golly as g
from bitstring import BitArray

try:
	from PIL import Image
	from PIL import ImageSequence
except:
	g.exit("You need to install PIL (Python Imaging Library).")
	 
fname = g.opendialog("Open File", "*.gif", "", "")
if not len(fname):
  g.exit("")
  
outfile = g.savedialog("Save RAW Data File", "*.*", "", "ROM.dat")
if not len(outfile):
	g.exit("")
	
image = Image.open(fname)
buff = BitArray()

for frame in ImageSequence.Iterator(image):
	frame = list(frame.convert("1").getdata())
	for i in range(len(frame)):
		buff.append('0b0' if frame[i] & 0x1 else '0b1')

# normalize to 256k
if buff.length < 1 << 18:
	for i in range ((1 << 18 - 3) - (buff.length >> 3)):
		buff.append('0x00')
elif buff.length > 1 << 18:
	del buff[(1 << 18) + 1 : buff.length]
  
outfile = open(outfile, "wb")
outfile.write(buff.bytes)
outfile.close()
