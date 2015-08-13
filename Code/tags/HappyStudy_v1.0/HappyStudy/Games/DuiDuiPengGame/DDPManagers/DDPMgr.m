//
//  DDPManagers.m
//  HappyStudy
//
//  Created by Quan on 14/10/22.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "DDPMgr.h"

@implementation DDPMgr

+ (instancetype)sharedInstance {
    static DDPMgr *_sharedDDPMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDDPMgr = [[self alloc] init];
    });
    
    return _sharedDDPMgr;
}

- (id)init {
    if (self = [super init]) {
        _ddpModels = [[NSMutableArray alloc] init];
        _maxGroupNum = NSNotFound;
    }
    
    return self;
}

@end
