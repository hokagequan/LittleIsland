//
//  AccountMgr.m
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "AccountMgr.h"

@implementation AccountMgr

+ (instancetype)sharedInstance {
    static AccountMgr *_sharedAccountMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAccountMgr = [[self alloc] init];
    });
    
    return _sharedAccountMgr;
}

- (id)init {
    if (self = [super init]) {
        self.user = [[User alloc] init];
    }
    
    return self;
}

@end
