include <more_configuration.scad>
include <bearings.scad>
include <drive_wheels.scad>

use <gears.scad>
use <teardrops.scad>
use <functions.scad>
use <barbell.scad>
use <motors.scad>

$fa=1;
$fs=1;

drive_bearing = 105_bearing;

with_nema_14 = true;
with_base_plate = true;
with_metal_sun = false;

// Locations for the small_extruder mounting bolts.

extruder_bolts = [
	[0, 16],
	[-8, -13],
	[14.825, -8.5]
];

echo("drive_bearing: ", drive_bearing);

sun_teeth = 10;
planet_1_teeth = 14;
planet_2_teeth = 7;

ring_1_teeth = sun_teeth+planet_1_teeth*2;
ring_2_teeth = ring_1_teeth-planet_1_teeth+planet_2_teeth;

gear_modulus = 1;
gear_pressure_angle = 20;
gear_depth_ratio = .5;
gear_clearance = .25;

sun_gear_hub_height = (with_metal_sun == true) ? 6 : 7;
sun_gear_hub_radius = (with_metal_sun == true) ? 6 : 12;
sun_gear_tooth_length = (with_metal_sun == true) ? 6 : 8;

planet_carrier_bottom_plate_height = 1.5;
planet_carrier_top_plate_height = 1.5;
planet_carrier_radius = gear_pitch_radius(ring_2_teeth, gear_modulus)-1-moving_clearance/2;

planet_input_tooth_length = 5.5;
planet_output_tooth_length = 5.5;
planet_gear_bottom_bore = 4.5;
planet_gear_top_bore = 3.5;

output_plate_height = 1.5;

sun_gear_z = motor_face_length(nema_17())+moving_clearance;
base_top_z = (with_metal_sun == true) ? sun_gear_z+sun_gear_hub_height-planet_carrier_bottom_plate_height-moving_clearance : sun_gear_z+sun_gear_hub_height;
planet_carrier_bottom_z = base_top_z+moving_clearance;
lower_planet_z = planet_carrier_bottom_z+planet_carrier_bottom_plate_height+moving_clearance;
upper_planet_z = lower_planet_z + planet_input_tooth_length;
planet_carrier_top_z = upper_planet_z+planet_output_tooth_length+moving_clearance+planet_carrier_top_plate_height;

ring_top_z = upper_planet_z+moving_clearance;

output_bottom_z = upper_planet_z+moving_clearance;
output_top_z = planet_carrier_top_z+moving_clearance+output_plate_height;

cover_bottom_z = ring_top_z;
cover_top_z = output_top_z+drive_bearing[bearing_length]+1;

num_planets = 3;
planet_angle = 360/(ring_1_teeth+sun_teeth);
planet_offset = (planet_1_teeth-floor(planet_1_teeth/2)*2) == 0 ? 0 : planet_angle/2;
orbit_radius=((planet_1_teeth+sun_teeth)*gear_modulus)/2;

output_gear_radius = 36/2;

echo(str("Size: [", motor_size(nema_17())[x], ", ", motor_size(nema_17())[y], ", ", cover_top_z, "]"));

echo(str("Ratio: ", planetary_ratio(), ":1"));

rendering = 0;  //  0: assembled
                //  1: Full plate.
                //  2: Common plate.
                //  3: Printed sun.
                //  4: Steel sun.

if (rendering == 0)
    gearbox_assembly();
    
if (rendering == 1)
{
    gearbox_common_plate();
    gearbox_printed_sun_plate();
    gearbox_metal_sun_plate();
}

if (rendering == 2)
    gearbox_common_plate();

if (rendering == 3)
    gearbox_printed_sun_plate();

if (rendering == 4)
    gearbox_metal_sun_plate();

module gearbox_assembly()
{
	base();

	fixed_gear();

	sun_gear();

	planet_carrier_bottom();

	planet_gears();

	planet_carrier_top();

	output_gear();

	cover();
}

module gearbox_common_plate()
{
	fixed_gear(print=1);

