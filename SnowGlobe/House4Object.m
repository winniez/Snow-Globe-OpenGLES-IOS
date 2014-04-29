//
//  House4Object.m
//  SnowGlobe
//
//  Created by Winnie Zeng on 4/26/14.
//  Copyright (c) 2014 Winnie Zeng. All rights reserved.
//

#import "House4Object.h"
#import "med_house_finalMTL.h"
#import "med_house_finalOBJ.h"
#define STRINGIFY(A) #A
#include "Shader.vsh"
#include "Shader.fsh"
@implementation House4Object
-(id) loadObject : (float) stoptime
{
    _scale = 1.0f;
    _coord = GLKVector3Make(0.0f, 0.0f, 0.0f);
    _stoptime = stoptime;
    // Initialize Class Objects
    self.shaderProcessor = [[ShaderProcessor alloc] init];
    textureFiles = [NSArray arrayWithObjects:@"Bordersmed_house_final1.jpg",
                    @"Floormed_house_final1.jpg",
                    @"Wallsmed_house_final1.jpg",
                    @"Roofmed_house_final1.jpg",
                    @"Pillarsmed_house_final1.jpg",
                    @"Windowsmed_house_final1.jpg",
                    @"Windowsmed_house_final2.jpg", nil];
    
    // Load textures
    [self loadTexture :(NSString *)textureFiles[0] Index : 1];
    [self loadTexture :(NSString *)textureFiles[1] Index : 2];
    [self loadTexture :(NSString *)textureFiles[2] Index : 3];
    [self loadTexture :(NSString *)textureFiles[3] Index : 4];
    [self loadTexture :(NSString *)textureFiles[4] Index : 5];
    [self loadTexture :(NSString *)textureFiles[5] Index : 6];
    [self loadTexture :(NSString *)textureFiles[6] Index : 7];
    
    
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
    /*
     NSLog(@"num of vertices %d",  (int)(sizeof(med_house_finalOBJVerts)/sizeof(float)/3));
     NSLog(@"num of normals %d",  (int)(sizeof(med_house_finalOBJNormals)/sizeof(float)/3));
     NSLog(@"num of tex coords %d",  (int)(sizeof(med_house_finalOBJTexCoords)/sizeof(float)/2));
     */
    return self;
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
    glUniformMatrix4fv(_uniforms.uProjectionMatrix, 1, 0, projectionMatrix.m);
    glUniformMatrix4fv(_uniforms.uModelViewMatrix, 1, 0, modelViewMatrix.m);
    glUniformMatrix3fv(_uniforms.uNormalMatrix, 1, 0, normalMatrix.m);
    
    glUniform3f(_uniforms.uAmbient, ambient.x, ambient.y, ambient.z);
    glUniform3f(_uniforms.uDiffuse, diffuse.x, diffuse.y, diffuse.z);
    glUniform3f(_uniforms.uSpecular, specular.x, specular.y, specular.z);
    glUniform3f(_uniforms.uEyeDir, eyedir.x, eyedir.y, eyedir.z);
    glUniform1f(_uniforms.uExponent, exponent);
    
    // Enable Attributes
    glEnableVertexAttribArray(_attributes.aVertex);
    glEnableVertexAttribArray(_attributes.aNormal);
    glEnableVertexAttribArray(_attributes.aTexture);
    
    // Load OBJ Data
    glVertexAttribPointer(_attributes.aVertex, 3, GL_FLOAT, GL_FALSE, 0, med_house_finalOBJVerts);
    glVertexAttribPointer(_attributes.aNormal, 3, GL_FLOAT, GL_FALSE, 0, med_house_finalOBJNormals);
    glVertexAttribPointer(_attributes.aTexture, 2, GL_FLOAT, GL_FALSE, 0, med_house_finalOBJTexCoords);
    
    // Load MTL Data
    for(int i=1; i<med_house_finalMTLNumMaterials; i++)
    {
        glEnable(GL_TEXTURE_2D);
        glBindTexture(GL_TEXTURE_2D, _textures[i]);
        /*
        glUniform3f(_uniforms.uAmbient, med_house_finalMTLAmbient[i][0], med_house_finalMTLAmbient[i][1], med_house_finalMTLAmbient[i][2]);
        glUniform3f(_uniforms.uDiffuse, med_house_finalMTLDiffuse[i][0], med_house_finalMTLDiffuse[i][1], med_house_finalMTLDiffuse[i][2]);
        glUniform3f(_uniforms.uSpecular, med_house_finalMTLSpecular[i][0], med_house_finalMTLSpecular[i][1], med_house_finalMTLSpecular[i][2]);
        glUniform1f(_uniforms.uExponent, med_house_finalMTLExponent[i]);
         */
        // Attach Texture
        glUniform1i(_uniforms.uTexture, 0);
        glEnable(GL_BLEND);
        // Draw scene by material group
        glDrawArrays(GL_TRIANGLES, med_house_finalMTLFirst[i], med_house_finalMTLCount[i]);
        glDisable(GL_BLEND);
        glDisable(GL_TEXTURE_2D);
    }
    
    // Disable Attributes
    glDisableVertexAttribArray(_attributes.aVertex);
    glDisableVertexAttribArray(_attributes.aNormal);
    glDisableVertexAttribArray(_attributes.aTexture);
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
