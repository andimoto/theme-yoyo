$fn=50;

diameter1=62;
diameter2=40;
baseThickness=5;

edgeRadius=2;

module yoyoBase()
{
  translate([0,0,0])
  difference() {
    minkowski() {
      union()
      {
        translate([0,0,baseThickness]) cylinder(r1=diameter1/2,r2=diameter2/2, h=baseThickness);
        translate([0,0,0]) cylinder(r=diameter1/2,h=baseThickness);
      }
      sphere(r=edgeRadius);
    }
    translate([0,0,-edgeRadius]) cylinder(r=diameter1/2+edgeRadius*2,h=baseThickness/2);
  }
}



yoyoBase();
