//
//  HelloWorldScene.m
//  sarah
//
//  Created by Christina Francis on 1/22/14.
//  Copyright Christina Francis 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"
#import "IntroScene.h"
#import "NewtonScene.h"
#import "NewtonConstants.h"
#import "CCAnimation.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
    CCSprite *_sprite;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Create a physics node, to hold all the spheres
    // This node is a physics node, so that you can add physics to the spheres
    _physics = [CCPhysicsNode node];
    _physics.gravity =ccp(0,0);  //NewtonGravity  - constant value
    [self addChild:_physics z:50];
    
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    _fire = [CCParticleSystem particleWithFile:@"fire.plist"];
    _fire.particlePositionType = CCParticleSystemPositionTypeFree;
    
    
    
    // ----------
    // Issue #484
    // There is a bug in particle systems, that prevents free particles from being scaled. In stead the properties must be scaled.
    float particleScale = NewtonParticleScale * [CCDirector sharedDirector].viewSize.width / 1000;
    _fire.startSize *= particleScale;
    _fire.startSizeVar *= particleScale;
    _fire.endSize *= particleScale;
    _fire.endSizeVar *= particleScale;
    _fire.gravity = ccpMult(_fire.gravity, particleScale);
    _fire.posVar = ccpMult(_fire.posVar, particleScale);
    
    // this produces weird results
   // _fire.scale = particleScale;
    // ----------
    
   
    
    _forward = YES;
    // Create a colored background (Dark Grey)
  //  CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.6f green:0.8f blue:0.2f alpha:1.0f]];
   // [self addChild:background];
    
    int ladybug_1_speed = 33;
    int ladybug_2_speed = 10;
    int ladybug_3_speed = 27;
    int ladybug_4_speed = 20;
    int ladybug_5_speed = 14;
    
    CGSize s = [[CCDirector sharedDirector] viewSize];
    
    int maxRange = s.height - 20;
    int minRange = 20;
    
    float randomNumber = (arc4random() % maxRange) + minRange;
    
    maxRange = self.contentSize.height - 20 ;
    minRange = 20;
    
    float randomNumber_y = (arc4random() % maxRange) + minRange;
    
    maxRange = s.width - 20 ;
    minRange = 20;
    
    float randomNumber_x = (arc4random() % maxRange) + minRange;
    
    
    // Add a sprite
