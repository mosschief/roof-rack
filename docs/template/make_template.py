#!/usr/bin/env python3
"""Draw the true-scale drilling template as a US Letter PDF.

Reads the U-bolt and board sizes from cad/corebar_2x4_saddle.scad, so the
template follows the model when those change.  Needs reportlab.

    python3 docs/template/make_template.py   ->  docs/template/drill-template.pdf
"""
import re
from pathlib import Path

from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas

HERE = Path(__file__).resolve().parent
SCAD = HERE.parent.parent / "cad" / "corebar_2x4_saddle.scad"
OUT = HERE / "drill-template.pdf"

IN = 72.0          # points per inch
MM = IN / 25.4


def scad_value(name):
    m = re.search(rf"^{name}\s*=\s*([0-9.]+)", SCAD.read_text(), re.M)
    return float(m.group(1))


rod_d = scad_value("rod_d")
ubolt_inside = scad_value("ubolt_inside")
board_w = scad_value("board_w")

pitch = (ubolt_inside + rod_d) * MM     # leg centre to centre
drill = 7 / 16 * IN                     # clearance drill for a 3/8" leg
board = board_w * MM                    # 3-1/2" face of a 2x4
plate_w = 1.5 * IN                      # 1-1/2" steel flat bar
plate_end = 0.75 * IN                   # hole centre to end of the plate
board_len = pitch + 2.5 * IN

W, H = letter
c = canvas.Canvas(str(OUT), pagesize=letter)
c.setTitle("Roof rack drilling template")


def dashed(on=True):
    c.setDash(6, 4) if on else c.setDash()


def hole(x, y):
    c.setLineWidth(0.8)
    c.circle(x, y, drill / 2)
    c.setLineWidth(0.4)
    r = drill / 2 + 0.25 * IN
    c.line(x - r, y, x + r, y)
    c.line(x, y - r, x, y + r)
    c.circle(x, y, 0.6, fill=1)


def pitch_dim(x, y0, y1):
    c.setLineWidth(0.4)
    c.line(x, y0, x, y1)
    for y, d in ((y0, 1), (y1, -1)):
        c.line(x, y, x - 3, y + 6 * d)
        c.line(x, y, x + 3, y + 6 * d)
    c.saveState()
    c.translate(x - 4, (y0 + y1) / 2)
    c.rotate(90)
    c.setFont("Helvetica", 8)
    c.drawCentredString(0, 0, f'{pitch / IN:.3f}" ({pitch / MM:.1f} mm) centres')
    c.restoreState()


def template(x0, y0, w, length, title, lines):
    """A cut-out strip w wide, holes on its centreline at the bolt pitch."""
    cx, cy = x0 + w / 2, y0 + length / 2
    c.setLineWidth(1.0)
    dashed(False)
    c.rect(x0, y0, w, length)
    c.setLineWidth(0.4)
    dashed()
    c.line(cx, y0, cx, y0 + length)
    c.line(x0, cy, x0 + w, cy)
    dashed(False)
    for y in (cy - pitch / 2, cy + pitch / 2):
        hole(cx, y)
    pitch_dim(x0 + w + 0.3 * IN, cy - pitch / 2, cy + pitch / 2)
    c.setFont("Helvetica-Bold", 9)
    c.drawCentredString(cx, y0 + length + 16, title)
    c.setFont("Helvetica", 7.5)
    for i, s in enumerate(lines):
        c.drawCentredString(cx, y0 - 12 - 9 * i, s)
    return cx, cy


# --- header ----------------------------------------------------------------
M = 0.5 * IN
top = H - M
c.setFont("Helvetica-Bold", 15)
c.drawString(M, top - 14, "Roof rack drilling template")
c.setFont("Helvetica", 9)
notes = [
    'Print at 100% / "Actual size". Turn OFF "Fit to page" or "Scale to fit".',
    "Then check the scale bars at the bottom with a ruler before you drill anything.",
    f'U-bolt: 3/8" rod, {ubolt_inside / 25.4:.3f}" opening.  Drill 7/16".  '
    "Circles are drawn at the 7/16\" drill size; drill on the crosshair.",
    "Cut out a strip along its solid outline, tape it on, and centre-punch both crosshairs.",
]
for i, s in enumerate(notes):
    c.drawString(M, top - 32 - 12 * i, s)

# --- templates -------------------------------------------------------------
ty = 2.2 * IN                         # bottom of the template strips
bx = M + 0.1 * IN
cx, cy = template(
    bx, ty, board, board_len, "2x4 (3-1/2\" face)",
    ["Lay flush with both edges of the board.",
     "Line the middle dashed line up over the",
     "crossbar, square across the board."])
c.setFont("Helvetica", 7)
c.drawString(bx + 4, cy + 3, "crossbar centre")

px = bx + board + 1.3 * IN
plate_len = pitch + 2 * plate_end
template(
    px, ty + (board_len - plate_len) / 2, plate_w, plate_len,
    "Steel plate (1-1/2\" flat bar)",
    [f'Cut flat bar to {plate_len / IN:.1f}" long.',
     "Optional: replaces the two washers",
     "and spreads the nut load on the wood."])

# --- scale check -----------------------------------------------------------
rx = M
ry = 0.8 * IN
c.setFont("Helvetica-Bold", 9)
c.drawString(rx, ry + 0.62 * IN, "SCALE CHECK. These must measure exactly as labelled:")

def ticks(n, step, minor):
    """(offset, height, label) for each tick of an n-unit ruler."""
    per = int(round(step / minor))
    for i in range(n * per + 1):
        if i % per == 0:
            yield i * minor, 12, str(i // per)
        elif per % 2 == 0 and i % (per // 2) == 0:
            yield i * minor, 8, None
        else:
            yield i * minor, 4, None


def ruler(x, y, n, step, minor, label):
    c.setLineWidth(0.5)
    c.line(x, y, x + n * step, y)
    c.setFont("Helvetica", 7)
    for d, h, t in ticks(n, step, minor):
        c.line(x + d, y, x + d, y + h)
        if t:
            c.drawCentredString(x + d, y + 14, t)
    c.setFont("Helvetica", 8)
    c.drawString(x + n * step + 6, y + 2, label)


def vruler(x, y, n, step, minor, label):
    """Vertical ruler, ticks to the left: checks the printer's other axis."""
    c.setLineWidth(0.5)
    c.line(x, y, x, y + n * step)
    c.setFont("Helvetica", 7)
    for d, h, t in ticks(n, step, minor):
        c.line(x, y + d, x - h, y + d)
        if t:
            c.drawRightString(x - 14, y + d - 2.5, t)
    c.setFont("Helvetica", 8)
    c.drawRightString(x, y + n * step + 8, label)


ruler(rx, ry + 0.2 * IN, 6, IN, IN / 8, "6 in")
ruler(rx, ry - 0.3 * IN, 15, 10 * MM, 1 * MM, "15 cm")
vruler(W - M - 0.05 * IN, ty, 7, IN, IN / 8, "7 in")

c.setFont("Helvetica", 7.5)
c.drawString(rx, 0.3 * IN,
             "If a scale bar is off, fix the print setting and print again. "
             f"Hole centres must be {pitch / IN:.3f}\" apart.")

c.showPage()
c.save()
print(OUT)
