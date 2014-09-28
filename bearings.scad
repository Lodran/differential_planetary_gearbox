//
//  differential_planetary_gearbox
//
//  Copyright 2014 by Ron Aldrich.
//
//  License: CC-By-SA - http://creativecommons.org/licenses/by-sa/3.0/deed.en_US
//
//  bearings.scad
//
//  Bearing specifications
//

bearing_outer_radius = 0;
bearing_inner_radius = 1;
bearing_length =2;

// 3mm shaft bearings.

623_bearing = [10/2, 3/2, 4];
// http://www.hobbyking.com/hobbyking/store/__11726__HK600GT_Ball_Bearings_Pack_3x10x4mm_4pcs_bag.html

683_bearing = [7/2, 3/2, 3];
693_bearing = [8/2, 3/2, 4];
633_bearing = [15/2, 3/2, 5];

// 4mm shaft bearings.

624_bearing = [13/2, 4/2, 5];

// 5mm shaft bearings.

115_bearing = [11/2, 5/2, 4];
105_bearing = [10/2, 5/2, 4];
// http://www.hobbyking.com/hobbyking/store/__21549__Ball_Bearing_5x10x4mm_2pcs_bag_Turnigy_Trailblazer_1_8_XB_and_XT_1_5_.html

// 8mm shaft bearings.

608_bearing = [22/2, 8/2, 7];

// LM8UU linear bearings

LM8UU_bearing = [15/2, 8/2, 24];

// LM10uu linear bearings

LM10UU_bearing = [19/2, 10/2, 29];

module bearing(spec, center=false)
{
	cylinder(h=spec[bearing_length], r=spec[bearing_outer_radius], center=center);
}
