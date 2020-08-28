/*
tent-hook.scad

Print Settings:
Filament: "something strong"
First Layer: 0.20mm
Layer: 0.20mm
Perimeters: 5
Infill: 100%
Brim Width: 2mm
Support: no
Raft Layers: 0
*/

cli_fn = 32; // This value can be changed from the OpenSCAD command line.
$fn = cli_fn;
fn_Low  = 32;
fn_Med  = fn_Low * 2;
fn_High = fn_Low * 4;

omega = 0.001;
wallWidth = 6.0;
wallHeight = wallWidth;
bevelRadius = 1;
bevelSteps = 8;

hookAngle = 36;

d1 = 7; // Inside diameter of 'center1'.
r1 = d1/2;
c1 = [0, 0, 0];

d2 = 10; // Inside diameter of 'center2'.
r2 = d2/2;
c2 = c1 + [22-r1+r2, 0, 0];

echo(c2=c2);


tentHook(wallWidth, wallHeight-bevelRadius*2);

// Top Bevel.
translate([0, 0, wallHeight-bevelRadius*2]) {
    tentHookBevel(wallWidth, wallHeight, bevelRadius, bevelSteps);
}
// Bottom Bevel.
mirror([0, 0, 1]) {
    tentHookBevel(wallWidth, wallHeight, bevelRadius, bevelSteps);
}

module tentHookBevel(wallWidth, wallHeight, bevelRadius, bevelSteps) {
    for (layer = [0 : bevelSteps-1]) {
        translate([0, 0, layer*(bevelRadius/bevelSteps)]) {
            tentHook(wallWidth, bevelRadius/bevelSteps, layer*(bevelRadius/bevelSteps));
            // tentHook(
            //     wallWidth - layer*(bevelRadius/bevelSteps),
            //     bevelRadius/bevelSteps
            // );
        }//translate
    }//for
}


module tentHook(wallWidth, wallHeight, bevelOffset = 0) {
    difference() {
        union() {
            hull() {
                // 'center1'
                translate(c1) {
                    cylinder(
                        h = wallHeight,
                        r = r1 + wallWidth - bevelOffset,
                        center = false,
                        $fn = fn_Low
                    );
                };
                // 'center2'
                translate(c2) {
                    cylinder(
                        h = wallHeight,
                        r = r2 + wallWidth - bevelOffset,
                        center = false,
                        $fn = fn_Low
                    );
                };
            }; // Hull
            // hook
            translate([r1*1, r1*2.8, 0]) {
                cylinder(
                    h = wallHeight,
                    r = r1*1.25 - bevelOffset,
                    center = false,
                    $fn = fn_Low
                );
            };
        } // Union.

        translate([0, 0, -omega]) {
            // 'center1'
            translate(c1) {
                cylinder(
                    h = wallHeight + omega*2,
                    r = r1 + bevelOffset,
                    center = false,
                    $fn = fn_Low
                );
            };
            // 'center2'
            translate(c2) {
                cylinder(
                    h = wallHeight + omega*2,
                    r = r2 + bevelOffset,
                    center = false,
                    $fn = fn_Low
                );
            };
            // 'hook'
            translate(c1)
            rotate([0, 0, hookAngle])
            translate([0, -r1 - bevelOffset, 0])
            {
                cube(
                    [c2.x*1.5,
                     d1 + bevelOffset*2,
                     wallHeight+omega*2
                    ],
                    center=false
                );
            };
        }; // Translate
    } // Difference
}
