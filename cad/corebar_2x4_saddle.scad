// ---------------------------------------------------------------------------
// corebar_2x4_saddle.scad
//
// Flexible (TPU) parts that clamp a 2x4 laid flat on top of a Yakima CoreBar
// crossbar, with two carriage bolts and a steel plate under the bar.
//
// The printed parts do not carry the load.  Two 3/8" carriage bolts live in
// the 2x4 for good, heads on top.  They pass down through the saddle, past
// the front and back of the bar, and through a flat steel plate underneath
// it; knobs on the bolts pull the plate up against the bar.  The steel takes
// all the tension.  The TPU matches the bar's teardrop section to the flat
// underside of the board, spreads the clamp load so the bar is not dented,
// keeps steel off the bar's coating, grips, and damps vibration.
//
// The plate has a hole at one end and an open-sided notch at the other.  To
// take the rack off, back both knobs off a few turns, swing the plate out
// around the pivot bolt, and lift the board.  Bolts, saddle, plate, pad and
// knobs all stay on the board; nothing comes loose and no tools are needed.
//
// Three parts:
//   saddle - sits on top of the bar, under the board; printed
//   pad    - sits under the bar, on top of the steel plate; printed
//   plate  - steel flat bar, 1-1/2 in wide, cut and drilled by hand; by
//            default two layers of 3/16 in stacked, which is a little
//            stronger than a single 1/4 in plate.
//            part = "plate_template" gives a 1:1 drawing to export as SVG,
//            print at 100% and stick to the steel.
//
// Four of each make a rack: two 2x4s running fore-and-aft over two crossbars.
//
// All dimensions are millimetres.  Print gauge() first and try it on the real
// bar before committing to four full sets.
// ---------------------------------------------------------------------------

/* [What to render] */
part = "saddle";  // [saddle, pad, plate, plate_template, gauge, assembly, open]

include <corebar_profile.scad>

/* [Crossbar section] */
// The section is now traced from Yakima's own cross-section drawing rather
// than guessed -- see corebar_profile.scad.  Set bar_measured = false to fall
// back to the old two-circle teardrop.
bar_measured = true;
// Two published sections disagree, and they differ by a quarter inch in
// width, which is more than the whole design margin.  MEASURE YOUR BAR.
//   2.75 x 1.10 in = 69.9 x 28.0  (Yakima's product listing, and retailers)
//   3.00 x 1.00 in = 76.2 x 25.4  (Yakima's own support article)
// Nothing here depends on a stock U-bolt size any more; the bolt spacing
// follows whatever bar_w is.  stl/fit-gauges/ has a test slice for the pocket.
bar_w        = 70.70;  // fore-and-aft, from the drawing
bar_h        = 27.00;  // vertical at the thickest point, from the drawing
bar_tail_r   = 4.0;    // radius of the thin trailing edge
bar_teardrop = true;   // false gives a symmetric obround pocket
// Most aero crossbars are flat underneath so they can sit in the tower clamp,
// with all the curve on top.  The teardrop above is symmetric top to bottom,
// which is a guess.  If the pocket's big end looks too round against the real
// bar, try this: it puts the curve on top and a flat underside.
bar_flat_bottom = false;
bar_fit      = 0.6;    // total clearance added to the pocket (0.3 per side)

/* [Lumber] */
board_w   = 88.9;  // 3.5 in, the real width of a 2x4
board_t   = 38.1;  // 1.5 in, the real thickness of a 2x4
board_fit = 1.5;   // slack for paint, swelling and saw-rough edges

/* [Bolts] */
// 3/8-16 carriage bolts, driven down through the 2x4 so the square neck bites
// into the wood and the bolt can never turn or fall out.
rod_d       = 9.525;  // 3/8 in
bolt_gap    = 3.0;    // free space between the bar pocket and each bolt
// The saddle's holes are a light grip on the bolt shank, so the saddle stays
// on the board when it comes off the car.
hole_fit    = 0.3;
bolt_len    = 101.6;  // 4 in, under the head to the tip
bolt_thread = 38.1;   // 1-1/2 in of thread, measured up from the tip
washer_t    = 3.0;    // 3/8 x 1-1/4 in fender washer; it spans the notch
knob_h      = 8.4;    // thread the knob (or nut) needs to hold, 3/8-16
thread_p    = 25.4 / 16;
// Which bolt the plate swings on, and which way the free end swings.  The
// notch opens on the opposite side, because relative to the plate the bolt
// leaves in the other direction.
pivot      = "front";  // [front, rear]
swing_side = 1;        // [1, -1] +1 swings the free end toward +Y

