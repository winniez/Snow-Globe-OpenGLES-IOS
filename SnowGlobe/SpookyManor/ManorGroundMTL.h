// Created with mtl2opengl.pl

/*
source files: ./ManorGround.obj, ./ManorGround.mtl
materials: 5

Name: Preview
Ka: 0.000, 0.000, 0.000
Kd: 0.437, 0.461, 0.480
Ks: 0.146, 0.165, 0.041
Ns: 50.000

Name: 10_-_Tree
Ka: 0.000, 0.000, 0.000
Kd: 0.000, 0.000, 0.000
Ks: 0.204, 0.204, 0.204
Ns: 10.000

Name: 08_-_RustyFence
Ka: 0.000, 0.000, 0.000
Kd: 0.000, 0.000, 0.000
Ks: 0.137, 0.137, 0.137
Ns: 10.000

Name: 09_-_Stone
Ka: 0.000, 0.000, 0.000
Kd: 0.000, 0.000, 0.000
Ks: 0.361, 0.361, 0.361
Ns: 10.000

Name: 07_-_Ground
Ka: 0.000, 0.000, 0.000
Kd: 0.000, 0.000, 0.000
Ks: 0.137, 0.137, 0.137
Ns: 10.000

*/


int ManorGroundMTLNumMaterials = 5;

int ManorGroundMTLFirst [5] = {
0,
0,
32901,
287733,
313173,
};

int ManorGroundMTLCount [5] = {
0,
32901,
254832,
25440,
23814,
};

float ManorGroundMTLAmbient [5][3] = {
0.000,0.000,0.000,
0.000,0.000,0.000,
0.000,0.000,0.000,
0.000,0.000,0.000,
0.000,0.000,0.000,
};

float ManorGroundMTLDiffuse [5][3] = {
0.437,0.461,0.480,
0.000,0.000,0.000,
0.000,0.000,0.000,
0.000,0.000,0.000,
0.000,0.000,0.000,
};

float ManorGroundMTLSpecular [5][3] = {
0.146,0.165,0.041,
0.204,0.204,0.204,
0.137,0.137,0.137,
0.361,0.361,0.361,
0.137,0.137,0.137,
};

float ManorGroundMTLExponent [5] = {
50.000,
10.000,
10.000,
10.000,
10.000,
};

