//
//  ViewController.h
//  MTL
//
//  Created by Ricardo Rendon Cepeda on 30/10/12.
//  Copyright (c) 2012 RRC. All rights reserved.
//

// Frameworks
#import <GLKit/GLKit.h>

#import "HouseObject.h"
//#import "GroundObject.h"
#import "SnowParticleObject.h"
#import "GlassSphere.h"
#import "CylinderObject.h"
#import "CirclePlaneObject.h"
// Transformations
#import "Transformations.h"


@interface ViewController : GLKViewController <GLKViewDelegate, GLKViewControllerDelegate>
{
    // View
    GLKMatrix4  _projectionMatrix;
    GLKMatrix4  _modelViewMatrix;
    GLKMatrix3  _normalMatrix;
    
    // Lighting
    GLKVector3      _ambient;
    GLKVector3      _diffuse;
    GLKVector3      _specular;
    float           _exponent;
    GLKVector3      _eyedir;
    
    // Time
    float           _time;
    float           _stoptime;
    float           _deltaSnow;
    
}

// Class Objects
@property (strong, nonatomic) Transformations* transformations;
@property (strong, nonatomic) HouseObject* houseObj;
//@property (strong, nonatomic) GroundObject* groundObj;
@property (strong, nonatomic) SnowParticleObject*  snowEmitter;
@property (strong, nonatomic) GlassSphere* sphereObj;
@property (strong, nonatomic) CylinderObject *cylinderObj;
@property (strong, nonatomic) CirclePlaneObject *circlePlaneObj;

// View
@property (strong, nonatomic) EAGLContext* context;
@property (strong, nonatomic) GLKView* glkView;

// UI Controls
@property (weak, nonatomic) IBOutlet UISlider* rotateX;
@property (weak, nonatomic) IBOutlet UISlider* rotateY;
@property (weak, nonatomic) IBOutlet UISlider* rotateZ;

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;

- (void) resetTime;

@end