/* [Clamp plate] */
plate_w     = 38.1;   // 1-1/2 in flat bar
// The plate is loaded like a beam: the knobs pull its ends up and the bar
// pushes its middle down.  Strength goes with the square of the thickness,
// so a single 3/16 in plate sees nearly twice the stress of a 1/4 in one and
// bends under a firm hand on the knobs.  Two loose 3/16 in layers are
// slightly stronger than one 1/4 in plate; epoxied together, about twice as
// strong.
plate_ply    = 4.7625; // 3/16 in stock
plate_layers = 2;      // layers stacked in each plate
plate_t      = plate_ply * plate_layers;
plate_end   = 16.0;   // steel beyond each bolt centre
plate_hole  = 11.1;   // 7/16 in drill
swing_clear = 1.0;    // room around the bolt while the plate swings past it

/* [Saddle] */
floor_t = 6.0;   // TPU between the crown of the bar and the board
wall_t  = 0;     // skirt wall beside the bar; 0 = fill out to the bolts
snap    = 5.0;   // how far the skirt wraps below the bar's widest line
tail_open  = true; // leave the thin trailing edge uncovered, see tail_relief()
tail_open_x = 0;   // where the relief starts; 0 = auto, at the nose's centre
tail_clear  = 2.0; // unused with the measured section; kept for the old one
lip_h   = 5.0;   // locating lips that capture the board's width
end_pad = 4.0;   // material beyond the bolt holes, fore and aft
bead_r  = 1.6;   // bead on the leading face, so FORWARD is obvious

/* [Pad] */
pad_t      = 4.0;  // TPU between the bar and the plate
pad_wall   = 0;    // fore-and-aft wall beyond the pocket; 0 = auto
// How far the cradle rises above the bar's lowest point.  The plate has to
// drop this far (plus a little) before it can swing, so a deep cradle means
// more turns of the knobs.
pad_wrap   = 3.0;
pad_side   = 3.0;  // TPU lip past each edge of the plate, along the bar
plate_seat = 3.0;  // depth of the channel the plate sits in
seat_fit   = 0.4;  // clearance on the channel's width
pad_gap    = 1.5;  // clearance between pad and saddle

/* [Quality] */
$fa = 2;
$fs = 0.4;

// --- derived ---------------------------------------------------------------
cav_w    = bar_w + bar_fit;
cav_h    = bar_h + bar_fit;
bolt_cc  = cav_w + 2 * bolt_gap + rod_d;    // bolt centre-to-centre spacing
hole_d   = rod_d + hole_fit;

// The skirt wall runs out to the bolts, and the bolt holes, cut full depth,
// scallop it into a cradle that holds each bolt against the bar.
wall     = (wall_t > 0) ? wall_t : bolt_gap + 0.7;
p_wall   = (pad_wall > 0) ? pad_wall : max(2.0, bolt_gap - 0.75);

skirt_x  = cav_w + 2 * wall;                // fore-and-aft footprint of skirt
body_x   = bolt_cc + hole_d + 2 * end_pad;  // fore-and-aft footprint of slab
y_in     = (board_w + board_fit) / 2;       // inner face of the locating lips
body_y   = 2 * (y_in + lip_h);              // length along the bar
cav_z    = -floor_t - cav_h / 2;            // centre height of the bar pocket
nose_cx  = -cav_w / 2 + cav_h / 2;          // centre of the teardrop's nose
// Start the relief just behind the thickest part of the section, so the
// skirt wraps the fat end and opens over everything aft of it.
relief_x = (tail_open_x != 0) ? tail_open_x
         : bar_measured ? -cav_w / 2 + 0.45 * cav_w
         : nose_cx;
cav_bot  = cav_z - cav_h / 2;               // lowest point of the bar
skirt_bz = cav_z - snap;                    // bottom of the saddle skirt

