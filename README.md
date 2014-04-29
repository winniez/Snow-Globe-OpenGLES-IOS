#Final Project for CSCI 5239
Spring 2014
Xinying Zeng


The project build a animated snow globe on IOS with OpenGL ES 2.0.
It has:
### snow particle animation
A sprite particle system is built to render snow.

See "SnowParticleObject.h/m" for the object and "SnowShader.vsh/fsh".

### snow accumulation effect
The house and the ground is rendered in 2 pass. 

First pass render the primitives as usual.

Second pass use alpha blending to render the accumulated snow. The alpha value increase as snow time increase. 

See "Shader.vsh/fsh".

Normal vector is used to determine if a surface will have accumulated snow.  

if (aNormal.y > 0.1), the surface will have snow accumulated on it.

The terriable thing is I tried dozens of house models and can not find a single one with right normals. For some roof surface, the normal vector has negative Y value and the snow accumulation and lighting on such surfaces don't work right. 

### a transparent sphere

Use alpha blending to draw a transparent glass sphere.
See "GlassSphereShader.vsh/fsh".





