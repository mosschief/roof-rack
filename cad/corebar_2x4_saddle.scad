// ---------------------------------------------------------------------------
// corebar_2x4_saddle.scad
//
// Flexible (TPU) parts that clamp a 2x4 laid flat on top of a Yakima CoreBar
// crossbar, using a 3/8" square-bend U-bolt from any hardware store.
//
// The printed parts do not carry the load.  The U-bolt passes under the bar,
// up either side of it, through the saddle and through two holes drilled in
// the 2x4; the steel takes all the tension.  The TPU matches the bar's
// teardrop section to the flat underside of the board, spreads the clamp load
// so the bar is not dented, keeps steel off the bar's coating, grips, and
// damps the vibration that otherwise backs nuts off.
//
// Two parts:
//   saddle - sits on top of the bar, under the board
//   pad    - sits under the bar, inside the bend of the U-bolt
//
// Four of each make a rack: two 2x4s running fore-and-aft over two crossbars.
//
// All dimensions are millimetres.  Print gauge() first and try it on the real
// bar before committing to four full sets.
// ---------------------------------------------------------------------------

/* [What to render] */
part = "saddle";  // [saddle, pad, gauge, assembly]

/* [Crossbar section] */
// Yakima publishes the CoreBar as 2.75 in wide x 1.10 in tall, in their
// "JetFlow" teardrop shape.  MEASURE YOUR BAR and correct these if needed.
bar_w        = 69.9;   // 2.75 in, fore-and-aft
bar_h        = 28.0;   // 1.10 in, vertical, at the thickest point
bar_tail_r   = 4.0;    // radius of the thin trailing edge
bar_teardrop = true;   // false gives a symmetric obround pocket
bar_fit      = 0.4;    // total clearance added to the pocket

/* [Lumber] */
board_w   = 88.9;  // 3.5 in, the real width of a 2x4
board_fit = 1.5;   // slack for paint, swelling and saw-rough edges

/* [U-bolt] */
// A 3/8 in square-bend U-bolt.  Set ubolt_inside to the opening you actually
// bought; the skirt and pad thicken or thin themselves to suit, so the legs
// always end up cradled tight against the bar.
//   3     in opening = 76.20  (Everbilt 810226)
//   3-1/4 in opening = 82.55
rod_d        = 9.525;  // 3/8 in
ubolt_inside = 82.55;  // 3-1/4 in
hole_fit     = 1.4;    // clearance on the leg holes

/* [Saddle] */
floor_t = 6.0;   // TPU between the crown of the bar and the board
wall_t  = 0;     // skirt wall beside the bar; 0 = fill out to the U-bolt legs
snap    = 5.0;   // how far the skirt wraps below the bar's widest line
lip_h   = 5.0;   // locating lips that capture the board's width
end_pad = 4.0;   // material beyond the leg holes, fore and aft
bead_r  = 1.6;   // bead on the leading face, so FORWARD is obvious

/* [Pad] */
pad_t    = 4.0;   // TPU between the bar and the bend of the U-bolt
pad_wall = 0;     // side walls; 0 = fill out to just inside the U-bolt legs
pad_len  = 60.0;  // length along the bar
pad_gap  = 1.5;   // clearance between pad and saddle

/* [Quality] */
$fa = 2;
$fs = 0.4;

// --- derived ---------------------------------------------------------------
leg_cc   = ubolt_inside + rod_d;            // leg centre-to-centre spacing
hole_d   = rod_d + hole_fit;
cav_w    = bar_w + bar_fit;
cav_h    = bar_h + bar_fit;

// Room between the side of the bar and the inside face of a U-bolt leg.  A
// wider U-bolt leaves the bar free to slide fore-and-aft inside the bend, so
// the skirt wall grows to fill that space and the leg holes, cut full depth,
// scallop it into a cradle that holds each leg against the bar.
side_gap = (ubolt_inside - cav_w) / 2;
wall     = (wall_t > 0) ? wall_t : side_gap + 0.7;
p_wall   = (pad_wall > 0) ? pad_wall : side_gap - 0.75;

skirt_x  = cav_w + 2 * wall;                // fore-and-aft footprint of skirt
body_x   = leg_cc + hole_d + 2 * end_pad;   // fore-and-aft footprint of slab
y_in     = (board_w + board_fit) / 2;       // inner face of the locating lips
body_y   = 2 * (y_in + lip_h);              // length along the bar
cav_z    = -floor_t - cav_h / 2;            // centre height of the bar pocket
cav_bot  = cav_z - cav_h / 2;               // lowest point of the bar
skirt_bz = cav_z - snap;                    // bottom of the saddle skirt
pad_top  = skirt_bz - pad_gap;
pad_bot  = cav_bot - pad_t;

echo(str("drill the 2x4 at this hole pitch: ", leg_cc, " mm = ",
         leg_cc / 25.4, " in"));
echo(str("clearance per side between bar and U-bolt leg: ", side_gap, " mm"));
echo(str("skirt wall: ", wall, " mm    pad wall: ", p_wall, " mm"));
echo(str("grip stack (bar + saddle + board + nut): ",
         (bar_h + floor_t + 38.1 + 10) / 25.4, " in of U-bolt leg"));
assert(side_gap > 1.5, "U-bolt opening is too small for this bar section");
assert(wall >= 2.4, "skirt wall too thin to print; use a wider U-bolt");
// The skirt is deliberately wider than the U-bolt opening: it only has to
// clear the legs where they actually pass, at the middle of the saddle, and
// the leg holes cut that clearance themselves.
assert(cav_w + 2 * p_wall < ubolt_inside, "pad would not fit between the legs");
assert(pad_top < skirt_bz, "pad and saddle would collide");

// --- geometry --------------------------------------------------------------

// Section of the bar in the fore-and-aft / vertical plane.  The nose (the
// thick, rounded edge) points toward -X, which is the front of the vehicle.
module cavity_2d() {
    nose_r = cav_h / 2;
    tail_r = bar_teardrop ? bar_tail_r + bar_fit / 2 : nose_r;
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

// Holes for the U-bolt legs.  Cut full depth, see note above.
module leg_holes() {
    for (s = [1, -1])
        translate([s * leg_cc / 2, 0, 0])
            cylinder(d = hole_d, h = 400, center = true);
}

// A bead down the leading face, so the saddle is easy to orient on the roof.
module front_bead() {
    translate([-body_x / 2, 0, -floor_t / 2])
        rotate([90, 0, 0])
            cylinder(r = bead_r, h = body_y, center = true);
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
        leg_holes();
    }
}

// Cradle between the underside of the bar and the bend of the U-bolt.
module pad() {
    difference() {
        translate([0, 0, (pad_top + pad_bot) / 2])
            cube([cav_w + 2 * p_wall, pad_len, pad_top - pad_bot],
                 center = true);
        bar_solid();
    }
}

// A 12 mm slice of the saddle's pocket.  Prints in a few minutes; push it onto
// the bar to check the section before printing four full sets.
module gauge(t = 12) {
    intersection() {
        saddle();
        translate([0, 0, skirt_bz / 2])
            cube([skirt_x + 1, t, -skirt_bz], center = true);
    }
}

module assembly() {
    saddle();
    pad();
    color("dimgray", 0.55) bar_solid(len = 600, grow = -bar_fit / 2);
    color("burlywood", 0.45)
        translate([0, 0, 38.1 / 2]) cube([600, board_w, 38.1], center = true);
}

if      (part == "saddle")   saddle();
else if (part == "pad")      pad();
else if (part == "gauge")    gauge();
else if (part == "assembly") assembly();
