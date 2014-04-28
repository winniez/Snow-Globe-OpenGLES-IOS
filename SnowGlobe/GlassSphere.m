//
//  GlassSphere.m
//  SnowGlobe
//
//  Created by Winnie Zeng on 4/27/14.
//  Copyright (c) 2014 Winnie Zeng. All rights reserved.
//

#import "GlassSphere.h"
#import "math.h"

@implementation GlassSphere
- (id) loadObject
{
    _scale = 1.0f;
    _coord = GLKVector3Make(0.0f, 0.0f, 0.0f);
    
    [self sphereData];
    [self loadShader];
    
    
    
    
    return self;
}


- (void) sphereData
{
    int i,j;
    double radius = 0.4;
    int stacks = 16;
    int slices = 32;
    int size = stacks * (slices+1) * 2 * 3;
    _vertices = malloc(size*sizeof(float));
    _normals = malloc(size*sizeof(float));
    int k = 0;
    for (j = 0; j < stacks; j++) {
        double latitude1 = (M_PI/stacks) * j - M_PI_2;
        double latitude2 = (M_PI/stacks) * (j+1) - M_PI_2;
        double sinLat1 = sin(latitude1);
        double cosLat1 = cos(latitude1);
        double sinLat2 = sin(latitude2);
        double cosLat2 = cos(latitude2);
        for (i = 0; i <= slices; i++) {
            double longitude = (2*M_PI/slices) * i;
            double sinLong = sin(longitude);
            double cosLong = cos(longitude);
            double x1 = cosLong * cosLat1;
            double y1 = sinLong * cosLat1;
            double z1 = sinLat1;
            double x2 = cosLong * cosLat2;
            double y2 = sinLong * cosLat2;
            double z2 = sinLat2;
            _normals[k] =  (float)x2;
            _normals[k+1] =  (float)y2;
            _normals[k+2] =  (float)z2;
            _vertices[k] =  (float)(radius*x2);
            _vertices[k+1] =  (float)(radius*y2);
            _vertices[k+2] =  (float)(radius*z2);
            k += 3;
            _normals[k] =  (float)x1;
            _normals[k+1] =  (float)y1;
            _normals[k+2] =  (float)z1;
            _vertices[k] =  (float)(radius*x1);
            _vertices[k+1] =  (float)(radius*y1);
            _vertices[k+2] =  (float)(radius*z1);
            k += 3;
        }
    }
}

- (void) loadShader
{
}
- (void) loadTexture:(NSString *)fileName Index : (int)index
{
}

- (void) displayWith : (GLKMatrix4) projectionMatrix
            MVMatrix :(GLKMatrix4) modelViewMatrix
             NMatrix :(GLKMatrix3) normalMatrix
{
    
    glEnable(GL_CULL_FACE);
    
    glDisable(GL_CULL_FACE);
}


- (void) setCoord : (GLKVector3) newcoord
{
    _coord.x = newcoord.x;
    _coord.y = newcoord.y;
    _coord.z = newcoord.z;
    
}
- (void) setScale : (GLfloat) scale
{
    _scale = scale;
}
@end
