//
//  differential_planetary_gearbox
//
//  Copyright 2014 by Ron Aldrich.
//
//  License: CC-By-SA - http://creativecommons.org/licenses/by-sa/3.0/deed.en_US
//

$fa=1;
$fs=1;

x=0;
y=1;
z=2;

motor_size = 0;
motor_mount_spacing = 1;
motor_face_length = 2;
motor_face_radius = 3;

function motor_size(spec) = spec[motor_size];
function motor_mount_spacing(spec) = spec[motor_mount_spacing];
function motor_face_length(spec) = spec[motor_face_length];
function motor_face_radius(spec) = spec[motor_face_radius];

nema_14 = [[35.3, 35.3, 26], 26, 2, 11];
nema_17 = [[42, 42, 40], 31, 2, 11];

function nema_14() = nema_14;
function nema_17() = nema_17;

motor(nema_17);

module motor_bolts(spec)
{
	for(i=[0:3]) rotate(i*90) translate([spec[motor_mount_spacing]/2, spec[motor_mount_spacing]/2])
		child();
}

module motor(spec)
{
	render(convexity=4)
	{
		difference()
		{
			motor_solid(spec);
			motor_void(spec);
		}
	}
}

module motor_solid(spec)
{
	translate([0, 0, -spec[motor_size][z]/2])
	cube(spec[motor_size], center=true);

	translate([0, 0, -.1])
	cylinder(h=spec[motor_face_length]+.1, r=spec[motor_face_radius]);

	translate([0, 0, spec[motor_face_length]-.1])
	cylinder(h=12, r=5/2);
}

module motor_void(spec)
{
	translate([0, 0, -5])
		motor_bolts(spec)
		{
			cylinder(h=5.1, r=3/2);
		}
}
