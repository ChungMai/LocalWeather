//
//  CurrentWeatherInfo.m
//  LocalWeather
//
//  Created by Home on 3/4/16.
//  Copyright (c) 2016 Home. All rights reserved.
//

#import "CurrentWeatherInfo.h"

@implementation CurrentWeatherInfo

+(instancetype)sharedCurrentWeatherInfo
{
    static CurrentWeatherInfo *sharedInstance = nil;
    static dispatch_once_t one;
    dispatch_once(&one,^{
        sharedInstance = [[CurrentWeatherInfo alloc] init]; 
    });
    return sharedInstance;
}

-(instancetype) init
{
    if(self = [super init])
    {
        self.weatherInfoArray = [[NSArray alloc] init];
        self.isSearchButtonClicked = YES;
    }
    return self;
}
@end
