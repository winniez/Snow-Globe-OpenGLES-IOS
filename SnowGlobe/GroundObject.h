//
//  GroundObject.h
//  SnowGlobe
//
//  Created by Winnie Zeng on 4/26/14.
//  Copyright (c) 2014 Winnie Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#import "Utility.h"
#define NUM_GROUND_MTL 5

// Shaders
#import "ShaderProcessor.h"


@interface GroundObject : NSObject
{
    // Render
    GLuint  _program;
    
    struct AttributeHandles _attributes;
    struct UniformHandles   _uniforms;
    
    GLuint  _textures[NUM_GROUND_MTL];
    NSArray *textureFiles;
    
    GLKVector3      _coord;
    GLfloat         _scale;
    float           _stoptime;
    float           _deltaY;
}


@property (strong, nonatomic) ShaderProcessor* shaderProcessor;

- (id) loadObject: (float) stoptime  DeltaSnow :(float)dY;

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
