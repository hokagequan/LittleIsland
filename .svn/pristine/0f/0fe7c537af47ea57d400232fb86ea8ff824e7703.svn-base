//
//  HttpReqMgr.m
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HttpReqMgr.h"
#import "AccountMgr.h"
#import "HSURLConnection.h"
#import "HttpRspErrorUtil.h"
#import "NSDate+HSCustom.h"

@interface HttpReqMgr ()<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@end

@implementation HttpReqMgr

- (id)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)requestWithMethod:(NSString *)method params:(NSDictionary *)params completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure {
    if (!method) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/", HSURL, method]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setTimeoutInterval:25];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        NSData *data = nil;
        if (params) {
            data = [NSJSONSerialization dataWithJSONObject:params
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
            [request setHTTPBody:data];
            //        [request setValue:[NSString stringWithFormat:@"%ld", (long)data.length]
            //       forHTTPHeaderField:@"Content-Length"];
        }
        
        HSURLConnection *connection = [[HSURLConnection alloc] initWithRequest:request delegate:self];
        connection.completionCallback = completion;
        connection.failureCallback = failure;
        connection.sendData = data;
        [connection start];
    });
}

#pragma mark - Class Function
+ (instancetype)sharedInstance {
    static HttpReqMgr *_sharedHttpReqMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHttpReqMgr = [[self alloc] init];
    });
    
    return _sharedHttpReqMgr;
}

+ (void)requestCheckUser:(NSString *)userName completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure {
    [[HttpReqMgr sharedInstance] requestWithMethod:@"checkuser"
                                            params:@{@"StudentID": userName}
                                        completion:^(NSDictionary *info) {
                                            BOOL success = [info[@"LoginSuccess"] boolValue];
                                            if (success) {
                                                [AccountMgr sharedInstance].user.score = 0;
                                                if (completion) {
                                                    completion(nil);
                                                }
                                            }
                                            else {
                                                HSError *error = [HSError errorWith:HSHttpErrorCodeUserName];
                                                if (failure) {
                                                    failure(error);
                                                }
                                            }
                                        } failure:^(HSError *error) {
                                            if (failure) {
                                                failure(error);
                                            }
                                        }];
}

+ (void)requestSubmit:(NSString *)userName game:(StudyGame)game theID:(NSInteger)theID spendTime:(NSInteger)second clickNum:(NSInteger)clickNum completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"StudentID"] = userName;
    params[@"GameID"] = [NSString stringWithFormat:@"%@", @(game - 1)];
    params[@"questionid"] = [NSString stringWithFormat:@"%@", @(theID)];
    params[@"spent_time"] = [NSString stringWithFormat:@"%@", @(second)];
    
    NSInteger year, month, day, hour, min, sec;
    [[NSDate date] year:&year
                  month:&month
                    day:&day
                   hour:&hour
                    min:&min
                 second:&sec];
    params[@"submit_date"] = [NSString stringWithFormat:@"%ld-%02ld-%02ld", (long)year, (long)month, (long)day];
    params[@"submit_time"] = [NSString stringWithFormat:@"%ld:%02ld:%02ld", (long)hour, (long)min, (long)sec];
    params[@"click_no"] = [NSString stringWithFormat:@"%@", @(clickNum)];
    
    [[HttpReqMgr sharedInstance] requestWithMethod:@"submitlog"
                                            params:params
                                        completion:^(NSDictionary *info) {
                                            if (completion) {
                                                completion(info);
                                            }
                                        } failure:^(HSError *error) {
                                            if (failure) {
                                                failure(error);
                                            }
                                        }];
}

+ (void)requestGetGameData:(NSString *)userName from:(NSInteger)fromPos count:(NSInteger)count completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure {
    // 子类继承
}

#pragma mark - NSURLConnection
//- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
//    if (![connection isKindOfClass:[HSURLConnection class]]) {
//        return request;
//    }
//
//    HSURLConnection *hsConnection = (HSURLConnection *)connection;
//
//    NSMutableURLRequest *newReq = [request mutableCopy];
//    [newReq setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [newReq setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [newReq setHTTPMethod:@"POST"];
//    [newReq setHTTPBody:hsConnection.sendData];
//
//    NSLog(@"*****req: %@", [newReq allHTTPHeaderFields]);
//    NSLog(@"*****rsp: %@", response);
//
//    return newReq;
//}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//    NSLog(@"%@", [NSHTTPURLResponse localizedStringForStatusCode:((NSHTTPURLResponse *)response).statusCode]);
//    NSLog(@"%@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (![connection isKindOfClass:[HSURLConnection class]]) {
        return;
    }
    
    HSURLConnection *hsConnection = (HSURLConnection *)connection;
    [hsConnection.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if (![connection isKindOfClass:[HSURLConnection class]]) {
        return;
    }
    
    HSURLConnection *hsConnection = (HSURLConnection *)connection;
    HSError *hsError = [HSError errorWithError:error];
    if (hsConnection.failureCallback) {
        hsConnection.failureCallback(hsError);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (![connection isKindOfClass:[HSURLConnection class]]) {
        return;
    }
    
    HSURLConnection *hsConnection = (HSURLConnection *)connection;
//    NSLog(@"%@", [[NSString alloc] initWithData:hsConnection.receivedData encoding:NSUTF8StringEncoding]);
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:hsConnection.receivedData
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    if (hsConnection.completionCallback) {
        hsConnection.completionCallback(dict);
    }
}

@end