	translate([-10, 38])
	planet_carrier_bottom(print=1);

	translate([18, 42])
	rotate(0)
	for(i=[0:num_planets-1]) rotate(i*360/num_planets) translate([10, 0])
		planet_gear();

	translate([38, 20])
	planet_carrier_top(print=1);

	translate([-45, 42])
	output_gear(print=1);

	translate([-45, 0])
	cover(print=1);

	translate([-7, -3, .5])
	%cube([120, 130, 1], center=true);
}

module gearbox_printed_sun_plate()
{
	translate([0, -45])
	base(print=1);

	translate([38, -9])
	sun_gear(print=1);
}

module gearbox_metal_sun_plate()
{
	translate([-45, -45])
	base(print=1, short=1);
}

module case_outline()
{
	p1=[0, 0];
	r1=motor_size(nema_17())[x]/2;

	p2 = [motor_mount_spacing(nema_17())/2, motor_mount_spacing(nema_17())/2];
	r2=r1-p2[x];

	for(i=[0:3]) rotate(i*90)
		barbell(p1, p2, r1, r2, 3, 3);
}

module base(print=0, short=0)
{
	if (with_base_plate == true)
	{
		difference()
		{
			base_solid(short);
			base_void();
		}
	}
}

module base_solid(short=0)
{
	linear_extrude(height=base_top_z-3*short, convexity=2)
	{
		case_outline();

		if (with_nema_14 == true)
			rotate(15)
			motor_bolts(nema_14())
			{
					circle(m3_bolt_head_diameter/2+1);
			}
	}
	
}

module base_void()
{
		translate([0, 0, -.05])
		linear_extrude(height=base_top_z+.1, convexity=8)
		{
			circle(13);

			if (with_nema_14 == true)
			{
				rotate(15)
				motor_bolts(nema_14())
				{
					circle(m3_diameter/2);
				}
			}
			else
			{
				motor_bolts(nema_17())
				{
					circle(m3_diameter/2);
				}
			}
		}

		translate([0, 0, 2])
		linear_extrude(height=ring_top_z-2+.1, convexity=8)
		{
			circle(gear_pitch_radius(ring_1_teeth, gear_modulus)-gear_modulus+gear_clearance);

			if (with_nema_14 == true)
			{
				rotate(15)
				motor_bolts(nema_14())
				{
					circle(m3_bolt_head_diameter/2);
				}
			}
		}

		if (with_nema_14 == true)
		{
			translate([0, 0, 10+m3_bolt_head_height])
			rotate([180, 0, 0])
				motor_bolts(nema_17())
			{
				M3_nut_hole(length=10, support=true);
			}
		}
}

/* Fixed (annulus) gear */

module fixed_gear(print=0)
{
	p0=(print==0) ? 1 : 0;
	p1=1-p0;

	translate(p1*[0, 0, -base_top_z])
	difference()
	{
		fixed_gear_solid();
		fixed_gear_void();
	}
}

module fixed_gear_solid()
{
	if (with_base_plate == true)
	{
		translate([0, 0, base_top_z])
		linear_extrude(height=ring_top_z-base_top_z, convexity=2)
		case_outline();
	}
	else
	{
		linear_extrude(height=ring_top_z, convexity=2)
		case_outline();
	}
}

module fixed_gear_void()
{
	if (with_base_plate == true)
	{
		translate([0, 0, base_top_z-.05])
		linear_extrude(height=ring_top_z-base_top_z+.1, convexity=8)
		{
			rotate(180/ring_1_teeth)
			gear2D(ring_1_teeth, gear_modulus, gear_pressure_angle, gear_depth_ratio, -gear_clearance);

			motor_bolts(nema_17())
			{
				circle(m3_diameter/2);
			}
		}
	}
	else
	{
		translate([0, 0, -.05])
		linear_extrude(height=base_top_z+.1, convexity=8)
		{
			circle(13);

			motor_bolts(nema_17())
			{
				circle(m3_diameter/2);
			}
		}

		translate([0, 0, 2])
		linear_extrude(height=ring_top_z-2+.1, convexity=8)
		circle(gear_pitch_radius(ring_1_teeth, gear_modulus)-gear_modulus+gear_clearance);

		translate([0, 0, base_top_z])
		linear_extrude(height=ring_top_z-base_top_z+.1, convexity=8)
		{
			rotate(180/ring_1_teeth)
			gear2D(ring_1_teeth, gear_modulus, gear_pressure_angle, gear_depth_ratio, -gear_clearance);
		}
	}
}

