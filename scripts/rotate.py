from glife import validint, inside
from string import lower
import golly as g
import math

rules = ("JvN29", "Nobili32", "Hutton32", "Hutton32b")

rule = g.getrule ()
if rule not in rules:
    g.exit ("Invalid rule: " + rule + " (must be " + rules + ")")

rect = g.getselrect ()
if len (rect) == 0:
    g.exit ("There is no selection.")

answer = g.getstring("Enter direction to rotate in\n" +
                     "(valid rotations are cw and ccw, default is cw):",
                     "cw",
                     "Rotate selection")

if answer != "cw" and answer != "ccw":
    g.exit ("Unknown direction: " + answer + " (must be cw/ccw)")

cells = g.getcells (rect)

jvn_rotate = (( 9, 12, 11, 10),
              (13, 16, 15, 14),
              (17, 20, 19, 18),
              (21, 24, 23, 22))

def rotated (rotations, direction, state):
    for rotation in rotations:
        length = len (rotation)
        for i in range (length):
            if rotation[i] == state:
                return rotation[(i + direction) % length]
    return state

for i in range (0, int (math.floor (len (cells) / 3) * 3), 3):
    cells[i + 2] = rotated (jvn_rotate, {"cw": 1, "ccw": -1}[answer], cells[i + 2])

g.putcells (cells)

g.rotate ({"cw": 0, "ccw": 1}[answer])
