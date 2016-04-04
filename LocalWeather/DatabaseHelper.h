//
//  DatabaseHelper.h
//  LocalWeather
//
//  Created by Home on 3/5/16.
//  Copyright (c) 2016 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherInfo.h"

@interface DatabaseHelper : NSObject

+(instancetype) sharedDatabaseHelper;
-(NSArray *) getLastestWeatherInfo;
-(void) storeWeatherInfo:(WeatherInfo *) weatherInfo;
-(NSArray *) getWeatherInfoWithLocation:(NSString *) locationName;
@end
