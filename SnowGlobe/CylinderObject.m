//
//  CylinderObject.m
//  SnowGlobe
//
//  Created by Winnie Zeng on 4/28/14.
//  Copyright (c) 2014 Winnie Zeng. All rights reserved.
//

#import "CylinderObject.h"
#import "math.h"
#define STRINGIFY(A) #A
#import "CylinderShader.vsh"
#import "CylinderShader.fsh"

@implementation CylinderObject

- (id) loadObject
{
    _scale = 1.0f;
    _coord = GLKVector3Make(0.0f, 0.0f, 0.0f);
    _r1 = 0.5;
    _r2 = 0.8;
    _h = 0.4;
    // 133;94;66 wood color
    
    [self cylinderData];
    [self loadShader];
    
    return self;
}


- (void) cylinderData
{
    const int segments = 500;
    int size = segments * 2;
    _num = size;
    _vertices = malloc(3 * size * sizeof(float));
    _normals = malloc(3 * size * sizeof(float));
    _texcoords = malloc(2 * size * sizeof(float));
    
    float phi = 0.0f, dphi = 2 * M_PI / (segments - 1);
    float Nx = _r1 - _r2, Ny = _h;
    float N = sqrtf(Nx * Nx + Ny * Ny);
    Nx /= N;
    Ny /= N;
    int k = 0;
    float cosphi, sinphi, cosphi2, sinphi2;
    for (int i = 0; i < segments; i++)
    {
        cosphi = cosf(phi);
        sinphi = sinf(phi);
        cosphi2 = cosf(phi + dphi/2);
        sinphi2 = sinf(phi + dphi/2);
        _vertices[k] = -_h/2;
        _vertices[k+1] = cosphi * _r1;
        _vertices[k+2] = sinphi * _r1;
        _normals[k] = Nx;
        _normals[k+1] = Ny * cosphi;
        _normals[k+2] = Ny * sinphi;
        k += 3;
        _vertices[k] = _h/2;
        _vertices[k+1] = cosphi2 * _r2;
        _vertices[k+2] = sinphi2 * _r2;
        _normals[k] = Nx;
        _normals[k+1] = Ny * cosphi2;
        _normals[k+2] = Ny * sinphi2;
        k += 3;
        phi += dphi;
    }
}


- (void) loadShader
{
    // Load Shader
    self.shaderProcessor = [[ShaderProcessor alloc] init];
    // Create the GLSL program
    _program = [self.shaderProcessor BuildProgram:CylinderShaderV with:CylinderShaderF];
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
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, _num);
    
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
