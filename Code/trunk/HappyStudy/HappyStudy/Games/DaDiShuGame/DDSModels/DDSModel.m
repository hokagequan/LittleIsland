//
//  DDSModel.m
//  EasyLSP
//
//  Created by Quan on 15/5/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "DDSModel.h"

@implementation DDSModel

#pragma mark - Property
- (NSMutableArray *)options {
    if (!_options) {
        _options = [NSMutableArray arrayWithCapacity:4];
    }
    
    return _options;
}

@end
