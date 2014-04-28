//
//  GlassSphere.h
//  SnowGlobe
//
//  Created by Winnie Zeng on 4/27/14.
//  Copyright (c) 2014 Winnie Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#import "Utility.h"

// Shaders
#import "ShaderProcessor.h"


@interface GlassSphere : NSObject
{
    // Render
    GLuint  _program;
    
    struct AttributeHandles _attributes;
    struct UniformHandles   _uniforms;
    
    GLuint  _texture;
    NSArray *textureFiles;
    
    GLKVector3      _coord;
    GLfloat         _scale;
    
    // Data
    float*      _vertices;
    float*      _normals;
    float*      _texcoords;
    
}
- (id) loadObject;
- (void) loadShader;
- (void) loadTexture:(NSString *)fileName Index : (int)index;

- (void) displayWith : (GLKMatrix4) projectionMatrix
            MVMatrix :(GLKMatrix4) modelViewMatrix
             NMatrix :(GLKMatrix3) normalMatrix;

- (void) sphereData;
- (void) setCoord : (GLKVector3) newcoord;
- (void) setScale : (GLfloat) scale;
@end
