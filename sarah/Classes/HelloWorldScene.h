//
//  HelloWorldScene.h
//  sarah
//
//  Created by Christina Francis on 1/22/14.
//  Copyright Christina Francis 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"


// -----------------------------------------------------------------------

/**
 *  The main scene
 */
@interface HelloWorldScene : CCScene
{
    BOOL bearMoving;
      CCSprite  *mBG1;
    CCSprite  *mBG2;
     CCParticleSystem *_fire;
    CCSprite *block;
    CCPhysicsNode *_physics;
}

@property BOOL forward;
@property (nonatomic, strong) CCSprite *bear;
@property (nonatomic, strong) CCSprite *grass;
@property (nonatomic, strong) CCSprite *grass2;
@property (nonatomic, strong) CCSprite *flower;
@property (nonatomic, strong) CCSprite *ladybug_1;
@property (nonatomic, strong) CCSprite *ladybug_2;
@property (nonatomic, strong) CCSprite *ladybug_3;
@property (nonatomic, strong) CCSprite *ladybug_4;
@property (nonatomic, strong) CCSprite *ladybug_5;
@property (nonatomic, strong) CCAction *walkAction;
@property (nonatomic, strong) CCAction *moveAction;
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene;
- (id)init;

// -----------------------------------------------------------------------
@end