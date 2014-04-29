//
//  SnowParticleObject.m
//  SnowGlobe
//
//  Created by Winnie Zeng on 4/26/14.
//  Copyright (c) 2014 Winnie Zeng. All rights reserved.
//

#import "SnowParticleObject.h"

#define STRINGIFY(A) #A
#include "SnowShader.vsh"
#include "SnowShader.fsh"

@implementation SnowParticleObject

-(id) initWithTexture:(NSString *)fileName StopTime: (float) stoptime
{
    if(self = [super init])
    {
        // Initialize variables
        _gravity = GLKVector3Make(0.0f, 0.0f, 0.0f);
        _life = 0.0f;
        _stoptime = stoptime;
        _particleBuffer = 0;
        _scale = 1.0f;
        _coord = GLKVector3Make(0.0f, 0.0f, 0.0f);
        // Load Shader
        [self loadShader];
        // Load Texture
        [self loadTexture:fileName];
        // Load Particle System
        [self loadParticleSystem];
    }
    return self;
}

- (void) loadShader
{
    // Load Shader
    self.shaderProcessor = [[ShaderProcessor alloc] init];
    // Create the GLSL program
    _program = [self.shaderProcessor BuildProgram:SnowShaderV with:SnowShaderF];
    glUseProgram(_program);
    // Attributes
    _attributes.a_pStartPosition = glGetAttribLocation(_program, "a_pStartPosition");
    _attributes.a_pStartTime = glGetAttribLocation(_program, "a_pStartTime");
    _attributes.a_pVelocityOffset = glGetAttribLocation(_program, "a_pVelocityOffset");
    _attributes.a_pDecayOffset = glGetAttribLocation(_program, "a_pDecayOffset");
    _attributes.a_pSizeOffset = glGetAttribLocation(_program, "a_pSizeOffset");
    _attributes.a_pColorOffset = glGetAttribLocation(_program, "a_pColorOffset");
    
    // Uniforms
    _uniforms.u_ProjectionMatrix = glGetUniformLocation(_program, "u_ProjectionMatrix");
    _uniforms.u_ModelViewMatrix = glGetUniformLocation(_program, "u_ModelViewMatrix");
    _uniforms.u_Gravity = glGetUniformLocation(_program, "u_Gravity");
    _uniforms.u_Time = glGetUniformLocation(_program, "u_Time");
    _uniforms.u_StopTime = glGetUniformLocation(_program, "u_StopTime");
    _uniforms.u_eDecay = glGetUniformLocation(_program, "u_eDecay");
    _uniforms.u_eSize = glGetUniformLocation(_program, "u_eSize");
    _uniforms.u_eColor = glGetUniformLocation(_program, "u_eColor");
    _uniforms.u_Texture = glGetUniformLocation(_program, "u_Texture");
    _uniforms.u_eStopPlaneY = glGetUniformLocation(_program, "u_eStopPlaneY");
    glUseProgram(0);
}

- (void)loadParticleSystem
{
    Emitter newEmitter = {0.0f};
    
    // Offset bounds
    float oVelocity = 0.50f;    // Speed
    float oDecay = 2.0f;       // Time
    float oSize = 2.00f;        // Pixels
    float oColor = 0.00f;       // 0.5 = 50% shade offset
    float oTime = 5.00f;
    
    // Load Particles
    for(int i=0; i<NUM_PARTICLES; i++)
    {
        // Assign random offsets within bounds
        newEmitter.eParticles[i].pStartPosition = [self generateStartPosition];
        //GLKVector3Make([self randomFloatBetween:-1.0f and:1.0f], [self randomFloatBetween:1.5f and:2.0f], [self randomFloatBetween:-1.0f and:1.0f]);
        newEmitter.eParticles[i].pVelocityOffset = [self randomFloatBetween:-oVelocity and:oVelocity];
        newEmitter.eParticles[i].pDecayOffset = [self randomFloatBetween:-oDecay and:oDecay];
        newEmitter.eParticles[i].pSizeOffset = [self randomFloatBetween:-oSize and:oSize];
        float r = [self randomFloatBetween:-oColor and:oColor];
        float g = [self randomFloatBetween:-oColor and:oColor];
        float b = [self randomFloatBetween:-oColor and:oColor];
        newEmitter.eParticles[i].pColorOffset = GLKVector3Make(r, g, b);
        newEmitter.eParticles[i].pStartTime = [self randomFloatBetween:0.0f and:oTime];
    }
    
    // Load Properties
    newEmitter.eDecay = 16.00f;                                  // Explosion decay
    newEmitter.eSize = 8.00f;                                 // Fragment size
    newEmitter.eStopPlaneY = -0.3f;                             // 
    newEmitter.eColor = GLKVector3Make(1.00f, 1.00f, 1.00f);    // Fragment color
    
    // Set global factors
    _life = newEmitter.eDecay + oDecay;                         // Simulation lifetime
    
    float drag = 10.00f;                                        // Drag (air resistance)
    _gravity = GLKVector3Make(0.00f, -9.81f*(1.0f/drag), 0.0f); // World gravity
    
    // Set Emitter & VBO
    self.emitter = newEmitter;
    
    glGenBuffers(1, &_particleBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _particleBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(self.emitter.eParticles), self.emitter.eParticles, GL_STATIC_DRAW);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
}


