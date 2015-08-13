//
//  HSCharacter.h
//  HappyStudy
//
//  Created by Quan on 14/10/26.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSButtonSprite.h"

typedef enum : uint8_t {
    HSAnimationStateNon = 0,
    HSAnimationStateIdle,
    HSAnimationStateMove,
    HSAnimationStateDeath,
    HSAnimationStateCount
} HSAnimationState;

@interface HSCharacter : HSButtonSprite

@property (strong, nonatomic) NSString *activeAnimationKey;
@property (nonatomic) HSAnimationState requestedAnimation;
@property (nonatomic) CGFloat animationSpeed;

+ (void)loadAssets;
+ (void)releaseAssets;

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval;

- (NSString *)animationKeyWith:(HSAnimationState)animation;
- (void)fireAnimationWithTextures:(NSArray *)frames withKey:(NSString *)key;
- (void)animationDidComplete:(HSAnimationState)animation;

- (void)animationIdle;
- (void)animationMove;
- (void)animationDeath;

@end
