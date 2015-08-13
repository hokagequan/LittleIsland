//
//  SettingMgr.h
//  EasyLSP
//
//  Created by Q on 14/11/19.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingMgr : NSObject

@property (nonatomic) BOOL bgMusicOff;

+ (instancetype)sharedInstance;
+ (void)setValue:(id)value withKey:(NSString *)key;

- (void)startBackgroundMusicWithName:(NSString *)name;
- (void)stopBackgroundMusic;

@end
