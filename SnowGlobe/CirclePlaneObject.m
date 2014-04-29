//
//  CirclePlaneObject.m
//  SnowGlobe
//
//  Created by Winnie Zeng on 4/28/14.
//  Copyright (c) 2014 Winnie Zeng. All rights reserved.
//

#import "CirclePlaneObject.h"
#define STRINGIFY(A) #A
#include "Shader.vsh"
#include "Shader.fsh"

@implementation CirclePlaneObject

- (id) loadObject : (float) stoptime DeltaSnow :(float)dY
{
    _scale = 1.0f;
    _coord = GLKVector3Make(0.0f, 0.0f, 0.0f);
    _stoptime = stoptime;
    _deltaY = dY;
    
    [self loadShader];
    _texture = [self loadTexture: @"Grass_Texture_02.jpg"]; //@"grasslight-big.png"];
    [self circleData : 1025];
    return self;
}

- (void) circleData : (int) num_vertex
{
    
    int size = num_vertex;
    float radius = 1.0f;
    _num = size;
    _vertices = malloc(3 * size * sizeof(float));
    _normals = malloc(3 * size * sizeof(float));
    _texcoords = malloc(2 * size * sizeof(float));
    int outer_num_vertex = num_vertex - 1;
    float angle, cosA, sinA;
    _vertices[0] = 0.0f; _vertices[1] = 0.0f; _vertices[2] = 0.0f;
    _normals[0] = 0.0f; _normals[1] = 1.0f; _normals[2] = 0.0f;
    _texcoords[0] = 0.5f; _texcoords[1] = 0.5f;
    for (int i = 0; i < outer_num_vertex; i++)
    {
        angle = (float)((float)i/(float)(outer_num_vertex-1)) * 2.0f * M_PI;
        cosA = cosf(angle); sinA = sinf(angle);
        // vertices
        _vertices[(i+1)*3] = radius * cosA;
        _vertices[(i+1)*3+1] = 0.0f;
        _vertices[(i+1)*3+2] = radius * sinA;
        // normals
        _normals[(i+1)*3] = 0.0f;
        _normals[(i+1)*3+1] = 1.0f;
        _normals[(i+1)*3+2] = 0.0f;
        // texture coordinates
        _texcoords[(i+1)*2] = (cosA + 1.0f) * 0.5f;
        _texcoords[(i+1)*2+1] = (sinA + 1.0f) * 0.5f;
    }
}

- (void) displayWith : (GLKMatrix4) projectionMatrix
            MVMatrix :(GLKMatrix4) modelViewMatrix
             NMatrix :(GLKMatrix3) normalMatrix
              Ambient: (GLKVector3) ambient
             Diffuse : (GLKVector3) diffuse
             Specular: (GLKVector3) specular
               EyeDir: (GLKVector3) eyedir
            Exponent : (float) exponent
          CurrentTime: (float) time
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
    
    glUniform3f(_uniforms.uAmbient, ambient.x, ambient.y, ambient.z);
    glUniform3f(_uniforms.uDiffuse, diffuse.x, diffuse.y, diffuse.z);
    glUniform3f(_uniforms.uSpecular, specular.x, specular.y, specular.z);
    glUniform3f(_uniforms.uEyeDir, eyedir.x, eyedir.y, eyedir.z);
    glUniform1f(_uniforms.uExponent, exponent);
    
    glUniform1f(_uniforms.uTime, time);
    glUniform1f(_uniforms.uStopTime, _stoptime);
    glUniform1f(_uniforms.uDeltaY, _deltaY);
    
    // Enable Attributes
    glEnableVertexAttribArray(_attributes.aVertex);
    glEnableVertexAttribArray(_attributes.aNormal);
    glEnableVertexAttribArray(_attributes.aTexture);
    glVertexAttribPointer(_attributes.aVertex, 3, GL_FLOAT, GL_FALSE, 0, _vertices);
    glVertexAttribPointer(_attributes.aNormal, 3, GL_FLOAT, GL_FALSE, 0, _normals);
    glVertexAttribPointer(_attributes.aTexture, 2,  GL_FLOAT, GL_FALSE, 0, _texcoords);
    
    glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_BLEND);
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, _texture);
    glUniform1f(_uniforms.uMode, 0.0f);
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ZERO);
    glDrawArrays(GL_TRIANGLE_FAN, 0, _num);
    glDisable(GL_BLEND);
    
    // render snow
    glEnable (GL_BLEND);
    glUniform1f(_uniforms.uMode, 2.0f);
    glBlendFunc (GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
    glDepthMask(0);
    glDrawArrays(GL_TRIANGLE_FAN, 0, _num);
    glDisable(GL_BLEND);
    glDepthMask(1);
    glDisable(GL_TEXTURE_2D);
    // Disable Attributes
    glDisableVertexAttribArray(_attributes.aVertex);
    glDisableVertexAttribArray(_attributes.aNormal);
    glDisableVertexAttribArray(_attributes.aTexture);
    glUseProgram(0);
    
}

- (void) loadShader
{
    // Load Shader
    self.shaderProcessor = [[ShaderProcessor alloc] init];
    // Create the GLSL program
    _program = [self.shaderProcessor BuildProgram:ShaderV with:ShaderF];
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
    _uniforms.uTime = glGetUniformLocation(_program, "uTime");
    _uniforms.uStopTime = glGetUniformLocation(_program, "uStopTime");
    _uniforms.uMode = glGetUniformLocation(_program, "uMode");
    _uniforms.uDeltaY = glGetUniformLocation(_program, "uDeltaY");
    glUseProgram(0);
}

- (GLuint) loadTexture:(NSString *)fileName;
{
    NSDictionary* options = @{[NSNumber numberWithBool:YES] : GLKTextureLoaderOriginBottomLeft};
    
    NSError* error;
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    GLKTextureInfo* texture = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    if(texture == nil)
        NSLog(@"Error loading file: %@", [error localizedDescription]);
    return  texture.name;
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
