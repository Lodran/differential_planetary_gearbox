//
//  differential_planetary_gearbox
//
//  Copyright 2014 by Ron Aldrich.
//
//  License: CC-By-SA - http://creativecommons.org/licenses/by-sa/3.0/deed.en_US
//

gear(
	number_of_teeth=15,
 	modulus=1,
	pressure_angle=45,
	depth_ratio=.5,
	clearance=.25,
	h=5,
	center=true);

function gear_outer_radius(number_of_teeth,
	modulus,
	depth_ratio,
	clearance) = (number_of_teeth*modulus/2)+depth_ratio*(modulus*PI)/2-clearance/2;

function gear_pitch_radius(number_of_teeth, modulus) = number_of_teeth*modulus/2;

module gear (
	number_of_teeth,
	modulus,
	pressure_angle,
	depth_ratio,
	clearance,
	h,
	center=false)
{
	linear_extrude(height=h, center=center, convexity=4)
	{
		gear2D(number_of_teeth, modulus, pressure_angle, depth_ratio, clearance);
	}
}

module gear2D (
	number_of_teeth,
	modulus,
	pressure_angle,
	depth_ratio,
	clearance)
{
	circular_pitch = modulus*PI;
	pitch_radius = gear_pitch_radius(number_of_teeth, modulus);
	base_radius = pitch_radius*cos(pressure_angle);
	depth=circular_pitch/(2*tan(pressure_angle));
	outer_radius = clearance<0 ? pitch_radius+depth/2-clearance : pitch_radius+depth/2;
	root_radius1 = pitch_radius-depth/2-clearance/2;
	root_radius = (clearance<0 && root_radius1<base_radius) ? base_radius : root_radius1;
	backlash_angle = clearance/(pitch_radius*cos(pressure_angle)) * 180 / PI;
	half_thick_angle = 90/number_of_teeth - backlash_angle/2;
	pitch_point = involute (base_radius, involute_intersect_angle (base_radius, pitch_radius));
	pitch_angle = atan2 (pitch_point[1], pitch_point[0]);
	min_radius = max (base_radius,root_radius);

	*echo("circular_pitch = ", circular_pitch,
		"pitch_radius = ", pitch_radius,
		"base_radius = ", base_radius,
		"depth = ", depth,
		"outer_radius = ", outer_radius);

	intersection()
	{
		rotate(90/number_of_teeth)
			circle($fn=number_of_teeth*3,r=pitch_radius+depth_ratio*circular_pitch/2-clearance/2);
		union()
		{
			rotate(90/number_of_teeth)
				circle($fn=number_of_teeth*2,r=max(root_radius,pitch_radius-depth_ratio*circular_pitch/2-clearance/2));
			for (i = [1:number_of_teeth])rotate(i*360/number_of_teeth)
			{
				halftooth (
					pitch_angle,
					base_radius,
					min_radius,
					outer_radius,
					half_thick_angle);		
				mirror([0,1]) halftooth (
					pitch_angle,
					base_radius,
					min_radius,
					outer_radius,
					half_thick_angle);
			}
		}
	}
}

module halftooth (
	pitch_angle,
	base_radius,
	min_radius,
	outer_radius,
	half_thick_angle)
{
	index=[0,1,2,3,4,5];
	start_angle = max(involute_intersect_angle (base_radius, min_radius)-5,0);
	stop_angle = involute_intersect_angle (base_radius, outer_radius);
	angle=index*(stop_angle-start_angle)/index[len(index)-1];
	p=[[0,0],
	involute(base_radius,angle[0]+start_angle),
	involute(base_radius,angle[1]+start_angle),
	involute(base_radius,angle[2]+start_angle),
	involute(base_radius,angle[3]+start_angle),
	involute(base_radius,angle[4]+start_angle),
	involute(base_radius,angle[5]+start_angle)];

	difference()	
	{
		rotate(-pitch_angle-half_thick_angle)polygon(points=p);
		square(2*outer_radius);
	}
}

// Mathematical Functions
//===============

// Finds the angle of the involute about the base radius at the given distance (radius) from it's center.
//source: http://www.mathhelpforum.com/math-help/geometry/136011-circle-involute-solving-y-any-given-x.html

function involute_intersect_angle (base_radius, radius) = sqrt (pow (radius/base_radius, 2) - 1) * 180 / PI;

// Calculate the involute position for a given base radius and involute angle.

function involute (base_radius, involute_angle) =
[
	base_radius*(cos (involute_angle) + involute_angle*PI/180*sin (involute_angle)),
	base_radius*(sin (involute_angle) - involute_angle*PI/180*cos (involute_angle))
];

