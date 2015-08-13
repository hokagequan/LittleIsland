//
//  HttpReqMgr.h
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSURLConnection.h"
#import "HSError.h"

@interface HttpReqMgr : NSObject

+ (instancetype)sharedInstance;

+ (void)requestCheckUser:(NSString *)userName completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure;
+ (void)requestSubmit:(NSString *)userName game:(StudyGame)game theID:(NSInteger)theID spendTime:(NSInteger)second clickNum:(NSInteger)clickNum completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure;
+ (void)requestGetGameData:(NSString *)userName from:(NSInteger)fromPos count:(NSInteger)count completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure;

- (void)requestWithMethod:(NSString *)method params:(NSDictionary *)params completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure;

@end
