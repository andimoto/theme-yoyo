$fn=70;

diameter1=62;
diameter2=40;
baseThickness=20;

baseCutAt=7;


/* roundness of edges : possible values: 0...5*/
edgeRadius=2;

bearingPlatoHeigth=2;
bearingPlatoDiameter=21;

bearingPlatoInnerDia=16;
bearingPlatoInnerDia2=14;

bearingStem1_Dia=6.5;
bearingStem1_Heigth=3;
bearingStem2_Dia=8;
bearingStem2_Heigth=1;

screwHoleR=2.2;
screwCylinderR=4;
screwCylinderHeight=6;

screwPlateR=5;

extra=0.1;




plateScrewHeadDia=5.4 +0.6; //screw head diameter + tolerance
plateScrewHeadHeight=2.8 +1; //screw head heigth + tolerance
plateScrewDia=3 -0.2; //screw diameter - tolerance
plateScrewHeight=6 +0.2; //screw heigth + tolerance

/* for placing svg file */
centerSVG=true;
scaleSVG=1.3;
xMoveSVG=0;
yMoveSVG=0;
zMoveSVG=0;
rotateSVG=0;
extrudeSVG=1;
svgColor="black";
fileMotive="svg/Saturn.svg";

module screwHole()
{
  cylinder(r=plateScrewHeadDia/2, h=plateScrewHeadHeight);
  cylinder(r=plateScrewDia/2, h=plateScrewHeight+plateScrewHeadHeight);
}


module themeMotive(file)
{
  color(svgColor)
  rotate([0,0,rotateSVG]) translate([xMoveSVG,yMoveSVG,zMoveSVG])
  scale([1,1,extrudeSVG])
  linear_extrude(height=1)
  scale(scaleSVG)
  import(file, center=centerSVG);
}

module bearingCutout()
{
  union()
  {
    difference() {
      cylinder(r=bearingPlatoInnerDia/2, h=bearingPlatoHeigth);
      cylinder(r=bearingPlatoInnerDia2/2, h=bearingPlatoHeigth+extra);
    }
    cylinder(r=bearingStem1_Dia/2, h=bearingStem1_Heigth);
    cylinder(r=bearingStem2_Dia/2, h=bearingStem2_Heigth);
  }
}

/* translate([0,0,30]) bearingCutout(); */

module yoyoUpperBase()
{
  difference() {
    /* upper yoyo base */
    union()
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
        translate([0,0,baseThickness-edgeRadius-2]) cylinder(r=bearingPlatoDiameter/2, h=bearingPlatoHeigth+extra);
      }
      /* place cutout for yoyo bearing */
      translate([0,0,baseThickness-edgeRadius]) bearingCutout();

    }
    /* screw hole */
    cylinder(r=screwHoleR,h=baseThickness+bearingStem1_Heigth);
    translate([0,0,baseCutAt]) cylinder(r=screwCylinderR,h=screwCylinderHeight);

    /* screws to fix upper yoyo base to lower yoyo base */
    translate([(diameter1/2)-edgeRadius/2-screwPlateR/2,0,0]) screwHole();
    translate([-(diameter1/2)+edgeRadius/2+screwPlateR/2,0,0]) screwHole();
    translate([0,(diameter1/2)-edgeRadius/2-screwPlateR/2,0]) screwHole();
    translate([0,-(diameter1/2)+edgeRadius/2+screwPlateR/2,0]) screwHole();


    /* Debugging: Middle Cut through base */
    /* translate([-diameter1/2,0,0]) cube([diameter1,diameter1/2,baseThickness+2]); */
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

    translate([0,0,edgeRadius/4]) cylinder(r=(diameter1/2-edgeRadius-screwPlateR), h=1, center=true);

    /* screws to fix upper yoyo base to lower yoyo base */
    translate([(diameter1/2)-edgeRadius/2-screwPlateR/2,0,0]) screwHole();
    translate([-(diameter1/2)+edgeRadius/2+screwPlateR/2,0,0]) screwHole();
    translate([0,(diameter1/2)-edgeRadius/2-screwPlateR/2,0]) screwHole();
    translate([0,-(diameter1/2)+edgeRadius/2+screwPlateR/2,0]) screwHole();


    /* Debugging: Middle Cut through base */
    /* translate([-diameter1/2,0,0]) cube([diameter1,diameter1/2,baseThickness+2]); */
  }
  themeMotive(fileMotive);
}



translate([0,0,0]) yoyoUpperBase();
rotate([0,0,0]) yoyoThemeBase();

/* rotate([0,180,0]) translate([0,0,-44]) union()
{
translate([0,0,0]) yoyoUpperBase();
rotate([0,0,0]) yoyoThemeBase();
} */
