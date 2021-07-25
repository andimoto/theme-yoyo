$fn=100;

diameter1=62;
diameter2=25;
baseThickness=20;

baseCutAt=7;


/* roundness of edges : possible values: 0...5*/
edgeRadius=2;

bearingPlatoHeigth=2;
bearingPlatoDiameter=21;
bearingCutoutDepth=2;

bearingPlatoInnerDia=16;
bearingPlatoInnerDia2=13.5;



bearingStem1_Dia=6.5;
bearingStem1_Heigth=2.8;
bearingStem2_Dia=8;
bearingStem2_Heigth=0.8;

screwHoleR=1.7;
screwCylinderR=5;
screwCylinderHeight=6;

screwPlateR=5;

extra=0.1;


plateScrewHeadDia=5.4 +0.6; //screw head diameter + tolerance
plateScrewHeadHeight=2.8 +1; //screw head heigth + tolerance
plateScrewDia=3 -0.2; //screw diameter - tolerance
plateScrewHeight=6 +0.2; //screw heigth + tolerance

balanceRingHeight=2;
balanceRing1r=23;
balanceRing2r=15;



/* place svg file configs */
motiveConf1 = [
"svg/tux.svg",  // file motive
true,           // center SVG
0.09,           // scale SVG
0,              // x Move SVG
2,              // y Move SVG
0,              // z Move SVG
45,             // rotate SVG
1               // extrude SVG (thickness)
];

motiveConf2 = [
"svg/keyboard.svg",  // file motive
true,           // center SVG
1,              // mirror on x axis
0.25,           // scale SVG
0,              // x Move SVG
2,              // y Move SVG
0,              // z Move SVG
45,             // rotate SVG
1               // extrude SVG (thickness)
];

/* add each motive configuration to this array */
motiveList = [
  /* motiveConf1, */
  motiveConf2
];



module screwHole()
{
  cylinder(r=plateScrewHeadDia/2, h=plateScrewHeadHeight);
  cylinder(r=plateScrewDia/2, h=plateScrewHeight+plateScrewHeadHeight);
}

module balanceRing(rInner=20,rOuter=21.75)
{
  difference() {
    cylinder(r=rOuter,h=balanceRingHeight);
    translate([0,0,-extra/2]) cylinder(r=rInner,h=balanceRingHeight+extra);
  }
}
/* balanceRing(); */



module themeMotive(motiveConf)
{
  mirror([motiveConf[2],0,0])
  rotate([0,0,motiveConf[7]]) translate([-motiveConf[4],motiveConf[5],motiveConf[6]])
  scale([1,1,motiveConf[8]])
  linear_extrude(height=1)
  scale(motiveConf[3])
  import(motiveConf[0], center=motiveConf[1]);
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

module yoyoBase()
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
        translate([0,0,baseThickness-edgeRadius-bearingCutoutDepth]) cylinder(r=bearingPlatoDiameter/2, h=bearingPlatoHeigth+extra);
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

    translate([0,0,baseThickness/2-(baseThickness/2-baseCutAt)-edgeRadius])
    balanceRing(rInner=balanceRing1r, rOuter=balanceRing1r+1.75);

    translate([0,0,baseThickness/2-(baseThickness/2-baseCutAt)-edgeRadius])
    balanceRing(rInner=balanceRing2r, rOuter=balanceRing2r+1.75);

    /* Debugging: Middle Cut through base */
    /* translate([-diameter1/2,0,0]) cube([diameter1,diameter1/2,baseThickness+2]); */
  }
  for(motive = motiveList)
  {
    themeMotive(motive);
  }
  /* themeMotive(fileMotive2); */
}



/* translate([0,0,0]) yoyoBase(); */
rotate([0,180,0]) yoyoThemeBase();

/* rotate([0,180,0]) translate([0,0,-44]) union()
{
translate([0,0,0]) yoyoBase();
rotate([0,0,0]) yoyoThemeBase();
} */
