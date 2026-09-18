# 2x4 lumber rack for Yakima CoreBar crossbars

A printable TPU bracket that clamps two 2x4s across a pair of Yakima CoreBar
crossbars, turning them into a flat utility rack you can strap lumber,
ladders, pipe or a canoe to — and screw accessories into, because the top
surface is just wood.

Everything that carries load is hardware-store steel. The printed parts are
the interface between the bar's teardrop section and the flat face of the
board.

![Saddle, bar and board](docs/img/assembly_iso.png)

## How it works

Each place a 2x4 crosses a crossbar gets one bracket, so a rack takes four.

A 3/8" square-bend U-bolt passes under the crossbar, up either side of it,
through the printed **saddle**, and through two holes drilled in the 2x4.
Washers and lock nuts on top pull the whole stack together. The steel takes
all of the tension; nothing depends on the plastic holding a load.

The printed parts do four jobs that steel alone does badly:

- The **saddle** matches the bar's rounded teardrop crown to the flat
  underside of the board, so the board sits on a full-width bearing surface
  instead of rocking on a line of contact.
- The **pad** goes under the bar, inside the bend of the U-bolt, so bare
  steel never touches the bar's vinyl coating.
- Both spread the clamp load over about 4 square inches of bar, which is what
  keeps a hollow steel bar from being dented by a 3/8" bolt.
- TPU damps vibration. Vibration is what backs nuts off on a roof.

![Front view](docs/img/assembly_front.png)

## Bill of materials

### Hardware, per bracket (you need four)

| Qty | Part | Notes |
| --- | --- | --- |
| 1 | 3/8" x 3" x 7" zinc-plated **square-bend U-bolt** | Everbilt model 810226, about $7.25. Square bend matters: the flat bottom matches the bar. The 3" inside opening clears the 2.75" bar with about 3 mm per side. |
| 2 | 3/8"-16 **nylon-insert lock nut**, zinc | Use these instead of the plain nuts in the U-bolt bag. Plain nuts on a roof rack will loosen. |
| 2 | 3/8" **flat washer** | Or one 3" square U-bolt plate, sold beside the U-bolts, which spreads the load better. |
| 1 | Printed **saddle** | |
| 1 | Printed **pad** | |

### For the rack

| Qty | Part | Notes |
| --- | --- | --- |
| 2 | 2x4, 8 ft | Kiln-dried SPF is fine and cheap. Cedar is lighter and will not rot. Pick the two straightest boards on the pile and sight down them. |
| — | Exterior paint or spar urethane | Seal all six faces, including the drilled holes, or the boards will swell and check. |
| 2+ | Cam or ratchet straps | The brackets hold the rack down. Straps hold the load down. These are not the same job. |

Roughly $30 of hardware and $10–16 of lumber.

### Tools

Drill with a 7/16" bit, 9/16" wrench or socket, hacksaw and file for trimming
the U-bolt legs, tape measure, and calipers if you have them.

## Printing

| | Saddle | Pad | Gauge |
| --- | --- | --- | --- |
| Size | 106 x 100 x 30 mm | 74 x 60 x 12 mm | 78 x 12 x 25 mm |
| TPU at 5 walls / 50% infill | ~84 g | ~29 g | ~8 g |

A full set of four is roughly 450 g, about half a spool, and a long weekend of
printing. TPU does not print fast.

- **Material:** TPU 95A works. 98A or 60D is better here — stiffer, and it
  creeps less under sustained clamp load.
- **Layers:** 0.2 mm, 0.4 mm nozzle.
- **Walls:** 5 perimeters. The walls do most of the work in this part.
- **Infill:** 50% gyroid.
- **Top/bottom:** 6 layers.
- **Speed:** 20–25 mm/s. Direct drive strongly preferred.
- **Supports:** none needed.

**Orientation.** Stand the saddle on end, with the bar pocket running
vertically, and use a brim. In that orientation the whole part is a vertical
extrusion and nothing overhangs — the locating lips are ramped at 45° on
purpose. The two U-bolt holes end up horizontal and may sag slightly; open
them with the 7/16" bit if a leg will not pass.

If you would rather print flat, set `lip_h = 0` and lay the part top-face-down
on the bed. You lose the lips that hold the board square while you tighten,
but the print is trivial. The U-bolts locate the board either way.

## Check the fit before you print four

