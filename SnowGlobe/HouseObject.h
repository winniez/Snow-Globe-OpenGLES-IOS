//
//  HouseObject.h
//  SnowGlobe
//
//  Created by Winnie Zeng on 4/26/14.
//  Copyright (c) 2014 Winnie Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#import "Utility.h"
#define NUM_MTL 8

// Shaders
#import "ShaderProcessor.h"

@interface HouseObject : NSObject
{
    // Render
    GLuint  _program;
    
    struct AttributeHandles _attributes;
    struct UniformHandles   _uniforms;
    
    GLuint  _textures[NUM_MTL];
    NSArray *textureFiles;
    
    GLKVector3      _coord;
    GLfloat         _scale;
}

@property (strong, nonatomic) ShaderProcessor* shaderProcessor;

- (id) loadObject;

- (void) loadTexture:(NSString *)fileName Index : (int)index;

- (void) displayWith : (GLKMatrix4) projectionMatrix
            MVMatrix :(GLKMatrix4) modelViewMatrix
             NMatrix :(GLKMatrix3) normalMatrix;

- (void) setCoord : (GLKVector3) newcoord;
- (void) setScale : (GLfloat) scale;

@end
