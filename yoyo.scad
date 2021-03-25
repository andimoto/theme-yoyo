$fn=50;

diameter1=62;
diameter2=40;
baseThickness=20;

baseCutAt=7;

edgeRadius=2;


module bearingCutout()
{

}

module yoyoUpperBase()
{
  translate([0,0,edgeRadius])
  difference() {
    minkowski() {
      union()
      {
        /* complete yoyo half base for minkowski calculation */
        translate([0,0,baseThickness/2]) cylinder(r1=diameter1/2-edgeRadius,
                  r2=diameter2/2-edgeRadius,
                  h=baseThickness/2-edgeRadius*2);
        translate([0,0,0]) cylinder(r=diameter1/2-edgeRadius,h=baseThickness/2);
      }
      sphere(r=edgeRadius);
    }
    /* remove lower half of this upper base - this enables supportless printing */
    translate([0,0,-edgeRadius]) cylinder(r=diameter1/2+edgeRadius*2,
                                  h=baseThickness/2-(baseThickness/2-baseCutAt));

    /* bearing cutouts */

  }
}

module yoyoThemeBase()
{
  difference() {
    minkowski()
    {
      translate([0,0,edgeRadius]) cylinder(r=diameter1/2-edgeRadius,h=baseThickness/2);
      sphere(r=edgeRadius);
    }
    translate([0,0,baseThickness/2-(baseThickness/2-baseCutAt)]) cylinder(r=diameter1/2+edgeRadius*2,h=baseThickness/2+edgeRadius*2);
  }
}

translate([0,0,1]) yoyoUpperBase();

rotate([0,0,0]) yoyoThemeBase();
