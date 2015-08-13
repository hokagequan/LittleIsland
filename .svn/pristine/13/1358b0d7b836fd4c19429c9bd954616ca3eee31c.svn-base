//
//  GameMgr.m
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "GameMgr.h"
#import "ChooseGameScene.h"
#import "DuiDuiPengGameScene.h"
#import "LoadingScene.h"
#import "HSError.h"

@implementation GameMgr

+ (instancetype)sharedInstance {
    static GameMgr *_sharedGameMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedGameMgr = [[self alloc] init];
    });
    
    return _sharedGameMgr;
}

- (id)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)loadGameFrom:(SKScene *)scene {
    if (self.selGame == StudyGameNon || self.selGame >= StudyGameMax) {
        return;
    }
    
    [LoadingScene showFrom:scene];
    
    switch (self.selGame) {
        case StudyGameChoose: {
            ChooseGameScene *cgScene = [[ChooseGameScene alloc] initWithSize:scene.size];
            cgScene.scaleMode = SKSceneScaleModeAspectFill;
            
            [self doLoadGameFrom:scene to:cgScene];
        }
            
            break;
        case StudyGameDuiDuiPeng: {
            DuiDuiPengGameScene *ddpScene = [[DuiDuiPengGameScene alloc] initWithSize:scene.size];
            ddpScene.scaleMode = SKSceneScaleModeAspectFill;
            
            [self doLoadGameFrom:scene to:ddpScene];
        }
            
            break;
            
        default:
            break;
    }
}

- (void)doLoadGameFrom:(SKScene *)fScene to:(HSGameScene *)tScene {
    [[tScene class] loadGameComplete:^{
        [LoadingScene dismissTo:tScene];
    } failure:^(NSDictionary *info) {
        [LoadingScene dismissTo:fScene];
        
        HSError *error = (HSError *)info[@"error"];
        NSString *message = error.message;
        if (!message) {
            message = @"Connection Error";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK~"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

@end
