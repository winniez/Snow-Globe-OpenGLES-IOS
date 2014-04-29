//
//  House4Object.h
//  SnowGlobe
//
//  Created by Winnie Zeng on 4/26/14.
//  Copyright (c) 2014 Winnie Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#import "Utility.h"
#define NUM_MTL 17

// Shaders
#import "ShaderProcessor.h"

@interface House4Object : NSObject
{
    // Render
    GLuint  _program;
    
    struct AttributeHandles _attributes;
    struct UniformHandles   _uniforms;
    
    GLuint  _textures[NUM_MTL];
    NSArray *textureFiles;
    
    GLKVector3      _coord;
    GLfloat         _scale;
    float           _stoptime;
}
@property (strong, nonatomic) ShaderProcessor* shaderProcessor;


- (id) loadObject: (float) stoptime;

- (void) loadTexture:(NSString *)fileName Index : (int)index;

- (void) displayWith : (GLKMatrix4) projectionMatrix
            MVMatrix :(GLKMatrix4) modelViewMatrix
             NMatrix :(GLKMatrix3) normalMatrix
              Ambient: (GLKVector3) ambient
             Diffuse : (GLKVector3) diffuse
             Specular: (GLKVector3) specular
               EyeDir: (GLKVector3) eyedir
            Exponent : (float) exponent
          CurrentTime: (float) time;

- (void) setCoord : (GLKVector3) newcoord;
- (void) setScale : (GLfloat) scale;
@end
