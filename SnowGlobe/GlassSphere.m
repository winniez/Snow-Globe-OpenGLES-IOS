//
//  GlassSphere.m
//  SnowGlobe
//
//  Created by Winnie Zeng on 4/27/14.
//  Copyright (c) 2014 Winnie Zeng. All rights reserved.
//

#import "GlassSphere.h"
#import "math.h"
#define STRINGIFY(A) #A
#import "GlassSphereShader.vsh"
#import "GlassSphereShader.fsh"

@implementation GlassSphere
- (id) loadObject
{
    
    // Load texture
    
    _scale = 1.0f;
    _coord = GLKVector3Make(0.0f, 0.0f, 0.0f);
    
    [self sphereData];
    [self loadShader];
    
    return self;
}

- (void) loadShader
{
    // Load Shader
    self.shaderProcessor = [[ShaderProcessor alloc] init];
    // Create the GLSL program
    _program = [self.shaderProcessor BuildProgram:GlassSphereShaderV with:GlassSphereShaderF];
    glUseProgram(_program);
    // Extract the attribute handles
    _attributes.aVertex = glGetAttribLocation(_program, "aVertex");
    _attributes.aNormal = glGetAttribLocation(_program, "aNormal");
    _attributes.aTexture = glGetAttribLocation(_program, "aTexture");
    
    // Extract the uniform handles
    _uniforms.uProjectionMatrix = glGetUniformLocation(_program, "uProjectionMatrix");
    _uniforms.uModelViewMatrix = glGetUniformLocation(_program, "uModelViewMatrix");
    _uniforms.uNormalMatrix = glGetUniformLocation(_program, "uNormalMatrix");
    _uniforms.uAmbient = glGetUniformLocation(_program, "uAmbient");
    _uniforms.uDiffuse = glGetUniformLocation(_program, "uDiffuse");
    _uniforms.uSpecular = glGetUniformLocation(_program, "uSpecular");
    _uniforms.uExponent = glGetUniformLocation(_program, "uExponent");
    _uniforms.uTexture = glGetUniformLocation(_program, "uTexture");
    glUseProgram(0);
}

- (void) sphereData
{
    int i,j;
    double radius = 1.0f;
    int stacks = 64;
    int slices = 128;
    int size = stacks * (slices) * 2;
    _num = size;
    _vertices = malloc(3 * size * sizeof(float));
    _normals = malloc(3 * size * sizeof(float));
    _texcoords = malloc(2 * size * sizeof(float));
    int k = 0, k2 = 0;
    for (j = 0; j < stacks; j++) {
        double latitude1 = (M_PI/stacks) * j - M_PI_2;
        double latitude2 = (M_PI/stacks) * (j+1) - M_PI_2;
        double sinLat1 = sin(latitude1);
        double cosLat1 = cos(latitude1);
        double sinLat2 = sin(latitude2);
        double cosLat2 = cos(latitude2);
        for (i = 0; i < slices; i++) {
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
            k2 += 2;
            k += 3;
            _normals[k] =  (float)x1;
            _normals[k+1] =  (float)y1;
            _normals[k+2] =  (float)z1;
            _vertices[k] =  (float)(radius*x1);
            _vertices[k+1] =  (float)(radius*y1);
            _vertices[k+2] =  (float)(radius*z1);
            k2 += 2;
            k += 3;
        }
    }
}


- (void) loadTexture:(NSString *)fileName Index : (int)index
{
}

- (void) displayWith : (GLKMatrix4) projectionMatrix
            MVMatrix :(GLKMatrix4) modelViewMatrix
             NMatrix :(GLKMatrix3) normalMatrix
{
    // transform
    GLKMatrix4 mvMatrix = GLKMatrix4TranslateWithVector3(modelViewMatrix, _coord);
    mvMatrix = GLKMatrix4Scale(mvMatrix, _scale, _scale, _scale);
    
    GLKMatrix3 norMatrix = GLKMatrix3Identity;
    bool isInvertible;
    norMatrix = GLKMatrix4GetMatrix3(GLKMatrix4InvertAndTranspose(mvMatrix, &isInvertible));
    
    // render
    glUseProgram(_program);
    glUniformMatrix4fv(_uniforms.uProjectionMatrix, 1, 0, projectionMatrix.m);
    glUniformMatrix4fv(_uniforms.uModelViewMatrix, 1, 0, mvMatrix.m);
    glUniformMatrix3fv(_uniforms.uNormalMatrix, 1, 0, norMatrix.m);
    
    // Enable Attributes
    glEnableVertexAttribArray(_attributes.aVertex);
    glEnableVertexAttribArray(_attributes.aNormal);
    glEnableVertexAttribArray(_attributes.aTexture);
    glVertexAttribPointer(_attributes.aVertex, 3, GL_FLOAT, GL_FALSE, 0, _vertices);
    glVertexAttribPointer(_attributes.aNormal, 3, GL_FLOAT, GL_FALSE, 0, _normals);
    glVertexAttribPointer(_attributes.aTexture, 2,  GL_FLOAT, GL_FALSE, 0, _texcoords);
    glEnable (GL_BLEND);
    
    glBlendFunc (GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
    glDepthMask(0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, _num);
    glDisable(GL_BLEND);
     glDepthMask(1);
    // Disable Attributes
    glDisableVertexAttribArray(_attributes.aVertex);
    glDisableVertexAttribArray(_attributes.aNormal);
    glDisableVertexAttribArray(_attributes.aTexture);
    glUseProgram(0);
    
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
