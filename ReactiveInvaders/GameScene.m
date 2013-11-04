//
//  ECMyScene.m
//  ReactiveInvaders
//
//  Created by Giordano Scalzo on 26/10/2013.
//  Copyright (c) 2013 EffectiveCode. All rights reserved.
//

#import "GameScene.h"
#import <CoreMotion/CoreMotion.h>

#pragma mark - Custom Type Definitions
//1
typedef enum InvaderType {
    InvaderTypeA,
    InvaderTypeB,
    InvaderTypeC
} InvaderType;

//2
#define kInvaderSize CGSizeMake(24, 16)
#define kInvaderGridSpacing CGSizeMake(12, 12)
#define kInvaderRowCount 6
#define kInvaderColCount 6
//3
#define kInvaderName @"invader"

#pragma mark - Private GameScene Properties

@interface GameScene ()
@property BOOL contentCreated;
@end

@implementation GameScene

#pragma mark Object Lifecycle Management

#pragma mark - Scene Setup and Content Creation

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated) {
        [self createContent];
        self.contentCreated = YES;
    }
}

- (void)createContent
{
    [self setupInvaders];
}

-(void)setupInvaders {
    NSMutableArray *start = [NSMutableArray array];
    for (int i = 0; i < kInvaderRowCount*kInvaderColCount; ++i) {
        [start addObject:@(i)];
    }
    CGPoint baseOrigin = CGPointMake(kInvaderSize.width / 2, 180);
    
    RACSequence *aliens = [start.rac_sequence map:^(id value){
        NSUInteger row = [value integerValue]/kInvaderColCount;
        NSUInteger col = [value integerValue]%kInvaderColCount;
        
        CGPoint invaderPosition = CGPointMake(col * (kInvaderSize.width + kInvaderGridSpacing.width) + baseOrigin.x,
                                              row * (kInvaderGridSpacing.height + kInvaderSize.height) + baseOrigin.y);
        SKColor *invaderColor = @[[SKColor redColor], [SKColor greenColor], [SKColor blueColor]][row%3];
        SKSpriteNode* invader = [SKSpriteNode spriteNodeWithColor:invaderColor size:kInvaderSize];
        invader.name = kInvaderName;
        invader.position = invaderPosition;
        [self addChild:invader];
        
        return invader;
    }];
    
    [aliens all:^BOOL(id value) {
        return YES;
    }];
}

#pragma mark - Scene Update

- (void)update:(NSTimeInterval)currentTime
{
}

#pragma mark - Scene Update Helpers

#pragma mark - Invader Movement Helpers

#pragma mark - Bullet Helpers

#pragma mark - User Tap Helpers

#pragma mark - HUD Helpers

#pragma mark - Physics Contact Helpers

#pragma mark - Game End Helpers

@end