/* Sun gear */

module sun_gear(print=0)
{
	p0=(print==0) ? 1 : 0;
	p1=1-p0;

	translate(p0*[0, 0, sun_gear_z])
	difference()
	{
		sun_gear_solid();
		sun_gear_void();
	}
}

module sun_gear_solid()
{
	cylinder(h=sun_gear_hub_height, r=sun_gear_hub_radius);
	
	translate([0, 0, sun_gear_hub_height-.1])
	linear_extrude(height=sun_gear_tooth_length, convexity=8)
	gear2D(sun_teeth, gear_modulus, gear_pressure_angle, gear_depth_ratio, gear_clearance);
}

module sun_gear_void()
{
	translate([0, 0, -.05])
	cylinder(h=sun_gear_hub_height+sun_gear_tooth_length+.1, r=m5_diameter/2);

	translate([0, 0, sun_gear_hub_height/2])
	rotate([90, 0, 0])
	{
		cylinder(h=sun_gear_hub_radius+.1, r=m3_diameter/2, $fn=6);

		if (!(with_metal_sun == true))
		{
			translate([0, 0, 4])
			rotate(-90)
			hull()
			{
				cylinder(h=m3_nut_thickness, r=m3_nut_diameter/2, $fn=6);
				translate([5, 0, 0])
				cylinder(h=m3_nut_thickness, r=m3_nut_diameter/2, $fn=6);
			}
		}
	}
}

function a1(i) = i*floor(360/num_planets/planet_angle)*planet_angle+planet_offset;

function a2(a1) = a1*sun_teeth/planet_1_teeth;

module orbit()
{
	for(i=[0:num_planets-1]) assign(a1=a1(i))
	{
		rotate(a1)
		translate([orbit_radius, 0, 0])
		rotate(180/planet_1_teeth)
		rotate(a2(a1))
			child();
	}
}

/* Bottom half of planet carrier */

module planet_carrier_bottom(print=0)
{
	p0=(print==0) ? 1 : 0;
	p1=1-p0;

	translate(p0*[0, 0, planet_carrier_bottom_z])
	difference()
	{
		planet_carrier_bottom_solid();
		planet_carrier_void();
	}
}

module planet_carrier_top(print=0)
{
	p0=(print==0) ? 1 : 0;
	p1=1-p0;

	translate(p0*[0, 0, planet_carrier_bottom_z])
	translate(p1*[0, 0, planet_carrier_height])
	rotate(p1*[180, 0, 0])
	difference()
	{
		planet_carrier_top_solid();
		planet_carrier_void();
	}
}

planet_carrier_height = planet_carrier_top_z-planet_carrier_bottom_z;

module planet_carrier_bottom_solid()
{
	cylinder(h=planet_carrier_height/2, r=planet_carrier_radius);
};

module planet_carrier_top_solid()
{
	translate([0, 0, planet_carrier_height/2])
	cylinder(h=planet_carrier_height/2, r=planet_carrier_radius);
}


module planet_carrier_void()
{
	planet_radius = gear_outer_radius(planet_1_teeth, gear_modulus, gear_depth_ratio, gear_clearance);

	sun_radius = gear_outer_radius(sun_teeth, gear_modulus, gear_depth_ratio, gear_clearance);

	// Alignment notch.

	rotate(-44)
	translate([(planet_carrier_radius), 0, planet_carrier_height/2])
	rotate(45)
	cube([1.5, 1.5, planet_carrier_height+.1], center=true);

