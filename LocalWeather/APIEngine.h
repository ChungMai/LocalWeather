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

// Feature 1 New Update 1.2
// Feature 1 New Update 2.2
<<<<<<< HEAD
// Feature 1 New Update 2.7
=======
// Feature 1 New Update 2.6
>>>>>>> 88fc8f39f92a6282a5bff4ccd1fe19cd88c6854d
@end
