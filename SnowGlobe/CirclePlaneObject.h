//
//  CirclePlaneObject.h
//  SnowGlobe
//
//  Created by Winnie Zeng on 4/28/14.
//  Copyright (c) 2014 Winnie Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#import "Utility.h"

// Shaders
#import "ShaderProcessor.h"

@interface CirclePlaneObject : NSObject
{
    // Render
    GLuint  _program;
    
    struct AttributeHandles _attributes;
    struct UniformHandles   _uniforms;
    
    GLuint  _texture;
    NSArray *textureFiles;
    
    GLKVector3      _coord;
    GLfloat         _scale;
    float           _stoptime;
    float           _deltaY;
    
    // Data
    float*      _vertices;
    float*      _normals;
    float*      _texcoords;
    int         _num;
}

@property (strong, nonatomic) ShaderProcessor* shaderProcessor;

- (id) loadObject: (float) stoptime DeltaSnow :(float)dY;
- (void) loadShader;
- (GLuint) loadTexture:(NSString *)fileName;

- (void) displayWith : (GLKMatrix4) projectionMatrix
            MVMatrix :(GLKMatrix4) modelViewMatrix
             NMatrix :(GLKMatrix3) normalMatrix
              Ambient: (GLKVector3) ambient
             Diffuse : (GLKVector3) diffuse
             Specular: (GLKVector3) specular
               EyeDir: (GLKVector3) eyedir
            Exponent : (float) exponent
          CurrentTime: (float) time;

- (void) circleData : (int) num_vertex;
- (void) setCoord : (GLKVector3) newcoord;
- (void) setScale : (GLfloat) scale;
@end
