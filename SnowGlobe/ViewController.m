//
//  ViewController.m
//  MTL
//
//  Created by Ricardo Rendon Cepeda on 30/10/12.
//  Copyright (c) 2012 RRC. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize Context & OpenGL ES
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // Setup View
    self.glkView = (GLKView *) self.view;
    self.glkView.context = self.context;
    self.glkView.opaque = YES;
    self.glkView.backgroundColor = [UIColor whiteColor];
    self.glkView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    self.glkView.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    // Set animation frame rate
    //self.preferredFramesPerSecond = 60;
    
    // Setup OpenGL ES
    [self setupOpenGLES];
}

- (void)setupOpenGLES
{
    [EAGLContext setCurrentContext:self.context];
    
    // Enable depth test
    glEnable(GL_DEPTH_TEST);
    
    // Projection Matrix
    CGRect screen = [[UIScreen mainScreen] bounds];
    float aspectRatio = fabsf(screen.size.width / screen.size.height);
    _projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45.0), aspectRatio, 0.1, 10.1);
    
    // ModelView Matrix
    _modelViewMatrix = GLKMatrix4Identity;
    
    // Initialize Model Pose
    self.transformations = [[Transformations alloc] initWithDepth:5.0f Scale:1.33f Translation:GLKVector2Make(0.0f, 0.0f) Rotation:GLKVector3Make(0.0f, 0.0f, 0.0f)];
    
    // Set lighting parameters
    _ambient = GLKVector3Make(0.5f, 0.5f, 0.5f);
    _diffuse = GLKVector3Make(0.5f, 0.5f, 0.5f);
    _specular = GLKVector3Make(0.0f, 0.0f, 0.0f);
    _exponent = 1.0f;
    
    // Set time parameters
    _time = 0.0f;
    _stoptime = 15.0f;
    _deltaSnow = 0.01f;
    
    // Initialize objects
    self.houseObj = [[HouseObject alloc] loadObject : _stoptime DeltaSnow:_deltaSnow];
    [self.houseObj setCoord:GLKVector3Make(0.0f, -0.054f, 0.0f)];
    [self.houseObj setScale:1.1f];
    
    //self.groundObj = [[GroundObject alloc] loadObject : _stoptime];
    //[self.groundObj setCoord:GLKVector3Make(0.27f, -0.125f, 0.0f)];
    //[self.groundObj setScale:1.6f];
    
    // Set up circle plane ground
    self.circlePlaneObj = [[CirclePlaneObject alloc] loadObject : _stoptime DeltaSnow:_deltaSnow];
    float h = -0.25f;
    float theta = coshf(h);
    float circleScale = sinf(theta);
    //[self.circlePlaneObj setScale:circleScale];
    [self.circlePlaneObj setCoord:GLKVector3Make(0.0f, h, 0.0f)];
    
    // Set up Emitter
    self.snowEmitter = [[SnowParticleObject alloc] initWithTexture:@"snowflake-transparent-5.png" StopTime: _stoptime];
    [self.snowEmitter setCoord:GLKVector3Make(0.0f, 0.0f, 0.0f)];
    [self.snowEmitter setScale:1.0f];
    
    // Set up sphere
    self.sphereObj = [[GlassSphere alloc] loadObject];
    [self.sphereObj setScale:1.0f];
    // set up sphere stand
    self.cylinderObj = [[CylinderObject alloc] loadObject];
    [self.cylinderObj setCoord:GLKVector3Make(0.0f, -0.65f, 0.0f)];
    
}

- (void) update
{
    [self updateViewMatrices];
    _time += self.timeSinceLastUpdate;
}

- (void)updateViewMatrices
{
    // ModelView Matrix
    _modelViewMatrix = [self.transformations getModelViewMatrix];
    
    // Normal Matrix
    // Transform object-space normals into eye-space
    _normalMatrix = GLKMatrix3Identity;
    bool isInvertible;
    _normalMatrix = GLKMatrix4GetMatrix3(GLKMatrix4InvertAndTranspose(_modelViewMatrix, &isInvertible));
}

