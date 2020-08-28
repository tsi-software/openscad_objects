// bevelledText.scad
// Copyright (c) 2018-2019 Warren Taylor

$fn = 32; //64;

fontHeight = 22;
extrudeHeight = 4;
textWeight = 0.3;
layerHeight = 0.1;
bevelRadius = 0.8;


translate([0, fontHeight * 1.25, 0]) {
    bevelled2D(extrudeHeight, textWeight, layerHeight, bevelRadius, bevelBottom = false, rounded = true)
        text(
            text = "Top"
          , size = fontHeight
          , font = "Century Schoolbook L:style=Roman"
          , halign = "center"
          , valign = "center"
        );
    // Confirm extrusion height.
    //color("red", 0.5) 
    //translate([0, -fontHeight/2, 0])
    //{
    //    cube([10, fontHeight, extrudeHeight], center = false);
    //}
}

translate([0, 0, 0]) {
    bevelled2D(extrudeHeight, textWeight, layerHeight, bevelRadius, bevelBottom = true, rounded = true)
        text(
            text = "T&B"
          , size = fontHeight
          , font = "Century Schoolbook L:style=Roman"
          , halign = "center"
          , valign = "center"
        );
    // Confirm extrusion height.
    //color("red", 0.5) 
    //translate([0, -fontHeight/2, 0])
    //{
    //    cube([10, fontHeight, extrudeHeight], center = false);
    //}
}

translate([0, -fontHeight * 1.25, 0]) {
    bevelled2D(extrudeHeight, textWeight, layerHeight, bevelRadius, bevelBottom = false, rounded = false)
        text(
            text = "Straight"
          , size = fontHeight
          , font = "Century Schoolbook L:style=Roman"
          , halign = "center"
          , valign = "center"
        );
    // Confirm extrusion height.
    //color("red", 0.5) 
    //translate([0, -fontHeight/2, 0])
    //{
    //    cube([10, fontHeight, extrudeHeight], center = false);
    //}
}


translate([0, -fontHeight * 1.25 * 2, 0]) {
    bevelled2D(extrudeHeight, textWeight, layerHeight, bevelRadius, bevelBottom = false, rounded = true)
    {
        // And to really go crazy, combine a 2D circle and a 2D polygon.
        circle(r = fontHeight / 2, $fn = 16);
        translate([fontHeight, -11, 0]) polygon([ [0,0], [22,0], [22,22] ]);
    }
}


/*
    extrudeHeight - the height ( z value) to which the text is raised.
    textWeight    - additional 'offset' value to make the text thicker.
    layerHeight   - resolution, similar in function to $fn.
                    (suggestion: try setting 'layerHeight' to a quarter of your slicer layer height setting).
    bevelRadius   - the radius of the bevel.
    bevelBottom   - boolean, bevel the bottom, or not.
    rounded       - should the bevel be rounded or straight.
*/
module bevelled2D(extrudeHeight, textWeight, layerHeight, bevelRadius, bevelBottom = true, rounded = true) {
    // Mathematically generate the bevel layers.
    bevelLayers = [
        for (y = [ 0 : layerHeight : bevelRadius ])
            let (
                normalizedLayer = y / bevelRadius,
                angle = asin(normalizedLayer),
                x = rounded ? (bevelRadius * cos(angle)) : (bevelRadius - y)
            )
            [x,y]
    ];

    // Render the bevel layers.
    translate([0, 0, bevelBottom ? extrudeHeight/2 : 0])
    union()
    {
        for (layer = bevelLayers) {
            if (bevelBottom) {
                // Bevel Top and Bottom.
                linear_extrude(
                    //NOTE: 2* because we bevel both the top and the bottom.
                    height = extrudeHeight + 2*(layer.y - bevelRadius),
                    center = true,
                    convexity = 10
                ) {
                    offset(delta = textWeight + layer.x - bevelRadius) {
                        children();
                    }
                }
            } else {
                // Bevel Top only.
                linear_extrude(
                    height = extrudeHeight + (layer.y - bevelRadius),
                    center = false,
                    convexity = 10
                ) {
                    offset(delta = textWeight + layer.x - bevelRadius) {
                        children();
                    }
                }
            }
        }
    }
}
