//
//  InstagramEngine.m
//  GetImageFromInstagram
//
//  Created by Home on 12/10/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "APIEngine.h"
#import "AFHTTPSessionManager.h"
#import "AFURLResponseSerialization.h"
#import "AFURLRequestSerialization.h"


@interface APIEngine()

@property (nonatomic, strong) AFHTTPSessionManager *httpManager;
@property (nonatomic, strong) dispatch_queue_t backgroundQueue;

@end

@implementation APIEngine

+ (instancetype)sharedEngine {
    static APIEngine *_sharedEngine = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSURL *baseURL = [NSURL URLWithString:@"http://api.worldweatheronline.com/free/v2/weather.ashx"];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _sharedEngine = [[APIEngine alloc] initWithBaseURL:baseURL sessionConfiguration:config];
        _sharedEngine.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    return _sharedEngine;
}


- (NSURLSessionDataTask *)searchLocalWeather:(NSString *)location withType:(NSInteger) typeSearch completion:( void (^)(NSDictionary *results, NSError *error) )completion
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:(typeSearch == 0 ? @"dd5bc7742928d1633213b5da075ec" : @"f16c45e7217c8641fa4d5ae8e2415"),@"key",@"yes",@"fx",@"json",@"format",@"24",@"tp",@"1",@"num_of_days",location,@"q",nil];
    NSURLSessionDataTask *task = [self GET:@"/free/v2/weather.ashx"
                                parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                    if (httpResponse.statusCode == 200) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            completion(responseObject, nil);
                                        });
                                    } else {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            completion(nil, nil);
                                        });
                                    }
                                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        completion(nil, error);
                                    });
                                }];
    return task;
    
}

-(void) checkingNetworkConnection
{
    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];
    [reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         switch (status) {
             case AFNetworkReachabilityStatusReachableViaWWAN:
                 NSLog(@"----Connection WWAN");
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 NSLog(@"----WIFI");
                 break;
             case AFNetworkReachabilityStatusNotReachable:
                 NSLog(@"----Not Reachable");
                 break;
             case AFNetworkReachabilityStatusUnknown:
                 NSLog(@"----Unknow");
                 break;
             default:
                 NSLog(@"----Default");
                 break;
         }
     }];
    NSLog(reachability.isReachable? @"Yes" : @"No");
}
@end
