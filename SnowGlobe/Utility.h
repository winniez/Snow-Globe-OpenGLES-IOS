//
//  Utility.h
//  SnowGlobe
//
//  Created by Winnie Zeng on 4/26/14.
//  Copyright (c) 2014 Winnie Zeng. All rights reserved.
//

#ifndef SnowGlobe_Utility_h
#define SnowGlobe_Utility_h

typedef struct AttributeHandles
{
    GLint       aVertex;
    GLint       aNormal;
    GLint       aTexture;
} AttributeHandles;

typedef struct UniformHandles
{
    GLuint      uProjectionMatrix;
    GLuint      uModelViewMatrix;
    GLuint      uNormalMatrix;
    
    GLint       uAmbient;
    GLint       uDiffuse;
    GLint       uSpecular;
    GLint       uExponent;
    GLint       uEyeDir;
    
    GLint       uStopTime;
    GLint       uTime;
    
    GLint       uColor;
    GLint       uTexture;
    GLint       uMode;
    GLint       uDeltaY;
} UniformHandles;

typedef struct GlassSphereAttributeHandles
{
    GLint       aVertex;
    GLint       aNormal;
    GLint       aTexture;
} GlassSphereAttributeHandles;

typedef struct GlassSphereUniformHandles
{
    GLuint      uProjectionMatrix;
    GLuint      uModelViewMatrix;
    GLuint      uNormalMatrix;
    
    GLint       uAmbient;
    GLint       uDiffuse;
    GLint       uSpecular;
    GLint       uExponent;
    GLint       uEyeDir;
    
    GLint       uTexture;
    GLint       uMode;
}GlassSphereUniformHandles;

typedef struct ParticleAttributeHandles
{
    // Attribute Handles
    GLint       a_pStartPosition;
    GLint       a_pStartTime;
    GLint       a_pVelocityOffset;
    GLint       a_pDecayOffset;
    GLint       a_pSizeOffset;
    GLint       a_pColorOffset;
    
    
} ParticleAttributeHandles;

typedef struct ParticleUniformHandles
{
    // Uniform Handles
    GLuint      u_ProjectionMatrix;
    GLuint      u_ModelViewMatrix;
    GLint       u_Gravity;
    GLint       u_Time;
    GLint       u_StopTime;
    GLint       u_eDecay;
    GLint       u_eSize;
    GLint       u_eColor;
    GLint       u_Texture;
    GLint       u_eStopPlaneY;
} ParticleUniformHandles;


#endif
