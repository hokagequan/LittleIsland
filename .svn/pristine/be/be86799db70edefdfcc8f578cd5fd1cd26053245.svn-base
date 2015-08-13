//
//  HSGameScene.m
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSGameScene.h"

@implementation HSGameScene

- (void)setButtonSelectState:(NSString *)buttonName {
    NSString *name = buttonName;
    if (!name) {
        name = @"non";
    }
    for (HSButtonSprite *button in self.buttons) {
        button.selected = [button.name isEqualToString:name];
    }
}

#pragma mark - Class Function
+ (void)loadGameComplete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(queue, ^{
            [self loadGameDataFrom:-1 count:1000 Complete:^{
                dispatch_semaphore_signal(semaphore);
            } failure:^(NSDictionary *info) {
                if (failure) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(info);
                    });
                }
            }];
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(queue, ^{
            [self loadSceneAssetsWithCompletionHandler:^{
                if (complete) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        complete();
                    });
                }
            }];
        });
    });
}

+ (void)loadSceneAssetsWithCompletionHandler:(HSGSAssetLoadCompletionHandler)handler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self loadSceneAssets];
        
        if (!handler) {
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            handler();
        });
    });
}

+ (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    // 子类继承
}

+ (void)loadSceneAssets {
    // 子类继承
}

+ (void)releaseSceneAssets {
    // 子类继承
}

#pragma mark - Property
- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc] init];
    }
    
    return _buttons;
}

@end