pad_x     = cav_w + 2 * p_wall;
pad_y     = plate_w + seat_fit + 2 * pad_side;
pad_top   = cav_bot + pad_wrap;
plate_top = cav_bot - pad_t;
plate_bot = plate_top - plate_t;
pad_bot   = plate_top - plate_seat;
plate_len = bolt_cc + 2 * plate_end;

pivot_x  = (pivot == "front") ? -bolt_cc / 2 : bolt_cc / 2;
free_x   = -pivot_x;
free_dir = sign(free_x - pivot_x);          // +1 if the free end is at +X
notch_side = -swing_side;
// While the plate swings, every point on it moves on a circle round the
// pivot.  The bolt at the free end sweeps a band of those circles, and the
// notch has to clear the whole band, not just the bolt's own diameter.  A
// straight notch does that if its near edge sits at the band's inner radius
// where it meets the plate's edge, so it is a little wider than the bolt and
// offset toward the pivot -- but still two straight hacksaw cuts.
sweep_r  = rod_d / 2 + swing_clear;
notch_in  = sqrt(pow(bolt_cc - sweep_r, 2) - pow(plate_w / 2, 2));
notch_out = bolt_cc + sweep_r;
// ...and the pad's far corners are trimmed to a circle round the pivot for
// the same reason.
pad_trim_r = bolt_cc - sweep_r;

// Bolt lengths, all measured down from under the head, which sits on the
// top face of the board.
stack         = board_t - plate_bot;        // head to underside of plate
seat          = stack + washer_t;           // head to where the knob seats
thread_starts = bolt_len - bolt_thread;
drop          = pad_wrap + 1.0;             // plate travel before it swings
engaged       = bolt_len - seat;            // thread in the knob, clamped
engaged_open  = engaged - drop;             // ...and backed off to swing

echo(str("drill the 2x4 3/8 in at this hole pitch: ", bolt_cc, " mm = ",
         bolt_cc / 25.4, " in"));
echo(str("plate: ", plate_layers, " x ", plate_len, " mm = ",
         plate_len / 25.4, " in of flat bar, holes at ", plate_end,
         " mm from each end"));
echo(str("notch: ", notch_out - notch_in, " mm wide, near edge ",
         notch_in, " mm from the pivot hole"));
echo(str("skirt wall: ", wall, " mm    pad wall: ", p_wall, " mm"));
echo(str("pocket: ", cav_w, " x ", cav_h, " mm, i.e. ", bar_fit / 2,
         " mm clearance per side"));
echo(str("knob seats ", seat / 25.4, " in below the bolt head; thread starts ",
         thread_starts / 25.4, " in below it"));
echo(str("thread in the knob: ", engaged, " mm clamped, ", engaged_open,
         " mm backed off to swing"));
echo(str("to release: back each knob off ", ceil(drop / thread_p),
         " turns"));
echo(str("bolt tip hangs ", (cav_bot - (board_t - bolt_len)) / 25.4,
         " in below the bar -- check it clears the roof"));
echo(str("minimum usable bolt: ",
         ceil((seat + drop + knob_h) / 25.4 * 4) / 4, " in"));

assert(wall >= 2.4, "skirt wall too thin to print; increase bolt_gap");
assert(p_wall >= 2.0, "pad wall too thin to print");
assert(pad_x < bolt_cc - rod_d, "pad would not fit between the bolts");
assert(pad_top < skirt_bz - pad_gap, "pad and saddle would collide");
assert(plate_seat < plate_t, "the plate must stand proud of its channel");
assert(thread_starts < seat,
       "bolt thread does not reach up far enough: the knob runs out of thread before it touches the plate. Use a shorter bolt or a longer thread.");
assert(engaged_open >= knob_h,
       "bolt too short: the knob would come off before the plate drops clear enough to swing");

// --- geometry --------------------------------------------------------------

// Section of the bar in the fore-and-aft / vertical plane.  The nose (the
// thick, rounded edge) points toward -X, which is the front of the vehicle.
module cavity_2d() {
    if (bar_measured)
        offset(r = bar_fit / 2)
            scale([bar_w / corebar_nominal_w, bar_h / corebar_nominal_h])
                corebar_profile_2d();
    else
        guessed_section_2d();
}

