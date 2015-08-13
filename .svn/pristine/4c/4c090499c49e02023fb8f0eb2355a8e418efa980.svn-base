//
//  CGMgr.m
//  HappyStudy
//
//  Created by Q on 14-10-15.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "CGMgr.h"

@implementation CGMgr

+ (instancetype)sharedInstance {
    static CGMgr *_sharedCGMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCGMgr = [[self alloc] init];
    });
    
    return _sharedCGMgr;
}

- (id)init {
    if (self = [super init]) {
        _chooseModels = [[NSMutableArray alloc] init];
        _maxGroupNum = NSNotFound;
    }
    
    return self;
}

@end