# pragma mark - GLKView Delegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // Clear Buffers
    glClearColor(0.111f, 0.111f, 0.439f, 1.0f);
    //glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Set View Matrices
    [self updateViewMatrices];
    
    [self.houseObj displayWith : _projectionMatrix MVMatrix : _modelViewMatrix
                       NMatrix : _normalMatrix Ambient:_ambient
                        Diffuse:_diffuse Specular:_specular
                         EyeDir:_eyedir Exponent:_exponent CurrentTime:_time];
    [self.circlePlaneObj displayWith:_projectionMatrix
                            MVMatrix:_modelViewMatrix NMatrix:_normalMatrix Ambient:_ambient
                             Diffuse:_diffuse Specular:_specular
                              EyeDir:_eyedir Exponent:_exponent CurrentTime:_time];
    /*
    [self.groundObj displayWith:_projectionMatrix MVMatrix:_modelViewMatrix
                        NMatrix:_normalMatrix Ambient:_ambient
                        Diffuse:_diffuse Specular:_specular
                         EyeDir:_eyedir Exponent:_exponent];
     */
    
    [self.snowEmitter renderWithProjection:_projectionMatrix MVMatrix : _modelViewMatrix  CurrentTime:_time];
    [self.sphereObj displayWith:_projectionMatrix
                       MVMatrix:_modelViewMatrix NMatrix:_normalMatrix Ambient:_ambient
                        Diffuse:_diffuse Specular:_specular
                         EyeDir:_eyedir Exponent:_exponent];
    
    
    [self.cylinderObj displayWith:_projectionMatrix MVMatrix:_modelViewMatrix NMatrix:_normalMatrix
                          Ambient:_ambient
                          Diffuse:_diffuse Specular:_specular
                           EyeDir:_eyedir Exponent:_exponent];
     
}

# pragma mark - GLKViewController Delegate

- (void)glkViewControllerUpdate:(GLKViewController *)controller
{
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    float aspectRatio = fabsf(screen.size.width / screen.size.height);
    if ((fromInterfaceOrientation == UIInterfaceOrientationPortrait) || (fromInterfaceOrientation ==UIInterfaceOrientationPortraitUpsideDown))
    {
        _projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45.0), 1/aspectRatio, 0.1, 10.1);
    }
    else
    {
        _projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45.0), aspectRatio, 0.1, 10.1);
    }
    
}


// GESTURES

# pragma mark - Gestures

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Begin transformations
    [self.transformations start];
}

- (void) resetTime
{
    _time = 0.0f;
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender
{
    // Pan (1 Finger)
    if((sender.numberOfTouches == 1) &&
       ((self.transformations.state == S_NEW) || (self.transformations.state == S_TRANSLATION)))
    {
        CGPoint translation = [sender translationInView:sender.view];
        float x = translation.x/sender.view.frame.size.width;
        float y = translation.y/sender.view.frame.size.height;
        [self.transformations translate:GLKVector2Make(x, y) withMultiplier:2.0f];
    }
    
    // Pan (2 Fingers)
    else if((sender.numberOfTouches == 2) &&
            ((self.transformations.state == S_NEW) || (self.transformations.state == S_ROTATION)))
    {
        const float m = GLKMathDegreesToRadians(0.5f);
        CGPoint rotation = [sender translationInView:sender.view];
        [self.transformations rotate:GLKVector3Make(rotation.x, rotation.y, 0.0f) withMultiplier:m];
    }
}

- (IBAction)pinch:(UIPinchGestureRecognizer *)sender
{
    // Pinch
    if((self.transformations.state == S_NEW) || (self.transformations.state == S_SCALE))
    {
        float scale = [sender scale];
        [self.transformations scale:scale];
    }
}

- (IBAction)rotation:(UIRotationGestureRecognizer *)sender
{
    // Rotation
    if((self.transformations.state == S_NEW) || (self.transformations.state == S_ROTATION))
    {
        float rotation = [sender rotation];
        [self.transformations rotate:GLKVector3Make(0.0f, 0.0f, rotation) withMultiplier:1.0f];
    }
}

- (IBAction) tap: (UITapGestureRecognizer *)sender
{
    // Tap
    [self resetTime];
}

@end
