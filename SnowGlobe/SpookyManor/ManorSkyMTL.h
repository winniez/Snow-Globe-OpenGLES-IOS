// Created with mtl2opengl.pl

/*
source files: ./ManorSky.obj, ./ManorSky.mtl
materials: 3

Name: Preview
Ka: 0.000, 0.000, 0.000
Kd: 0.615, 0.594, 0.946
Ks: 0.126, 0.012, 0.150
Ns: 50.000

Name: 15_-_Sky
Ka: 0.325, 0.325, 0.325
Kd: 0.000, 0.000, 0.000
Ks: 0.020, 0.020, 0.020
Ns: 10.000

Name: Ground
Ka: 0.000, 0.000, 0.000
Kd: 0.000, 0.000, 0.000
Ks: 0.086, 0.086, 0.086
Ns: 10.000

*/


int ManorSkyMTLNumMaterials = 3;

int ManorSkyMTLFirst [3] = {
0,
0,
1824,
};

int ManorSkyMTLCount [3] = {
0,
1824,
288,
};

float ManorSkyMTLAmbient [3][3] = {
0.000,0.000,0.000,
0.325,0.325,0.325,
0.000,0.000,0.000,
};

float ManorSkyMTLDiffuse [3][3] = {
0.615,0.594,0.946,
0.000,0.000,0.000,
0.000,0.000,0.000,
};

float ManorSkyMTLSpecular [3][3] = {
0.126,0.012,0.150,
0.020,0.020,0.020,
0.086,0.086,0.086,
};

float ManorSkyMTLExponent [3] = {
50.000,
10.000,
10.000,
};

