//
//  AccountMgr.h
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface AccountMgr : NSObject

@property (strong, nonatomic) User *user;

+ (instancetype)sharedInstance;

@end