Yakima publishes the CoreBar section as 2.75" wide by 1.10" tall in their
JetFlow teardrop shape, and that is what the model defaults to. Those numbers
came from Yakima's own listing, not from a bar on a bench.

Print `gauge` first — it is a 12 mm slice of the pocket and takes a few
minutes — and push it onto your bar. It should slide on with light thumb
pressure and stay put. If it is tight, loose, or rocks, measure the bar and
set `bar_w`, `bar_h` and `bar_tail_r` in the `.scad` file to match, then
re-slice.

## Assembly

1. **Seal the boards.** Paint or varnish them and let them dry before
   drilling. It is much easier now than later.
2. **Lay the boards on the bars** where you want them, parallel, and square
   them to the vehicle. Somewhere around 30–40" apart suits most loads; the
   limit is your crossbar length and your mirrors.
3. **Mark the holes using the saddle as a drill jig.** Set a saddle on the bar
   under the board, mark through its two holes, and you have the right
   3-3/8" pitch automatically, centred across the board's 3.5" width.
4. **Drill 7/16"** straight through the 1.5" thickness at all eight
   locations. Seal the fresh holes.
5. **Assemble each joint** bottom-up: U-bolt around the bar, pad seated under
   the bar inside the bend, saddle over the bar with its bead facing forward,
   board on top, then washers or plate, then lock nuts.
6. **Tighten evenly**, alternating sides. Stop when the TPU has visibly
   compressed and the assembly will not twist by hand — roughly 10–12 ft-lb.
   **Do not lean on it.** The limit here is the crossbar, not the bolt: a
   CoreBar is hollow steel and a 3/8" U-bolt can crush it.
7. **Trim the legs.** With 7" legs and a 3.5" stack, about 3.5" of thread will
   stick up. Mark, hacksaw, file the burr, and cap them with acorn nuts.
   Exposed threads on a roof catch straps, cargo and hands.
8. **Re-tighten after the first 30 miles**, then before every trip. TPU takes
   a set under load; the first re-torque is not optional.

## Limits and safety

This is a homemade bracket. It has not been load tested or certified, and
nothing here is a manufacturer's specification.

- **The rack's capacity is whatever your vehicle's roof is rated for, or
  whatever Yakima rates your towers and bars for, whichever is lower.** Check
  both. Yakima rack systems are commonly rated around 165 lb dynamic, but it
  depends on your towers and your vehicle's fitting — look up yours.
- The rack itself eats into that. Two 8-ft SPF 2x4s plus hardware is roughly
  25 lb before you load anything.
- Strap every load directly to the 2x4s, front and back. Do not rely on
  friction.
- Anything overhanging the vehicle needs a red flag, and lights at night in
  many states. Check your state's rules.
- Check your garage, hatch and tailgate clearance before you drive anywhere.
- Inspect all eight nuts before every trip.

## Files

```
cad/corebar_2x4_saddle.scad   parametric source; every fit dimension is a named variable
stl/corebar_2x4_saddle.stl    the top part, print 4
stl/corebar_2x4_pad.stl       the under-bar pad, print 4
stl/corebar_2x4_gauge.stl     pocket test slice, print 1 first
docs/img/                     renders
```

Re-render after editing the source:

```sh
openscad -o stl/corebar_2x4_saddle.stl -D 'part="saddle"' cad/corebar_2x4_saddle.scad
openscad -o stl/corebar_2x4_pad.stl    -D 'part="pad"'    cad/corebar_2x4_saddle.scad
openscad -o stl/corebar_2x4_gauge.stl  -D 'part="gauge"'  cad/corebar_2x4_saddle.scad
```

`part="assembly"` renders the saddle, pad, bar and board together for checking
fit on screen.

## Where the numbers came from

- CoreBar section, 2.75" x 1.10", JetFlow teardrop —
  [Yakima's CoreBar listing](https://yakima.com/products/corebar) and
  [etrailer's spec sheet](https://www.etrailer.com/Roof-Rack/Yakima/Y00422.html).
- U-bolt, 3/8" x 3" opening x 7" legs, A307 steel, nuts included —
  [Everbilt 810226 at The Home Depot](https://www.homedepot.com/p/Everbilt-3-8-in-x-3-in-x-7-in-Zinc-Plated-Square-U-Bolt-810226/204775849).
- 2x4 actual dimensions, 1.5" x 3.5" — standard dressed lumber.
