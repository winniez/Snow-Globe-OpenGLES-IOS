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
    _r2 = 1.0f;
    _r1 = _r2 * 1.4f;
    _h = 0.8;
    _color = GLKVector3Make(0.5216f, 0.3686f, 0.2588f);
    // 133;94;66 wood color 0.52157f, 0.3686f, 0.2588f
    [self circleData:1025 Scale:_r1];
    
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
        _vertices[k+1] = -_h/2;
        _vertices[k] = cosphi * _r1;
        _vertices[k+2] = sinphi * _r1;
        _normals[k+1] = Nx;
        _normals[k] = Ny * cosphi;
        _normals[k+2] = Ny * sinphi;
        k += 3;
        _vertices[k+1] = _h/2;
        _vertices[k] = cosphi2 * _r2;
        _vertices[k+2] = sinphi2 * _r2;
        _normals[k+1] = Nx;
        _normals[k] = Ny * cosphi2;
        _normals[k+2] = Ny * sinphi2;
        k += 3;
        phi += dphi;
    }
}

- (void) circleData : (int) num_vertex Scale : (float) r
{
    
    int size = num_vertex;
    float radius = 1.0f * r;
    _num2 = size;
    _vertices2 = malloc(3 * size * sizeof(float));
    _normals2 = malloc(3 * size * sizeof(float));
    _texcoords2 = malloc(2 * size * sizeof(float));
    int outer_num_vertex = num_vertex - 1;
    float angle, cosA, sinA;
    _vertices2[0] = 0.0f; _vertices2[1] = 0.0f; _vertices2[2] = 0.0f;
    _normals2[0] = 0.0f; _normals2[1] = 1.0f; _normals2[2] = 0.0f;
    _texcoords2[0] = 0.5f; _texcoords2[1] = 0.5f;
    for (int i = 0; i < outer_num_vertex; i++)
    {
        angle = (float)((float)i/(float)(outer_num_vertex-1)) * 2.0f * M_PI;
        cosA = cosf(angle); sinA = sinf(angle);
        // vertices
        _vertices2[(i+1)*3] = radius * cosA;
        _vertices2[(i+1)*3+1] = -_h/2;
        _vertices2[(i+1)*3+2] = radius * sinA;
        // normals
        _normals2[(i+1)*3] = 0.0f;
        _normals2[(i+1)*3+1] = 1.0f;
        _normals2[(i+1)*3+2] = 0.0f;
        // texture coordinates
        _texcoords2[(i+1)*2] = (cosA + 1.0f) * 0.5f;
        _texcoords2[(i+1)*2+1] = (sinA + 1.0f) * 0.5f;
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
    _uniforms.uColor = glGetUniformLocation(_program, "uColor");
    glUseProgram(0);
}

- (void) displayWith : (GLKMatrix4) projectionMatrix
            MVMatrix :(GLKMatrix4) modelViewMatrix
             NMatrix :(GLKMatrix3) normalMatrix
              Ambient: (GLKVector3) ambient
             Diffuse : (GLKVector3) diffuse
             Specular: (GLKVector3) specular
               EyeDir: (GLKVector3) eyedir
            Exponent : (float) exponent
{
    // transform
    GLKMatrix4 mvMatrix = GLKMatrix4TranslateWithVector3(modelViewMatrix, _coord);
    mvMatrix = GLKMatrix4Scale(mvMatrix, _scale, _scale, _scale);
    
    GLKMatrix3 norMatrix = GLKMatrix3Identity;
    bool isInvertible;
    norMatrix = GLKMatrix4GetMatrix3(GLKMatrix4InvertAndTranspose(mvMatrix, &isInvertible));
    
    // Uniforms
    glUseProgram(_program);
    glUniformMatrix4fv(_uniforms.uProjectionMatrix, 1, 0, projectionMatrix.m);
    glUniformMatrix4fv(_uniforms.uModelViewMatrix, 1, 0, mvMatrix.m);
    glUniformMatrix3fv(_uniforms.uNormalMatrix, 1, 0, norMatrix.m);
    
    glUniform3f(_uniforms.uAmbient, ambient.x, ambient.y, ambient.z);
    glUniform3f(_uniforms.uDiffuse, diffuse.x, diffuse.y, diffuse.z);
    glUniform3f(_uniforms.uSpecular, specular.x, specular.y, specular.z);
    glUniform3f(_uniforms.uEyeDir, eyedir.x, eyedir.y, eyedir.z);
    glUniform1f(_uniforms.uExponent, exponent);
    glUniform3f(_uniforms.uColor, _color.x, _color.y, _color.z);
    
    // Enable Attributes
    glEnableVertexAttribArray(_attributes.aVertex);
    glEnableVertexAttribArray(_attributes.aNormal);
    glEnableVertexAttribArray(_attributes.aTexture);
    glVertexAttribPointer(_attributes.aVertex, 3, GL_FLOAT, GL_FALSE, 0, _vertices);
    glVertexAttribPointer(_attributes.aNormal, 3, GL_FLOAT, GL_FALSE, 0, _normals);
    glVertexAttribPointer(_attributes.aTexture, 2,  GL_FLOAT, GL_FALSE, 0, _texcoords);
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ZERO);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, _num);
    glDisable(GL_BLEND);
    // Disable Attributes
    glDisableVertexAttribArray(_attributes.aVertex);
    glDisableVertexAttribArray(_attributes.aNormal);
    glDisableVertexAttribArray(_attributes.aTexture);
    
    // Enable Attributes
    glEnableVertexAttribArray(_attributes.aVertex);
    glEnableVertexAttribArray(_attributes.aNormal);
    glEnableVertexAttribArray(_attributes.aTexture);
    glVertexAttribPointer(_attributes.aVertex, 3, GL_FLOAT, GL_FALSE, 0, _vertices2);
    glVertexAttribPointer(_attributes.aNormal, 3, GL_FLOAT, GL_FALSE, 0, _normals2);
    glVertexAttribPointer(_attributes.aTexture, 2,  GL_FLOAT, GL_FALSE, 0, _texcoords2);
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ZERO);
    glDrawArrays(GL_TRIANGLE_FAN, 0, _num2);
    glDisable(GL_BLEND);
    // Disable Attributes
    glDisableVertexAttribArray(_attributes.aVertex);
    glDisableVertexAttribArray(_attributes.aNormal);
    glDisableVertexAttribArray(_attributes.aTexture);

    
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
