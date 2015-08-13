//
//  CGBallonRed.m
//  HappyStudy
//
//  Created by Q on 14/10/27.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "CGBallonRed.h"

@implementation CGBallonRed

#pragma mark - Override
- (id)initWithString:(NSString *)string position:(CGPoint)position isAnswer:(BOOL)isAnswer {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"CGBallonRed_Death"];
    SKTexture *theTexture = [atlas textureNamed:@"cgballon_red_death_0001"];
    if (self = [super initWithTexture:theTexture string:string position:position isAnswer:isAnswer]) {
        self.idleAnimationDuration = 5.6;
        self.label.position = CGPointMake(self.label.position.x, self.label.position.y + 30);
    }
    
    return self;
}

+ (void)loadAssets {
    deathAnimationFrames = [GlobalUtil loadFramesFromAtlas:@"CGBallonRed_Death" baseFileName:@"cgballon_red_death_" frameNum:10];
}

+ (void)releaseAssets {
    deathAnimationFrames = nil;
}

static NSArray *deathAnimationFrames = nil;
- (NSArray *)deathAnimationFrames {
    return deathAnimationFrames;
}

@end