[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sprite_sarah.plist"];
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"sprite_sarah.png"];
    [_physics addChild:spriteSheet z:50];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"grass_sprites.plist"];
    CCSpriteBatchNode *spriteSheetGrass = [CCSpriteBatchNode batchNodeWithFile:@"grass_sprites.png"];
    [self addChild:spriteSheetGrass z:400];

    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"grass_sprites.plist"];
    CCSpriteBatchNode *spriteSheetGrass2 = [CCSpriteBatchNode batchNodeWithFile:@"grass_sprites.png"];
    [self addChild:spriteSheetGrass2 z:400];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"anime_flower_sprites.plist"];
    CCSpriteBatchNode *spriteSheetFlower = [CCSpriteBatchNode batchNodeWithFile:@"anime_flower_sprites.png"];
    [self addChild:spriteSheetFlower z:45];
    
    
    spriteSheet.position  = ccp(5,self.contentSize.height/2);
    spriteSheetFlower.position  = ccp(randomNumber_x,randomNumber_y);
    spriteSheetGrass.position = ccp(100,10);
    spriteSheetGrass2.position = ccp(s.width * 0.5 + 100,10);
    
    self.ladybug_1 = [CCSprite spriteWithImageNamed:@"lbug.png"];
    self.ladybug_2 = [CCSprite spriteWithImageNamed:@"lbug.png"];
    self.ladybug_3 = [CCSprite spriteWithImageNamed:@"lbug.png"];
    self.ladybug_4 = [CCSprite spriteWithImageNamed:@"lbug.png"];
    self.ladybug_5 = [CCSprite spriteWithImageNamed:@"lbug.png"];
    block = [CCSprite spriteWithImageNamed:@"block_1.png"];
    [_physics addChild:block z:50];
    block.position = ccp(self.contentSize.width*0.5, self.contentSize.height * 0.5);
   
    CCPhysicsBody *body = [CCPhysicsBody bodyWithCircleOfRadius:(block.contentSize.width - NewtonSphereMargin) * 0.5 andCenter:CGPointZero];
    CCPhysicsBody *body_1 = [CCPhysicsBody bodyWithCircleOfRadius:(block.contentSize.width - NewtonSphereMargin) * 0.5 andCenter:CGPointZero];
    
    // Assign the physics to our base node
    block.physicsBody = body;
    spriteSheet.physicsBody = body_1;
    
    // Set the physics properties, trying to simulate a newtons cradle
    body.friction = NewtonSphereFriction;
    body.elasticity = NewtonSphereElasticity;
    
    // Assign the collision category
    // As you can assign several categories, this becomes an extremely flexible and clever way of filtering collisions.
    body.collisionCategories = @[NewtonSphereCollisionSphere];
    
    // Spheres should collide with both other spheres, and the outline
    body.collisionMask = @[NewtonSphereCollisionSphere, NewtonSphereCollisionOutline];
    
    // Set the physics properties, trying to simulate a newtons cradle
    body_1.friction = NewtonSphereFriction;
    body_1.elasticity = NewtonSphereElasticity;
    
    // Assign the collision category
    // As you can assign several categories, this becomes an extremely flexible and clever way of filtering collisions.
    body_1.collisionCategories = @[NewtonSphereCollisionSphere];
    
    // Spheres should collide with both other spheres, and the outline
    body_1.collisionMask = @[NewtonSphereCollisionSphere, NewtonSphereCollisionOutline];
    
    self.ladybug_1.position = ccp(0,randomNumber);
    [self addChild:self.ladybug_1];
    [self.ladybug_1 addChild:_fire];
    
    // place the fire effect in upper half of sphere (looks better)
    _fire.position = ccp(0, self.ladybug_1.contentSize.height * NewtonParticleDisplacement);
    
    randomNumber = (arc4random() % maxRange) + minRange;
    
    self.ladybug_2.position = ccp(0,randomNumber);
    [self addChild:self.ladybug_2];
    
    randomNumber = (arc4random() % maxRange) + minRange;
    
    self.ladybug_3.position = ccp(0,randomNumber);
    [self addChild:self.ladybug_3];
    
    randomNumber = (arc4random() % maxRange) + minRange;
    
    self.ladybug_4.position = ccp(0,randomNumber);
    [self addChild:self.ladybug_4];
    randomNumber = (arc4random() % maxRange) + minRange;
    
    self.ladybug_5.position = ccp(0,randomNumber);
    [self addChild:self.ladybug_5];
    
    // Animate sprite with action
  /*  CCActionRotateBy* actionSpin = [CCActionRotateBy actionWithDuration:1.5f angle:360];
    [_sprite runAction:[CCActionRepeatForever actionWithAction:actionSpin]];*/
    
    //id tintAction = [CCActionTintTo  ];
   
    
    [spriteSheet runAction:[CCActionRepeat actionWithAction: 
      [CCActionSequence actionOne:[CCActionDelay actionWithDuration:0.2 ] two:[CCActionToggleVisibility action]] times:8]];
    //[self.ladybug_1 setOpacity:2];
    
    CCActionMoveBy* actionJDown = [CCActionMoveBy actionWithDuration:1 position:ccp(ladybug_1_speed,0)];
    [self.ladybug_1 runAction:[CCActionRepeatForever actionWithAction:actionJDown]];
    actionJDown = [CCActionMoveBy actionWithDuration:1 position:ccp(ladybug_2_speed,0)];
    [self.ladybug_2 runAction:[CCActionRepeatForever actionWithAction:actionJDown]];
    actionJDown = [CCActionMoveBy actionWithDuration:1 position:ccp(ladybug_3_speed,0)];
    [self.ladybug_3 runAction:[CCActionRepeatForever actionWithAction:actionJDown]];
    actionJDown = [CCActionMoveBy actionWithDuration:1 position:ccp(ladybug_4_speed,0)];
    [self.ladybug_4 runAction:[CCActionRepeatForever actionWithAction:actionJDown]];
    actionJDown = [CCActionMoveBy actionWithDuration:1 position:ccp(ladybug_5_speed,0)];
    [self.ladybug_5 runAction:[CCActionRepeatForever actionWithAction:actionJDown]];
    
  //  CCActionJumpBy* actionJUp = [CCActionJumpBy actionWithDuration:5 position:ccp(90,0) height:60 jumps:2];
 // [_sprite runAction:[CCActionRepeatForever actionWithAction:actionJUp]];
    
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    for (int i=1; i<=10; i++) {
         NSLog(@"%@ is sprite name",[NSString stringWithFormat:@"sprite_%d.png",i] );
        [walkAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"sprite_%d.png",i]]];
    }
    NSMutableArray *changeAnimFrames = [NSMutableArray array];
    for (int i=1; i<=9; i++) {
        NSLog(@"%@ is sprite name",[NSString stringWithFormat:@"flower_%d.png",i] );
        [changeAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"flower_%d.png",i]]];
    }
    NSMutableArray *grassAnimFrames = [NSMutableArray array];
    for (int i=1; i<=2; i++) {
        NSLog(@"%@ is sprite name",[NSString stringWithFormat:@"grass_%d.png",i] );
        [grassAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"grass_%d.png",i]]];
    }
    
    self.bear = [CCSprite spriteWithSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"sprite_1.png" ]];
    self.bear.position = ccp(30,0);
    CCAction *walk = [CCActionRepeatForever actionWithAction:[CCActionAnimate actionWithAnimation:
                       [CCAnimation animationWithSpriteFrames:walkAnimFrames delay:0.1f ] ]];
    [self.bear runAction:walk ];
     
    //[self.bear runAction:[CCActionRepeatForever actionWithAction:actionJDown ]];
    [spriteSheet addChild:self.bear z:350];
    
    self.flower = [CCSprite spriteWithSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"flower_1.png" ]];
    self.flower.position = ccp(0,0);
    CCAction *colorChange = [CCActionRepeatForever actionWithAction:[CCActionAnimate actionWithAnimation:
                                                              [CCAnimation animationWithSpriteFrames:changeAnimFrames delay:0.2f ] ]];
    [self.flower runAction:colorChange ];
    //[self.bear runAction:[CCActionRepeatForever actionWithAction:actionJDown ]];
    [spriteSheetFlower addChild:self.flower z:340];

    
    self.grass = [CCSprite spriteWithSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"grass_1.png" ]];
    self.grass.position = ccp(0,0);
    CCAction *movGrass = [CCActionRepeatForever actionWithAction:[CCActionAnimate actionWithAnimation:
                                                                     [CCAnimation animationWithSpriteFrames:grassAnimFrames delay:0.2f ] ]];
    [self.grass runAction:movGrass ];
    self.grass2 = [CCSprite spriteWithSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"grass_1.png" ]];
    self.grass2.position = ccp(0,0);
    CCAction *movGrass2 = [CCActionRepeatForever actionWithAction:[CCActionAnimate actionWithAnimation:
                                                                  [CCAnimation animationWithSpriteFrames:grassAnimFrames delay:0.2f ] ]];
    [self.grass2 runAction:movGrass2 ];
    //[self.bear runAction:[CCActionRepeatForever actionWithAction:actionJDown ]];
    [spriteSheetGrass addChild:self.grass z:340];
    [spriteSheetGrass2 addChild:self.grass2 z:340];
    _forward = YES;
    
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];

    // done
	return self;
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    [self initBackground];
    
    [self schedule: @selector(tick:) interval:0.002f];
    //[self schedule:@selector(nextFrame:) interval:.4f];
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Pr frame update is automatically enabled, if update is overridden
    
}
-(void)initBackground
{
    NSString *tex = @"bg1.jpg";//[self getThemeBG];
    CGSize s = [[CCDirector sharedDirector] viewSize];
    
    mBG1 = [CCSprite spriteWithImageNamed:tex];
    mBG1.position = ccp(s.width*0.5,s.height*0.5f);
    [self addChild:mBG1 z:-390];
    
    mBG2 = [CCSprite spriteWithImageNamed:tex];
    
    mBG2.position = ccp(mBG1.contentSize.width+s.width*0.5f,s.height*0.5f);
    mBG2.flipX = true;
    
    [self addChild:mBG2 z:-280];
    
}


