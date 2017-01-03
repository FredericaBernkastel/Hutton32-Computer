from glife import validint, inside
from string import lower
import golly as g
import math

rules = ("JvN29", "Nobili32", "Hutton32")

rule = g.getrule ()
if rule not in rules:
    g.exit ("Invalid rule: " + rule + " (must be " + rules + ")")

rect = g.getselrect ()
if len (rect) == 0:
    g.exit ("There is no selection.")

answer = g.getstring("Enter axis to mirror on\n" +
                     "(valid axes are x and y, default is y):",
                     "y",
                     "Mirror selection")

if answer != "x" and answer != "y":
    g.exit ("Unknown mode: " + answer + " (must be x/y)")

cells = g.getcells (rect)

jvn_flip_x = ((10, 12), (14, 16), (18, 20), (22, 24))
jvn_flip_y = ((9, 11), (13, 15), (17, 19), (21, 23))

if answer == "x":
    flips = jvn_flip_x
else:
    flips = jvn_flip_y

def opposite (flips, state):
    for flip in flips:
        if flip[0] == state:
            return flip[1]
        elif flip[1] == state:
            return flip[0]
    return state

for i in range (0, int (math.floor (len (cells) / 3) * 3), 3):
    cells[i + 2] = opposite (flips, cells[i + 2])

g.putcells (cells)

g.flip ({"x": 1, "y": 0}[answer])
