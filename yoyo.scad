/* yoyo.scad
Author: andimoto@posteo.de
----------------------------
for placing assambled parts and
single parts set 'showBase' or 'showTop' to 'true'

*/


$fn=100;

showBase = false;
showThemeBaseNr = 1;  // 0 = no theme, 1 = motive 1, 2 = motive 2, 3 = both motives
showYoyoBuild = false;

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
"svg/guitar.svg",  // file motive
true,           // center SVG
0,              // mirror on x axis
0.09,           // scale SVG
0,              // x Move SVG
2,              // y Move SVG
0,              // z Move SVG
45,             // rotate SVG
1               // extrude SVG (thickness)
];

motiveConf2 = [
"svg/guitar.svg",  // file motive
true,           // center SVG
1,              // mirror on x axis
0.55,           // scale SVG
1.5,              // x Move SVG
0,              // y Move SVG
0,              // z Move SVG
-45,             // rotate SVG
1               // extrude SVG (thickness)
];

/* add each motive configuration to this array */
motiveListA = [
  /* motiveConf1, */
  motiveConf2
];

motiveListB = [
  motiveConf1,
  motiveConf2
];




module balanceRing(rInner=20,rOuter=21.75)
{
  difference() {
    cylinder(r=rOuter,h=balanceRingHeight);
    translate([0,0,-extra/2]) cylinder(r=rInner,h=balanceRingHeight+extra);
  }
}
/* balanceRing(); */



module themeMotive(motiveList)
{

  for(motive = motiveList)
  {
    translate([motive[4],motive[5],motive[6]])
    mirror([motive[2],0,0])
    rotate([0,0,motive[7]])
    scale([1,1,motive[8]])
    linear_extrude(height=1)
    scale(motive[3])
    import(motive[0], center=motive[1]);
  }
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


module screwHole()
{
  translate([0,0,baseThickness/2+edgeRadius*2-plateScrewHeadHeight])
    cylinder(r=plateScrewHeadDia/2, h=plateScrewHeadHeight+extra);
  cylinder(r=plateScrewDia/2, h=baseThickness/2+edgeRadius*2);
}

module yoyoThemeBase(motiveNr = 0)
{
  difference() {
    translate([0,0,-baseCutAt])
    minkowski()
    {
      translate([0,0,edgeRadius]) cylinder(r=diameter1/2-edgeRadius,h=baseThickness/2);
      sphere(r=edgeRadius);
    }

    translate([0,0,-baseCutAt])
    union()
    {
      translate([0,0,(baseThickness/2+edgeRadius*2)-0.5])
        cylinder(r=(diameter1/2-edgeRadius-screwPlateR), h=1+extra, center=true);

      /* screws to fix upper yoyo base to lower yoyo base */
      translate([(diameter1/2)-edgeRadius/2-screwPlateR/2,0,0]) screwHole();
      translate([-(diameter1/2)+edgeRadius/2+screwPlateR/2,0,0]) screwHole();
      translate([0,(diameter1/2)-edgeRadius/2-screwPlateR/2,0]) screwHole();
      translate([0,-(diameter1/2)+edgeRadius/2+screwPlateR/2,0]) screwHole();
    }

    translate([0,0,-extra])
    balanceRing(rInner=balanceRing1r, rOuter=balanceRing1r+1.75+extra);

    translate([0,0,-extra])
    balanceRing(rInner=balanceRing2r, rOuter=balanceRing2r+1.75+extra);

    translate([0,0,-(baseThickness/2+edgeRadius*2)])
      cylinder(r=diameter1/2+edgeRadius*2,h=baseThickness/2+edgeRadius*2);

    /* Debugging: Middle Cut through base */
    /* translate([-diameter1/2,0,0]) cube([diameter1,diameter1/2,baseThickness+2]); */
  }

  translate([0,0,(baseThickness/2+edgeRadius*2)-baseCutAt-1])
  union()
  {
    if(motiveNr == 1)
    {
      themeMotive(motiveListA);
    }

    if(motiveNr == 2)
    {
      themeMotive(motiveListB);
    }
  }
  /* themeMotive(fileMotive2); */
}
yoyoThemeBase(motiveNr = 0);

if(showBase)
{
  translate([0,0,0])
  yoyoBase();
}

if(showThemeBaseNr)
{
  /* rotate([0,180,0])  */
  yoyoThemeBase(showThemeBaseNr);
}

if(showYoyoBuild)
{
  rotate([0,180,0]) translate([0,0,-44]) union()
  {
  translate([0,0,0]) yoyoBase();
  rotate([0,0,0]) yoyoThemeBase();
  }
}
