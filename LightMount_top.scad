// Bike Light Spacer

$fn = 50;

// base_flat - this is the flat width on the bike seat post
// base wall thick = minium thickness - not used?
// base width = flat + 4mm (each side) overhang
base_flat = 22;
base_wall_thick = 10;
base_width = base_flat + (4 * 2);

// clears
seat_adj_dia = 6.75;
post_overhang = 3;

// base distance = distance beteen the two inserts on the 
// min base height = 3 + stack height of the screw & washer
base_min_base_height = 3 + 4;
base_distance = 32;
base_hypot = base_distance + seat_adj_dia + post_overhang;
base_opposite = 8;
base_adjacent = sqrt(pow(base_hypot,2) - pow(base_opposite, 2));
base_angle = asin(base_opposite/ base_hypot);
echo("base tilt ange: ", base_angle);
echo("base dimensions:");
echo("         vertical:", base_adjacent);
echo("       horizontal:", base_opposite);
echo("   mating surface:", base_hypot);
echo("            width:", base_width);

// clip inset
clip_width = 22;
clip_length = 41;
clip_depth = 10;



// what is the z-translate distance to lift the subtraction square?
// zh = distance the rotation will be BELOW the original - hypoteneuse
wedge_zh = (base_hypot * 0.5) * sin(base_angle);
wedge_z =  (wedge_zh) / cos(base_angle);

echo(" wedge subtract z-translate:", wedge_zh, wedge_z);

// top inset dimensions
inset_depth = 5;
inset_width = 8;
inset_thick = 3;

// top inset
// you KNOW the thick part is exactly 3 mm
//    so translate is simple, raise 3 mm on z axis
//    -- subtracted 0.1 on z axis to cover rounding errors
translate([-(inset_width/2),-(base_adjacent/2),base_min_base_height])
rotate([base_angle,0,0])
cube([inset_width, inset_thick, inset_depth]);

// seat adj inset
// diameter defined above (seat_adj_dia)
seat_adj_depth = 5;

// seat post surface == base_hypot
// - point that is inset radius from edge
// -- subtracted 0.1 on z axis to cover rounding errors
seat_post_inset_hypot = (base_hypot/2) - (seat_adj_dia/2);
seat_post_inset_z = sin(base_angle) * (base_hypot/2 + seat_post_inset_hypot) + base_min_base_height;
seat_post_inset_y = cos(base_angle) * (base_hypot/2 + seat_post_inset_hypot) - (base_adjacent/2);

echo ("seat post inset:");
echo ("   hypot:", seat_post_inset_hypot);
echo ("       z:", seat_post_inset_z);
echo ("       y:", seat_post_inset_y);

translate([0,seat_post_inset_y,seat_post_inset_z])
rotate([base_angle,0,0])
cylinder(h = seat_adj_depth, r = seat_adj_dia/2);

  

// main base - like a wedge
difference () {
    {
        //translate([0,0,(base_opposite + 3)/2])
        difference() {
            {
            union () {
                // core base
                translate([-base_width/2, -base_adjacent/2,0])
                cube ( [base_width, base_adjacent, base_opposite + base_min_base_height]); 
                    
                // bottom mounting posts
                translate ([base_width/2 ,base_adjacent/2,0])
                cylinder(r = 4, h = 4);
                    
                translate ([-(base_width/2 ),base_adjacent/2,0])
                cylinder(r = 4, h = 4); 
                }
            }
            {
            // subtract out top angle
            //   make it wider and longer + 5 (in x & y dimensions)
            //   it doesn't have to be thicker then base_opposite
            // -- minimum thickness = 3
            echo("wedge translate z:", base_wall_thick, wedge_z);
            //translate([0, 0, base_width + base_wall_thick/2 + wedge_z])
            translate([0,0,base_opposite + base_min_base_height])
            rotate([base_angle,0, 0])
            cube ( [ base_width + 5, base_adjacent + 5, base_opposite], center = true);
            }
        }
    }
    {            

        

    
 
    

        
    // corner chanfer
    // chanfer = 4 mm radius
    // ** remember that variables are immutable
    //    you can't re-use, so use cx1 and cx2
    cx1 = base_width/2;
    cy1 = base_adjacent/2;
  
    // opposite corner
    rotate ([0,0,180])
    translate([(cx1 - 4),(cy1 - 4),0])
    difference () {
    cube ([ 4,4,40], center = false);
    cylinder (r = 4, h = 40);    
    }    
    
    // opposite pair, use new variables
    cx2 = base_width/2;
    cy2 = base_adjacent/2;
    translate([(cx2 - 4),(-cy2 + 4),0])
    rotate ([0,0,270])
    difference () {
    cube ([ 4,4,40], center = false);
    cylinder (r = 4, h = 40);    
    }   

    // mounting holes
    mounting_hole_centers = [
        [(base_width/2 - 4), -(base_adjacent/2 -4), 0],
        [-(base_width/2 - 4), -(base_adjacent/2 -4), 0],
        [base_width/2 ,base_adjacent/2,0],
        [-(base_width/2 ),base_adjacent/2,0]
        ];
        
    for (cntr = mounting_hole_centers) {
        translate(cntr)
        cylinder (r = 1.2, h = 20);
    
    // top mounting post - recess
    translate ([(base_width/2 - 4), -(base_adjacent/2 - 4),3])
    cylinder(r = 4, h = clip_depth);
    translate ([(base_width/2 - 2), -(base_adjacent/2 - 4),10])
    cube ([4,8,14], center = true);
    translate ([(base_width/2 - 4), -(base_adjacent/2 - 2),10])
    cube ([8,4,14], center = true);
        
    translate ([-(base_width/2 - 4), -(base_adjacent/2 -4),3])
    cylinder(r = 4, h = clip_depth); 
    translate ([-(base_width/2 - 2), -(base_adjacent/2 - 4),10])
    cube ([4,8,14], center = true); 
    translate ([-(base_width/2 - 4), -(base_adjacent/2 - 2),10])
    cube ([8,4,14], center = true);     
        
    // bottom mounting posts - recess
    translate ([base_width/2 ,base_adjacent/2,4])
    cylinder(r = 4, h = 20);
        
    translate ([-(base_width/2 ),base_adjacent/2,4])
    cylinder(r = 4, h = 20);     
    }
    
}    
}