//
//  CurrentWeatherInfo.h
//  LocalWeather
//
//  Created by Home on 3/4/16.
//  Copyright (c) 2016 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherInfo.h"

@interface CurrentWeatherInfo : NSObject

+(instancetype)sharedCurrentWeatherInfo;
@property(strong, nonatomic) NSArray *weatherInfoArray;
@property(strong, nonatomic) NSString *currentSearchText;
@property(assign, nonatomic) NSInteger currentSearchType;
@property(assign, nonatomic) BOOL isSuccess;
@property(assign, nonatomic) BOOL isSearchButtonClicked;
@end
