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

#define kInvaderSize CGSizeMake(24, 16)
#define kInvaderGridSpacing CGSizeMake(12, 12)
#define kBaseOrigin CGPointMake(kInvaderSize.width / 2, 180)

#define kInvaderRowCount 6
#define kInvaderColCount 6

#define kShipSize CGSizeMake(30, 16)

#define kInvaderName @"invader"
#define kShipName @"ship"
#define kScoreHudName @"scoreHud"
#define kHealthHudName @"healthHud"

#pragma mark - Private GameScene Properties

@interface GameScene (){
    RACSequence *nodes;
}

@property BOOL contentCreated;
@end

@implementation GameScene

#pragma mark Object Lifecycle Management

#pragma mark - Scene Setup and Content Creation

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated) {
        [self setupItems];
        self.contentCreated = YES;
    }
}


#pragma mark - Function Constructors

- (SKNode *)createInvader:(id)nodeIndex {
    NSUInteger row = [nodeIndex integerValue]/kInvaderColCount;
    NSUInteger col = [nodeIndex integerValue]%kInvaderColCount;
    
    CGPoint invaderPosition = CGPointMake(col * (kInvaderSize.width + kInvaderGridSpacing.width) + kBaseOrigin.x,
                                          row * (kInvaderGridSpacing.height + kInvaderSize.height) + kBaseOrigin.y);
    SKColor *invaderColor = @[[SKColor redColor], [SKColor greenColor], [SKColor blueColor]][row%3];
    SKSpriteNode* invader = [SKSpriteNode spriteNodeWithColor:invaderColor size:kInvaderSize];
    invader.name = kInvaderName;
    invader.position = invaderPosition;
    [self addChild:invader];
    
    return invader;
}

-(SKNode *)createShip:(id)nodeIndex {
    SKNode* ship = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor] size:kShipSize];
    ship.name = kShipName;
    ship.position = CGPointMake(self.size.width / 2.0f, kShipSize.height/2.0f);
    [self addChild:ship];
    return ship;
}

- (SKNode *)createScoreHud:(id)nodeIndex
{
    SKLabelNode* scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    scoreLabel.name = kScoreHudName;
    scoreLabel.fontSize = 15;
    scoreLabel.fontColor = [SKColor greenColor];
    scoreLabel.text = [NSString stringWithFormat:@"Score: %04u", 0];
    scoreLabel.position = CGPointMake(20 + scoreLabel.frame.size.width/2, self.size.height - (20 + scoreLabel.frame.size.height/2));
    [self addChild:scoreLabel];
    return scoreLabel;
}

- (SKNode *)createHealthHud:(id)nodeIndex
{
    SKLabelNode* healthLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    healthLabel.name = kHealthHudName;
    healthLabel.fontSize = 15;
    healthLabel.fontColor = [SKColor redColor];
    healthLabel.text = [NSString stringWithFormat:@"Health: %.1f%%", 100.0f];
    healthLabel.position = CGPointMake(self.size.width - healthLabel.frame.size.width/2 - 20, self.size.height - (20 + healthLabel.frame.size.height/2));
    [self addChild:healthLabel];
    return healthLabel;
}

#pragma mark - create content

-(void)setupItems {
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:@{ @"type": kShipName,
                        @"index":@0}];
    [items addObject:@{ @"type": kScoreHudName,
                        @"index":@0}];
    [items addObject:@{ @"type": kHealthHudName,
                        @"index":@0}];
    
    for (int i = 0; i < kInvaderRowCount*kInvaderColCount; ++i) {
        [items addObject:@{ @"type": kInvaderName,
                            @"index":@(i)}
         ];
    }
    
    NSDictionary *ctors = @{
                            kShipName: [^(id value){
                                return [self createShip:value[@"index"]];
                            } copy],
                            kScoreHudName: [^(id value){
                                return [self createScoreHud:value[@"index"]];
                            } copy],
                            kHealthHudName: [^(id value){
                                return [self createHealthHud:value[@"index"]];
                            } copy],
                            kInvaderName: [^(id value){
                                return [self createInvader:value[@"index"]];
                            } copy],
                            };
    
    nodes = [items.rac_sequence map:^(id value){
        id (^ctor)(id value) = ctors[value[@"type"]];
        return ctor(value);
    }];
    
    [nodes all:^BOOL(id value) {
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