- (void)renderWithProjection:(GLKMatrix4)projectionMatrix MVMatrix :(GLKMatrix4) modelViewMatrix CurrentTime: (float) time
{
    // transform
    GLKMatrix4 mvMatrix = GLKMatrix4TranslateWithVector3(modelViewMatrix, _coord);
    mvMatrix = GLKMatrix4Scale(mvMatrix, _scale, _scale, _scale);
    
    GLKMatrix3 norMatrix = GLKMatrix3Identity;
    bool isInvertible;
    norMatrix = GLKMatrix4GetMatrix3(GLKMatrix4InvertAndTranspose(mvMatrix, &isInvertible));
    
    glUseProgram(_program);
    // Switch Buffers
    glBindBuffer(GL_ARRAY_BUFFER, _particleBuffer);
    
    // Uniforms
    glUniformMatrix4fv(_uniforms.u_ProjectionMatrix, 1, 0, projectionMatrix.m);
    glUniformMatrix4fv(_uniforms.u_ModelViewMatrix, 1, 0, mvMatrix.m);
    glUniform3f(_uniforms.u_Gravity, _gravity.x, _gravity.y, _gravity.z);
    glUniform1f(_uniforms.u_Time, time);
    glUniform1f(_uniforms.u_StopTime, _stoptime);
    glUniform1f(_uniforms.u_eDecay, self.emitter.eDecay);
    glUniform1f(_uniforms.u_eSize, self.emitter.eSize);
    glUniform3f(_uniforms.u_eColor, self.emitter.eColor.r, self.emitter.eColor.g, self.emitter.eColor.b);
    glUniform1i(_uniforms.u_Texture, 0);
    glUniform1f(_uniforms.u_eStopPlaneY, self.emitter.eStopPlaneY);
    
    // Attributes
    glEnableVertexAttribArray(_attributes.a_pStartPosition);
    glEnableVertexAttribArray(_attributes.a_pVelocityOffset);
    glEnableVertexAttribArray(_attributes.a_pDecayOffset);
    glEnableVertexAttribArray(_attributes.a_pVelocityOffset);
    glEnableVertexAttribArray(_attributes.a_pSizeOffset);
    glEnableVertexAttribArray(_attributes.a_pColorOffset);
    
    glVertexAttribPointer(_attributes.a_pStartPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Particle), (void*)(offsetof(Particle, pStartPosition)));
    glVertexAttribPointer(_attributes.a_pStartTime, 1, GL_FLOAT, GL_FALSE, sizeof(Particle), (void*)(offsetof(Particle, pStartTime)));
    glVertexAttribPointer(_attributes.a_pVelocityOffset, 1, GL_FLOAT, GL_FALSE, sizeof(Particle), (void*)(offsetof(Particle, pVelocityOffset)));
    glVertexAttribPointer(_attributes.a_pDecayOffset, 1, GL_FLOAT, GL_FALSE, sizeof(Particle), (void*)(offsetof(Particle, pDecayOffset)));
    glVertexAttribPointer(_attributes.a_pSizeOffset, 1, GL_FLOAT, GL_FALSE, sizeof(Particle), (void*)(offsetof(Particle, pSizeOffset)));
    glVertexAttribPointer(_attributes.a_pColorOffset, 3, GL_FLOAT, GL_FALSE, sizeof(Particle), (void*)(offsetof(Particle, pColorOffset)));
    
    // Draw particles
    glEnable(GL_POINT_SPRITE_OES);
    glTexEnvi(GL_POINT_SPRITE_OES,GL_COORD_REPLACE_OES,GL_TRUE);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA,GL_ONE);
    glDepthMask(0);
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, _texture);
    glDrawArrays(GL_POINTS, 0, NUM_PARTICLES);
    glDisableVertexAttribArray(_attributes.a_pStartPosition);
    glDisableVertexAttribArray(_attributes.a_pStartTime);
    glDisableVertexAttribArray(_attributes.a_pVelocityOffset);
    glDisableVertexAttribArray(_attributes.a_pDecayOffset);
    glDisableVertexAttribArray(_attributes.a_pSizeOffset);
    glDisableVertexAttribArray(_attributes.a_pColorOffset);
    glDisable(GL_BLEND);
    glDisable(GL_TEXTURE_2D);
    glDisable(GL_POINT_SPRITE_OES);
    glDepthMask(1);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glUseProgram(0);
    
}

- (GLKVector3) generateStartPosition
{
    // generate uniform distribution within a sphere volumn
    // reference: http://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform
    // and http://math.stackexchange.com/questions/87230/picking-random-points-in-the-volume-of-sphere-with-uniform-probability
    
    double radius = 1.0f;
    float U = [self randomFloatBetween:0.0f and:radius];
    U = powf(U, (1.0/3.0));
    float x0 = [self randomFloatBetween:-radius and:radius];
    float y0 = [self randomFloatBetween:0.0f and:radius];
    float z0 = [self randomFloatBetween:-radius and:radius];
    float sqrt_xyz = sqrtf(x0*x0 + y0*y0 + z0*z0);
    float x = x0 * U/sqrt_xyz;
    float y = y0 * U/sqrt_xyz;
    float z = z0 * U/sqrt_xyz;

    return GLKVector3Make(x, y, z);
}

- (float)randomFloatBetween:(float)min and:(float)max
{
    float range = max - min;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * range) + min;
}

- (void)loadTexture:(NSString *)fileName
{
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES],
                             GLKTextureLoaderOriginBottomLeft,
                             nil];
    
    NSError* error;
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    GLKTextureInfo* texture = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    if(texture == nil)
    {
        NSLog(@"Error loading file: %@", [error localizedDescription]);
    }
    _texture = texture.name;
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