// The original guess: a teardrop hulled from two circles, symmetric top to
// bottom, its nose a half-round as tall as the bar.  Kept for comparison.
// It reached full height within the first quarter of the chord and then
// tapered, where the real section is still thickening out to 36%.
module guessed_section_2d() {
    nose_r = cav_h / 2;
    tail_r = bar_teardrop ? bar_tail_r + bar_fit / 2 : nose_r;
    if (bar_flat_bottom)
        translate([0, -cav_h / 2])
            hull() {
                translate([-cav_w / 2 + nose_r, cav_h - nose_r]) circle(r = nose_r);
                translate([ cav_w / 2 - tail_r, cav_h - tail_r]) circle(r = tail_r);
                translate([-cav_w / 2 + nose_r, 0]) circle(r = 0.01);
                translate([ cav_w / 2 - tail_r, 0]) circle(r = 0.01);
            }
    else
        hull() {
            translate([-cav_w / 2 + nose_r, 0]) circle(r = nose_r);
            translate([ cav_w / 2 - tail_r, 0]) circle(r = tail_r);
        }
}

// The bar itself, swept along its own axis, positioned where it will sit.
module bar_solid(len = 400, grow = 0) {
    translate([0, len / 2, cav_z])
        rotate([90, 0, 0])
            linear_extrude(height = len)
                offset(r = grow)
                    cavity_2d();
}

// Locating lips.  The inner face is a 45 degree ramp: it guides the board in
// and, printed on end, leaves the part with no overhang anywhere.
module lips() {
    if (lip_h > 0)
    for (s = [0, 1]) mirror([0, s, 0])
        translate([-body_x / 2, 0, 0])
            rotate([0, 90, 0])
                linear_extrude(height = body_x)
                    polygon([[0, y_in], [0, body_y / 2], [-lip_h, body_y / 2]]);
}

// Holes for the bolts.  Cut full depth, see note above.
module bolt_holes() {
    for (s = [1, -1])
        translate([s * bolt_cc / 2, 0, 0])
            cylinder(d = hole_d, h = 400, center = true);
}

// A bead down the leading face, so the saddle is easy to orient on the roof.
module front_bead() {
    translate([-body_x / 2, 0, -floor_t / 2])
        rotate([90, 0, 0])
            cylinder(r = bead_r, h = body_y, center = true);
}

// The skirt would otherwise close underneath the bar aft of its thickest
// point, so the saddle could only go on by hooking the trailing edge under
// the bar and rotating the nose over.  A straight-line relief is not enough:
// the real section's trailing edge curls up to 3.7 mm ABOVE the centreline,
// so the relief follows the bar's own underside instead of a fixed height.
module tail_relief() {
    if (tail_open)
        translate([0, body_y / 2 + 1, 0])
            rotate([90, 0, 0])
                linear_extrude(height = body_y + 2)
                    intersection() {
                        // everything at or below the bar's underside, grown a
                        // little so the skirt stops just clear of it
                        translate([0, cav_z])
                            offset(delta = 0.4)
                                hull() {
                                    cavity_2d();
                                    translate([0, -400]) cavity_2d();
                                }
                        // ...but only aft of relief_x
                        translate([relief_x, cav_z - 300]) square([300, 600]);
                    }
}

module saddle() {
    difference() {
        union() {
            // slab the board sits on
            translate([0, 0, -floor_t / 2])
                cube([body_x, body_y, floor_t], center = true);
            // skirt that wraps the bar; overlaps the slab so the union is clean
            translate([0, 0, skirt_bz / 2])
                cube([skirt_x, body_y, -skirt_bz], center = true);
            lips();
            front_bead();
        }
        bar_solid();
        bolt_holes();
        tail_relief();
    }
}