-(void)scrollBackground:(CCTime)dt
{
    CGSize s = [[CCDirector sharedDirector] viewSize];
    
    CGPoint pos1 = mBG1.position;
    CGPoint pos2 = mBG2.position;
    CGPoint pos3 = self.flower.position;
    
    int maxRange = s.height - 8;
    int minRange = 8;
    
    float randomNumber = (arc4random() % maxRange) +minRange ;
    if (self.ladybug_1.position.x >= (self.contentSize.width)) {
        self.ladybug_1.position = ccp(0,randomNumber);
    }
    
    randomNumber = (arc4random() % maxRange) +minRange ;
    if (self.ladybug_2.position.x >= (self.contentSize.width)) {
        self.ladybug_2.position = ccp(0,randomNumber);
    }
    
    randomNumber = (arc4random() % maxRange) +minRange ;
    if (self.ladybug_3.position.x >= (self.contentSize.width)) {
        self.ladybug_3.position = ccp(0,randomNumber);
    }
    
    randomNumber = (arc4random() % maxRange) +minRange ;
    if (self.ladybug_4.position.x >= (self.contentSize.width)) {
        self.ladybug_4.position = ccp(0,randomNumber);
    }
    
    randomNumber = (arc4random() % maxRange) +minRange ;
    if (self.ladybug_5.position.x >= (self.contentSize.width)) {
        self.ladybug_5.position = ccp(0,randomNumber);
    }
    
    if(_forward){
        pos1.x -= .4;
        pos2.x -= .4;
        pos3.x -= .4;
        
       
        if(pos1.x <=-(s.width) )
        {
            pos1.x = pos2.x + mBG2.contentSize.width;
           
        }
        
        if(pos2.x <=-(s.width) )
        {
            pos2.x = pos1.x + mBG1.contentSize.width;
            
        }
 
    }
    else{
        pos1.x += .4;
        pos2.x += .4;
        pos3.x += .4;
        
        
        if(pos1.x >=(s.width*2) )
        {
            pos1.x = pos2.x - mBG2.contentSize.width;
            
        }
        
        if(pos2.x >=(s.width*2) )
        {
            pos2.x = pos1.x - mBG1.contentSize.width;
            
        }
    }
   
    mBG1.position = pos1;
 
    mBG2.position = pos2;
    
    self.flower.position = pos3;
 
}

