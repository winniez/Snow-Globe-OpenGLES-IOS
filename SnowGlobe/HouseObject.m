//
//  HouseObject.m
//  SnowGlobe
//
//  Created by Winnie Zeng on 4/26/14.
//  Copyright (c) 2014 Winnie Zeng. All rights reserved.
//

#import "HouseObject.h"
// Models
#import "ManorOBJ.h"
#import "ManorMTL.h"
#define STRINGIFY(A) #A
#include "Shader.vsh"
#include "Shader.fsh"
@implementation HouseObject

-(id) loadObject
{
    // Initialize Class Objects
    self.shaderProcessor = [[ShaderProcessor alloc] init];
    textureFiles = [NSArray arrayWithObjects:@"BordersManor1.jpg",
                    @"FloorManor1.jpg",
                    @"WallsManor1.jpg",
                    @"RoofManor1.jpg",
                    @"PillarsManor1.jpg",
                    @"WindowsManor1.jpg",
                    @"WindowsManor2.jpg", nil];
    
    // Load textures
    [self loadTexture :(NSString *)textureFiles[0] Index : 1];
    [self loadTexture :(NSString *)textureFiles[1] Index : 2];
    [self loadTexture :(NSString *)textureFiles[2] Index : 3];
    [self loadTexture :(NSString *)textureFiles[3] Index : 4];
    [self loadTexture :(NSString *)textureFiles[4] Index : 5];
    [self loadTexture :(NSString *)textureFiles[5] Index : 6];
    [self loadTexture :(NSString *)textureFiles[6] Index : 7];
    
    _scale = 1.0f;
    _coord = GLKVector3Make(0.0f, 0.0f, 0.0f);
    
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
    glUseProgram(0);
    /*
    NSLog(@"num of vertices %d",  (int)(sizeof(ManorOBJVerts)/sizeof(float)/3));
    NSLog(@"num of normals %d",  (int)(sizeof(ManorOBJNormals)/sizeof(float)/3));
    NSLog(@"num of tex coords %d",  (int)(sizeof(ManorOBJTexCoords)/sizeof(float)/2));
    */
    return self;
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
    
    // Load OBJ Data
    glVertexAttribPointer(_attributes.aVertex, 3, GL_FLOAT, GL_FALSE, 0, ManorOBJVerts);
    glVertexAttribPointer(_attributes.aNormal, 3, GL_FLOAT, GL_FALSE, 0, ManorOBJNormals);
    glVertexAttribPointer(_attributes.aTexture, 2, GL_FLOAT, GL_FALSE, 0, ManorOBJTexCoords);
    
    // Load MTL Data
    for(int i=1; i<ManorMTLNumMaterials; i++)
    {
        glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_BLEND);
        glEnable(GL_TEXTURE_2D);
        glBindTexture(GL_TEXTURE_2D, _textures[i]);
        
        glUniform3f(_uniforms.uAmbient, ManorMTLAmbient[i][0], ManorMTLAmbient[i][1], ManorMTLAmbient[i][2]);
        glUniform3f(_uniforms.uDiffuse, ManorMTLDiffuse[i][0], ManorMTLDiffuse[i][1], ManorMTLDiffuse[i][2]);
        glUniform3f(_uniforms.uSpecular, ManorMTLSpecular[i][0], ManorMTLSpecular[i][1], ManorMTLSpecular[i][2]);
        glUniform1f(_uniforms.uExponent, ManorMTLExponent[i]);
        // Attach Texture
        glUniform1i(_uniforms.uTexture, 0);
        glEnable(GL_BLEND);
        glBlendFunc(GL_ONE, GL_ZERO);
        // Draw scene by material group
        glDrawArrays(GL_TRIANGLES, ManorMTLFirst[i], ManorMTLCount[i]);
        glDisable(GL_BLEND);
        glDisable(GL_TEXTURE_2D);
    }
    
    // Disable Attributes
    glDisableVertexAttribArray(_attributes.aVertex);
    glDisableVertexAttribArray(_attributes.aNormal);
    glDisableVertexAttribArray(_attributes.aTexture);
    glUseProgram(0);
}


- (void)loadTexture:(NSString *)fileName Index : (int)index
{
    NSDictionary* options = @{[NSNumber numberWithBool:YES] : GLKTextureLoaderOriginBottomLeft};
    
    NSError* error;
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    GLKTextureInfo* texture = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    if(texture == nil)
        NSLog(@"Error loading file: %@", [error localizedDescription]);
    _textures[index] = texture.name;
    //glBindTexture(GL_TEXTURE_2D, texture.name);
    
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
