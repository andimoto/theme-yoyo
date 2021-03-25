$fn=50;

diameter1=62;
diameter2=40;
baseThickness=20;

baseCutAt=7;


/* roundness of edges : possible values: 0...5*/
edgeRadius=2;

bearingPlatoHeigth=2;
bearingPlatoDiameter=20;

bearingPlatoInnerDia=16;
bearingPlatoInnerDia2=15;

bearingStem1_Dia=6.4;
bearingStem1_Heigth=3;
bearingStem2_Dia=8;
bearingStem2_Heigth=1;

module bearingCutout()
{
  union()
  {
    difference() {
      cylinder(r=bearingPlatoInnerDia/2, h=bearingPlatoHeigth);
      cylinder(r=bearingPlatoInnerDia2/2, h=bearingPlatoHeigth);
    }
    cylinder(r=bearingStem1_Dia/2, h=bearingStem1_Heigth);
    cylinder(r=bearingStem2_Dia/2, h=bearingStem2_Heigth);
  }
}

/* translate([0,0,30]) bearingCutout(); */

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
    translate([0,0,baseThickness-edgeRadius-2]) cylinder(r=bearingPlatoDiameter/2, h=bearingPlatoHeigth);
  }
  translate([0,0,baseThickness-edgeRadius]) bearingCutout();
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

/* rotate([0,0,0]) yoyoThemeBase(); */
