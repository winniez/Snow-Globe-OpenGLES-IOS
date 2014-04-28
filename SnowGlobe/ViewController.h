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
#import "GroundObject.h"
#import "SnowParticleObject.h"
// Transformations
#import "Transformations.h"


@interface ViewController : GLKViewController <GLKViewDelegate, GLKViewControllerDelegate>
{
    // View
    GLKMatrix4  _projectionMatrix;
    GLKMatrix4  _modelViewMatrix;
    GLKMatrix3  _normalMatrix;
}

// Class Objects
@property (strong, nonatomic) Transformations* transformations;
@property (strong, nonatomic) HouseObject* houseObj;
@property (strong, nonatomic) GroundObject* groundObj;
@property (strong) SnowParticleObject*  snowEmitter;

// View
@property (strong, nonatomic) EAGLContext* context;
@property (strong, nonatomic) GLKView* glkView;

// UI Controls
@property (weak, nonatomic) IBOutlet UISlider* rotateX;
@property (weak, nonatomic) IBOutlet UISlider* rotateY;
@property (weak, nonatomic) IBOutlet UISlider* rotateZ;

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;

@end
