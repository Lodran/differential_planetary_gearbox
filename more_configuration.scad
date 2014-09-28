//
// Copyright 2014 by Ron Aldrich.
//
// License: CC-By-SA - http://creativecommons.org/licenses/by-sa/3.0/deed.en_US
//
// moreConfiguration.scad
//
//	General configuration settings that didn't exist in prusajr's configuration.scad
//
//	These settings are here, rather than in configuration.scad, in
//		order to keep configuration.scad interchangable with prusajr.s version.
//
// Edit extrusion_width to be greater than the width of one shell, but less than the width of two shells.

include <configuration.scad>

fit_clearance = 0.25;
moving_clearance = 0.5;

extrusion_width = .6;

vertical_slop = .6;
horizontal_slop = .3;

_actual_m3_nut_thickness = 2.5;
_actual_m4_nut_thickness = 3.5;
_actual_6_32_nut_thickness = 3.25;

_m3_nut_thickness = [_actual_m3_nut_thickness, _actual_6_32_nut_thickness, _actual_m3_nut_thickness, _actual_m3_nut_thickness];

_m4_nut_thickness = [_actual_m4_nut_thickness, _actual_6_32_nut_thickness, _actual_m3_nut_thickness, _actual_6_32_nut_thickness];

m3_nut_thickness = _m3_nut_thickness[variant];
m3_washer_diameter = 7.5;

m4_nut_thickness = _m4_nut_thickness[variant];

m3_bolt_head_height = 3;
m3_bolt_head_diameter = 6+horizontal_slop;

m4_bolt_head_height = 4;
m4_bolt_head_diameter = 7+horizontal_slop;

// Don't edit things after here.

x = 0;
y = 1;
z = 2;

part_color_1 = [1, .9, 0];
part_color_2 = [.9, 1, 0];

wood_color_1 = [111/256, 78/256, 55/256];
wood_color_2 = wood_color_1+[.2, .2, .2];
wood_color_3 = wood_color_1-[.2, .2, .2];

nema17_hole_spacing = 1.25*25.4;

ramps_size = [102, 60];

ramps_mounts = [[-35.76, -20.86],
                [-35.76, 27.4],
                [39.17, 27.4],
                [45.52, -20.86]];

//echo(ramps_mounts);
