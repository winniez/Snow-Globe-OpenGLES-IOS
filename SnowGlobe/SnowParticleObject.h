//
//  SnowParticleObject.h
//  SnowGlobe
//
//  Created by Winnie Zeng on 4/26/14.
//  Copyright (c) 2014 Winnie Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

// Shaders
#import "ShaderProcessor.h"
#import "Utility.h"

#define NUM_PARTICLES 4096

typedef struct Particle
{
    GLKVector3  pStartPosition;
    float       pStartTime;
    float       pVelocityOffset;
    float       pDecayOffset;
    float       pSizeOffset;
    GLKVector3  pColorOffset;
}
Particle;

typedef struct Emitter
{
    Particle    eParticles[NUM_PARTICLES];
    float       eVelocity;
    float       eDecay;
    float       eSize;
    GLKVector3  eColor;
}
Emitter;

@interface SnowParticleObject : NSObject
{
    // Render
    GLuint  _program;
    
    struct ParticleAttributeHandles _attributes;
    struct ParticleUniformHandles   _uniforms;
    
    // Instance variables
    GLKVector3  _gravity;
    float       _life;
    float       _time;
    GLuint      _particleBuffer;
    
    GLuint  _texture;
    
    GLKVector3      _coord;
    GLfloat         _scale;
}

@property (strong, nonatomic) ShaderProcessor* shaderProcessor;
@property (assign) Emitter emitter;

- (id)initWithTexture:(NSString *)fileName;
- (void)loadTexture:(NSString *)fileName;
- (void) loadShader;
- (GLKVector3) generateStartPosition;
- (void)renderWithProjection:(GLKMatrix4)projectionMatrix MVMatrix :(GLKMatrix4) modelViewMatrix;
- (void)updateLifeCycle:(float)timeElapsed;
- (void)loadParticleSystem;

- (void) setCoord : (GLKVector3) newcoord;
- (void) setScale : (GLfloat) scale;

@end
