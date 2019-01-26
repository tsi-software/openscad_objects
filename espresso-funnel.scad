// espresso-funnel.scad
// Copyright (c) 2018-2019 Warren Taylor

$fn = 64; // 180 for high rez;

// 'vertFn' controls the number of vertical segments of the curved wall (i.e. vertical resolution).
// The higher the number the higher the resolution and the more processing power required.
vertFn = 32; //64 for high rez;

// 'targetDiameter' is the inside diameter of your espresso basket that
// this espresso funnel is designed to fit into.
targetDiameter = 51.5;
targetRadius = targetDiameter/2;

wallWidth = 2; // The thickness of the funnel wall.
gap = 0.12;    // The lateral gap between the funnel and the espresso basket.
omega = 0.001; // A very small number used for mathematically purposes.


// ... measurements assuming targetDiameter = 51.5 ...
//function funnelProfile(x) = sqrt(x) * 1; //60mm top diameter.
//function funnelProfile(x) = sqrt(x) * 2; //71mm top diameter.
//function funnelProfile(x) = sqrt(x) * 3; //80mm top diameter.
function funnelProfile(x) = sqrt(x) * 4; //88mm top diameter.

// 'x0' must not be less than zero.
// Increasing it's value will decrease the top rim.
x0 = 0;

// 'x1' controls the height of the funnel.
// 'x1' must be greater than 'x0'.
x1 = 20;

incr = (x1 - x0) / vertFn;
poly1 = [ for (x = [x0 : incr : x1]) [x, funnelProfile(x)] ];
poly2 = reversePoly( offsetPoly(poly1, 0, omega) );
poly = concat(poly1, poly2);


//TESTING.
/**
color("red", 0.5) {
    translate([0, 0, 20]) {
        cube([88, 75, wallWidth], center = true);
    }
}
**/


difference() {
    union() {
        // Cone.
        translate([0, 0, -wallWidth/2]) {
            cone();
        }

        // Connect to inside of coffee basket.
        translate([0, 0, -3]) {
            cylinder(r = targetRadius + 1, h = 3, center = false);
        }
    }//union

    // Size the base of the funnel.
    translate([0,0,-10/2]) {
        difference() {
            cube([targetDiameter*2, targetDiameter*2, 10], center = true);
            cylinder(r = targetRadius - gap, h = 20, center = true);
        }
    }

    // Inside hole of the funnel.
    cylinder(h = 50, r = targetRadius - gap - 1, center = true);
}//difference


module cone() {
    rotate_extrude(convexity = 10) {
        translate([-targetRadius + wallWidth*0.57, 0, 0])
        rotate([0, 0, -90])
        translate([-maxX(poly)-wallWidth/2, -maxY(poly)-wallWidth/2, 0])
        {
            offset( r = wallWidth/2 ) {
                polygon(poly);
            }
        }
    }
}


function offsetPoly(poly, xOffset, yOffset) =
    [ for (node = poly) [node.x + xOffset, node.y + yOffset] ];

function reversePoly(poly, xOffset, yOffset) =
    [ for (ndx = [len(poly)-1 : -1 : 0]) poly[ndx] ];

function maxX(poly) = max([ for (node = poly) node.x ]);
function maxY(poly) = max([ for (node = poly) node.y ]);
