//
//  CylinderObject.h
//  SnowGlobe
//
//  Created by Winnie Zeng on 4/28/14.
//  Copyright (c) 2014 Winnie Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utility.h"

// Shaders
#import "ShaderProcessor.h"


@interface CylinderObject : NSObject
{
    // Render
    GLuint  _program;
    
    struct AttributeHandles _attributes;
    struct UniformHandles   _uniforms;
    
    GLuint  _texture;
    NSArray *textureFiles;
    
    GLKVector3      _coord;
    GLfloat         _scale;
    GLKVector3      _color;
    
    // Data
    float*      _vertices;
    float*      _normals;
    float*      _texcoords;
    float*      _vertices2;
    float*      _normals2;
    float*      _texcoords2;
    int         _num;
    int         _num2;
    float       _r1;
    float       _r2;
    float       _h;
}

@property (strong, nonatomic) ShaderProcessor* shaderProcessor;

- (id) loadObject;
- (void) loadShader;
- (GLuint) loadTexture:(NSString *)fileName;

- (void) displayWith : (GLKMatrix4) projectionMatrix
            MVMatrix :(GLKMatrix4) modelViewMatrix
             NMatrix :(GLKMatrix3) normalMatrix
              Ambient: (GLKVector3) ambient
             Diffuse : (GLKVector3) diffuse
             Specular: (GLKVector3) specular
               EyeDir: (GLKVector3) eyedir
            Exponent : (float) exponent;

- (void) cylinderData;
- (void) setCoord : (GLKVector3) newcoord;
- (void) setScale : (GLfloat) scale;
@end
