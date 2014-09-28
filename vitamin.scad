//
//  differential_planetary_gearbox
//
//  Copyright 2014 by Ron Aldrich.
//
//  License: CC-By-SA - http://creativecommons.org/licenses/by-sa/3.0/deed.en_US
//
// vitamin.scad
//
// A method for creating a list of vitamins from within a part's scad file.

M3x6 = "M3x6 Bolt";
M3x10 = "M3x10 Bolt";
M3x12 = "M3x12 Bolt";
M3x16 = "M3x16 Bolt";
M3x20 = "M3x20 Bolt";
M3x25 = "M3x25 Bolt";
M3x30 = "M3x30 Bolt";
M3x35 = "M3x35 Bolt";

M3_nut = "M3 nut";
M3_nylock = "M3 nylock nut";

M3_washer = "M3 washer";

M5_nut = "M5 nut";

M8x30 = "M8x30 Bolt";
M8_nut = "M8 nut";
M8_washer = "M8 Washer";

nema_17 = "Nema 17 Stepper Motor";

optional = "Optional";

module vitamin(part, part_count, count, name, comment=false, source=false)
{
  theComment = (comment == false) ? "" : comment;
  theSource = (source == false) ? "" : source;
  
  echo(str("Vitamin - ", part, "_@_", part_count, ", ", count, ", ", name, ", ", theComment, ", ", theSource));
}
