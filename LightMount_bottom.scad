// Bike Light Spacer

$fn = 50;

// base wall thick = minium thickness
base_flat = 22;
base_wall_thick = 10;
base_width = base_flat + (4 * 2);

// clears
seat_adj_dia = 6.75;
post_overhang = 3;

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

// zip tie hole
//   z == distance from the mounting face
//   y == distance from top of cutout
zip_hole_z = 4.5 + (5.4 * 0.25);
zip_hole_y = 15;

// what is the z-translate distance to lift the subtraction square?
// zh = distance the rotation will be BELOW the original - hypoteneuse
wedge_zh = (base_hypot * 0.5) * sin(base_angle);
wedge_z =  (wedge_zh) / cos(base_angle);

echo(" wedge subtract z-translate:", wedge_zh, wedge_z);

// top inset dimensions
inset_depth = 5;
inset_width = 8;
inset_thick = 3;



// main base - bottom
difference () {
    {
    union () {
        // core base
        translate([-base_width/2, -base_adjacent/2,0])
        cube ( [base_width, base_adjacent, clip_depth]); 
            
        // bottom mounting posts
        translate ([base_width/2 ,base_adjacent/2,0])
        cylinder(r = 4, h = clip_depth);
            
        translate ([-(base_width/2 ),base_adjacent/2,0])
        cylinder(r = 4, h = clip_depth);  
      
        // front tie point
        translate([0,- base_adjacent/2 - 5, 5])
        cube([20,10,10], center = true);  
        }
        


    }
    {            
    // clip inset
    translate([-clip_width/2, -clip_length * 0.25])
    cube ([clip_width, clip_length, clip_depth], center = false);
        
    // zip holes
    for (y = [-13, -8, -3]) {
        translate([0,-(clip_length* 0.25 - zip_hole_y) + y, zip_hole_z])
        rotate([0,90,0])
        cylinder(r = 2, h = 50, center = true);
        }
    // 5 mm main zip
    translate([0, 12 , 5])
    rotate([0,90,0])
    cylinder(r = 2.5, h = 50, center = true);
        
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
        cylinder (r = 1, h = clip_depth);
    }
      
    // front tie hole
    rotate([0,90,0])
    translate([-5, - base_adjacent/2 - 5, 0])
    # cylinder( r = 2.5, h = 20, center = true);
    

    }
}    
