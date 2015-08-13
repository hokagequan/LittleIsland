//
//  GlobalUtil.m
//  HappyStudy
//
//  Created by Quan on 14/10/25.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "GlobalUtil.h"
#import "Reachability.h"

@implementation GlobalUtil

+ (NSString *)gameInfoWithKey:(NSString *)key {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GameInfo" ofType:@"plist"];
    NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:path];
    
    return info[key];
}

+ (BOOL)isNetworkConnection {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    return networkStatus != NotReachable;
}

+ (NSArray *)loadFramesFromAtlas:(NSString *)atlasName baseFileName:(NSString *)baseFileName frameNum:(NSInteger)frameNum {
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:frameNum];
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:atlasName];
    for (int i = 1; i <= frameNum; i++) {
        NSString *fileName = [NSString stringWithFormat:@"%@%04d.png", baseFileName, i];
        SKTexture *texture = [atlas textureNamed:fileName];
        [frames addObject:texture];
    }
    
    return frames;
}

+ (NSString *)randomCharacter {
    return [NSString stringWithFormat:@"%c", arc4random_uniform(26) + 'a'];
}

+ (void)randomArray:(NSMutableArray *)sourceArray {
    for (int i = 0; i < sourceArray.count; i++) {
        int randomIndex = arc4random() % sourceArray.count;
        id obj1 = sourceArray[randomIndex];
        id obj2 = sourceArray[i];
        sourceArray[randomIndex] = obj2;
        sourceArray[i] = obj1;
    }
}

+ (BOOL)soundFileExist:(NSString *)fileName {
    NSString *name = nil;
    NSString *ext = nil;
    [self splitFileName:fileName toName:&name toExt:&ext];
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:ext];
    
    return path != nil;
}

+ (void)splitFileName:(NSString *)fileName toName:(NSString **)name toExt:(NSString **)ext {
    if (!fileName) {
        return;
    }
    
    *name = [fileName stringByDeletingPathExtension];
    *ext = [fileName pathExtension];
}

@end
