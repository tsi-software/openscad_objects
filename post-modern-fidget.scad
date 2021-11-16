// post-modern-fidget.scad
// Copyright (c) 2018-2019 Warren Taylor

cli_fn = 64; // This value can be changed by the command line.
$fn = cli_fn;

gap = 0.12; // 0.15;
doDiameter = 16; // overall length = 16 * 4 = 64
doRadius = doDiameter / 2;

rotate([0, 45, 0]) {
    donut(doRadius + gap, doRadius);

    translate([0, doRadius*2 + gap/2, 0])
    rotate([0, 90, 0]) {
        donut(doRadius + gap, doRadius);
    }
}

module donut(insideRadius, radialRadius) {
    rotate_extrude(convexity = 10, $fn = cli_fn * 2)
    translate([insideRadius + radialRadius, 0, 0]) {
        circle(r = radialRadius, $fn = cli_fn);
    }
}