// Cradle between the underside of the bar and the steel plate.  The plate
// sits in a channel in its underside; a dab of flexible adhesive in the
// channel makes the two one part.  The cradle is kept shallow so the plate
// only has to drop a few millimetres before it can swing clear of the bar.
module pad() {
    intersection() {
        difference() {
            translate([0, 0, (pad_top + pad_bot) / 2])
                cube([pad_x, pad_y, pad_top - pad_bot], center = true);
            bar_solid();
            // channel for the plate
            translate([0, 0, (pad_bot + plate_top) / 2 - 0.5])
                cube([pad_x + 2, plate_w + seat_fit, plate_top - pad_bot + 1],
                     center = true);
        }
        // trim the far corners so they clear the free bolt as it swings
        translate([pivot_x, 0, pad_bot - 1])
            cylinder(r = pad_trim_r, h = pad_top - pad_bot + 2);
    }
}

// The steel plate, flat, in its own plane: X along the plate, origin at the
// bar's centreline, pivot hole at pivot_x.
module plate_2d() {
    difference() {
        square([plate_len, plate_w], center = true);
        translate([pivot_x, 0]) circle(d = plate_hole);
        translate([free_x, 0]) circle(d = plate_hole);
        // open-sided notch at the free end
        translate([pivot_x + free_dir * (notch_in + notch_out) / 2,
                   notch_side * (plate_w / 2 + 1) / 2])
            square([notch_out - notch_in, plate_w / 2 + 1], center = true);
    }
}

module plate() {
    for (i = [0 : plate_layers - 1])
        translate([0, 0, plate_bot + i * plate_ply])
            linear_extrude(height = plate_ply - 0.05)
                plate_2d();
}

// 1:1 drilling and cutting template.  Export as SVG, print at 100% scale,
// and check the 50 mm bar with a ruler before trusting it.
module plate_template() {
    difference() {
        plate_2d();
        offset(delta = -0.3) plate_2d();
    }
    for (x = [pivot_x, free_x])
        translate([x, 0]) {
            square([4, 0.3], center = true);
            square([0.3, 4], center = true);
        }
    translate([-plate_len / 2, -plate_w / 2 - 8]) square([50, 1]);
}

// A 12 mm slice of the saddle's pocket.  Prints in a few minutes; push it onto
// the bar to check the section before printing four full sets.
gauge_marks = 0;   // notches cut in the top face, so gauges can be told apart

module gauge(t = 12) {
    difference() {
        intersection() {
            saddle();
            translate([0, 0, skirt_bz / 2])
                cube([skirt_x + 1, t, -skirt_bz], center = true);
        }
        for (i = [0 : 1 : gauge_marks - 1])
            translate([-skirt_x / 2 + 9 + i * 7, 0, 0])
                cube([3, t + 2, 3], center = true);
    }
}

// Carriage bolt, knob and washer, in place.  down = how far the knob is
// backed off.
module bolt_and_knob(down = 0) {
    color("silver") {
        translate([0, 0, board_t]) scale([1, 1, 0.45]) sphere(d = 22.2);
        translate([0, 0, board_t - bolt_len]) cylinder(d = rod_d, h = bolt_len);
    }
    color("silver") translate([0, 0, plate_bot - down - washer_t])
        cylinder(d = 31.75, h = washer_t);
    color("black") translate([0, 0, plate_bot - down - washer_t - 16])
        cylinder(d = 40, h = 16, $fn = 5);
}

// open = false: clamped.  open = true: knobs backed off and the plate swung
// out, as it is when the board is lifted off.
module assembly(open = false, angle = 70) {
    saddle();
    for (x = [-bolt_cc / 2, bolt_cc / 2])
        translate([x, 0, 0]) bolt_and_knob(open ? drop : 0);
    translate([0, 0, open ? -drop : 0])
        translate([pivot_x, 0, 0])
            rotate([0, 0, open ? swing_side * free_dir * angle : 0])
                translate([-pivot_x, 0, 0]) {
                    pad();
                    color("steelblue") plate();
                }
    color("dimgray", 0.55) bar_solid(len = 600, grow = -bar_fit / 2);
    color("burlywood", 0.45)
        translate([0, 0, board_t / 2]) cube([600, board_w, board_t], center = true);
}

if      (part == "saddle")         saddle();
else if (part == "pad")            pad();
else if (part == "plate")          plate();
else if (part == "plate_template") plate_template();
else if (part == "gauge")          gauge();
else if (part == "assembly")       assembly();
else if (part == "open")           assembly(open = true);
