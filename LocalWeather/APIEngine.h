//
//  InstagramEngine.h
//  GetImageFromInstagram
//
//  Created by Home on 12/10/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface APIEngine : AFHTTPSessionManager
/*!
 @abstract Gets the singleton instance.
 */
+ (instancetype)sharedEngine;

- (NSURLSessionDataTask *)searchLocalWeather:(NSString *)location withType:(NSInteger) typeSearch completion:( void (^)(NSDictionary *results, NSError *error) )completion;

-(void) checkingNetworkConnection;

// Feature 1 New Update 1.1
// Feature 1 New Update 2.2
@end