	// Sun gear.

	translate([0, 0, -.1])
	cylinder(h=planet_carrier_height+.2, r=6+moving_clearance);

	// Planet gears.

	translate([0, 0, planet_carrier_bottom_plate_height])
	orbit() union()
	{
		difference()
		{
			cylinder(h=planet_carrier_height-planet_carrier_bottom_plate_height-planet_carrier_top_plate_height, r=planet_radius+moving_clearance);

			translate([0, 0, -.1])
			{
				cylinder(h=2+.1, r=(planet_gear_bottom_bore-moving_clearance)/2);

				cylinder(h=moving_clearance/2+.1, r=planet_gear_bottom_bore/2+1);
			}

			translate([0, 0, planet_carrier_height-planet_carrier_bottom_plate_height-planet_carrier_top_plate_height-moving_clearance/2])
			cylinder(h=moving_clearance/2+.1, r=planet_gear_bottom_bore/2+1);

		}

		translate([0, 0, planet_carrier_height-planet_carrier_top_plate_height-planet_carrier_bottom_plate_height-moving_clearance])
		cylinder(h=planet_carrier_bottom_plate_height+moving_clearance+.1, r=(planet_gear_top_bore+moving_clearance)/2);
	}

	for(i=[0:num_planets-1]) assign(a1=a1(i)) assign(a2=a1((i+1) % num_planets) + (i==num_planets-1 ? 360 : 0))
	{
		rotate([0, 0, (a1+a2)/2])
		{
			translate([planet_carrier_radius-3.5, 0, planet_carrier_height/2])
			{
				rotate([180, 0, 0])
				translate([0, 0, -.1])
				rotate(90)
				M3_nut_hole(length=planet_carrier_height/2-5+.1, support=1);
				translate([0, 0, -.1])
				M3_bolt_hole(length=planet_carrier_height/2-4+.1, head_length = 4, support=1);
			}
		}
	}

	// Output gear

	translate([0, 0, planet_carrier_bottom_plate_height+moving_clearance+planet_input_tooth_length])
	cylinder(h=20, r=(m5_nut_diameter+5)/2+moving_clearance);

}

module planet_gears(print=0)
{
	p0=(print==0) ? 1 : 0;
	p1=1-p0;

	translate(p0*[0, 0, lower_planet_z])
	orbit()
	{
		planet_gear();
	}
}

module planet_gear()
{
	difference()
	{
		planet_gear_solid();
		planet_gear_void();
	}
}

module planet_gear_solid()
{
	linear_extrude(height=planet_input_tooth_length, convexity=8)
	gear2D(planet_1_teeth, gear_modulus, gear_pressure_angle, gear_depth_ratio, gear_clearance);

	translate([0, 0, planet_input_tooth_length-.1])
	linear_extrude(height=planet_output_tooth_length+.1, convexity=8)
	gear2D(planet_2_teeth, gear_modulus, gear_pressure_angle, gear_depth_ratio, gear_clearance);

	translate([0, 0, planet_input_tooth_length + planet_output_tooth_length -.1])
	cylinder(h=2+.1, r=planet_gear_top_bore/2);
}

module planet_gear_void()
{
	translate([0, 0, -.1])
	cylinder(h=2+.1, r=planet_gear_bottom_bore/2);
}

output_gear_height = output_top_z-output_bottom_z;

module output_gear(print=0)
{
	p0=(print==0) ? 1 : 0;
	p1=1-p0;

	translate(p0*[0, 0, output_bottom_z])
	translate(p1*[0, 0, output_gear_height])
	rotate(p1*[180, 0, 0])
	difference()
	{
		output_gear_solid();
		output_gear_void();
	}
}	

module output_gear_solid()
{
	cylinder(h=output_gear_height, r=output_gear_radius);
}