-(void)tick:(CCTime)dt
{
    [self scrollBackground:dt];
    
}
// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    CGPoint moveDifference = ccpSub(touchLoc, self.bear.position);
    CCActionMoveBy* actionJDown;
    CCActionMoveBy* action2;
    CCActionMoveBy* action3;
    CCActionMoveBy* action4;
    CCActionMoveBy* action5;
    
    BOOL old;
    old = _forward;
    
    if (moveDifference.x < 0) {
        self.bear.flipX = YES;
        _forward = NO;
        NSLog(@"Going backward");
        if(old != _forward){
            actionJDown  = [CCActionMoveBy actionWithDuration:1 position:ccp(300,0)];
            action2  = [CCActionMoveBy actionWithDuration:1 position:ccp(300,0)];
            action3  = [CCActionMoveBy actionWithDuration:1 position:ccp(300,0)];
            action4  = [CCActionMoveBy actionWithDuration:1 position:ccp(300,0)];
            action5  = [CCActionMoveBy actionWithDuration:1 position:ccp(300,0)];
        }
    }
    else {
        self.bear.flipX = NO;
        _forward = YES;
        NSLog(@"Going forward");
        if(old != _forward){
            actionJDown = [CCActionMoveBy actionWithDuration:1 position:ccp(-300,0)];
            action2  = [CCActionMoveBy actionWithDuration:1 position:ccp(-300,0)];
            action3  = [CCActionMoveBy actionWithDuration:1 position:ccp(-300,0)];
            action4  = [CCActionMoveBy actionWithDuration:1 position:ccp(-300,0)];
            action5  = [CCActionMoveBy actionWithDuration:1 position:ccp(-300,0)];
        }
    }
    
    [self.ladybug_1 runAction:[CCActionRepeatForever actionWithAction: actionJDown ]];
    [self.ladybug_2 runAction:[CCActionRepeatForever actionWithAction: action2 ]];
    [self.ladybug_3 runAction:[CCActionRepeatForever actionWithAction: action3 ]];
    [self.ladybug_4 runAction:[CCActionRepeatForever actionWithAction: action4 ]];
    [self.ladybug_5 runAction:[CCActionRepeatForever actionWithAction: action5 ]];
    // Log touch location
    CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
    
    // Move our sprite to touch location
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:ccp(touchLoc.x,touchLoc.y - self.contentSize.height/2)];
    [self.bear runAction:actionMove];
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

- (void)onNewtonClicked:(id)sender
{
    [[CCDirector sharedDirector] pushScene:[NewtonScene scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

// -----------------------------------------------------------------------
@end