module output_gear_void()
{
	difference()
	{
		translate([0, 0, -.1])
		linear_extrude(height = output_gear_height-output_plate_height+.1, convexity=8)
		{
			rotate(3)
			gear2D(ring_2_teeth, gear_modulus, gear_pressure_angle, gear_depth_ratio, -gear_clearance);
		}

		translate([0, 0, output_gear_height-2-m5_bolt_head_height])
		cylinder(h=20, r=(m5_nut_diameter+5)/2);
	}

		translate([0, 0, output_gear_height-2-m5_bolt_head_height-.1])
	cylinder(h=m5_bolt_head_height+.1, r=m5_nut_diameter/2, $fn=6);
	
	translate([0, 0, -.1])
	cylinder(h=output_top_z-output_bottom_z+.2, r=m5_diameter/2);

	br = drive_bearing[bearing_outer_radius]-.5;

	translate([0, 0, output_top_z-output_bottom_z-.5])
	difference()
	{
		cylinder(h=1, r1=br+.5, r2=br+1.5);
		cylinder(h=1, r1=br-.5, r2=br-1.5);
	}

}

cover_height = cover_top_z-cover_bottom_z;

module cover(print=0)
{
	p0=(print==0) ? 1 : 0;
	p1=1-p0;

	translate(p0*[0, 0, cover_bottom_z])
	translate(p1*[0, 0, cover_height])
	rotate(p1*[180, 0, 0])
	difference()
	{
		cover_solid();
		cover_void();
	}
}

module cover_solid()
{
	linear_extrude(cover_height, convexity=4)
		case_outline();
}

module cover_void()
{
	translate([0, 0, -.1])
	linear_extrude(height=output_top_z-cover_bottom_z+moving_clearance+.1, convexity=4)
		circle(output_gear_radius+moving_clearance);

	translate([0, 0, output_top_z-cover_bottom_z-.1])
	{
		cylinder(h=drive_bearing[bearing_length]+.1, r=drive_bearing[bearing_outer_radius]+fit_clearance);
		cylinder(h=output_top_z-cover_bottom_z+.2, r=5/2+moving_clearance);
	}

	motor_bolts(nema_17()) union()
	{
		translate([0, 0, -35+cover_height-m3_bolt_head_height])
		M3_bolt_hole(35, support=true);

		translate([0, 0, -.1])
		rotate(45)
		{
			cylinder(h=cover_height-m3_bolt_head_height-2+.1, r=m3_nut_diameter/2, $fn=6);

			cylinder(h=m3_bolt_head_height+.1, r=m3_bolt_head_diameter/2);
		}
	}

	for (bolt=extruder_bolts)
	{
		translate([0, 0, cover_height])
		translate(bolt)
		rotate([180, 0, 0])
		rotate(90)
		M3_nut_hole(1, head_length=cover_height-1);
	}
}


module M3_bolt_hole(length, head_length = m3_bolt_head_height, support=0)
{
	translate([0, 0, -.1])
	cylinder(h=length+.1+(support==0 ? .1 : -layer_height), r=m3_diameter/2);

	translate([0, 0, length])
	linear_extrude(height=head_length+.1, convexity=4)
	{
		if (support == 0)
			circle(m3_bolt_head_diameter/2);
		else
		difference()
		{
			circle(m3_bolt_head_diameter/2);
			circle(m3_diameter/2);
		}
	}
}

module M3_nut_hole(length, head_length = m3_bolt_head_height, support=0)
{
	translate([0, 0, -.1])
	cylinder(h=length+.1+(support==0 ? .1 : -layer_height), r=m3_diameter/2);

	translate([0, 0, length])
	linear_extrude(height=head_length+.1, convexity=4)
	{
		if (support == 0)
			circle(m3_nut_diameter/2, $fn=6);
		else
		difference()
		{
			circle(m3_nut_diameter/2, $fn=6);
			circle(m3_diameter/2);
		}
	}
}

function odd(x) = x-(floor(x/2)*2);
function even(x) = 1-odd(x);

function planetary_ratio() = (1+ring_1_teeth/sun_teeth)*ring_2_teeth/((sun_teeth+planet_1_teeth)*(1-planet_2_teeth/planet_1_teeth));
