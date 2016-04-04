//
//  WeatherInfo.h
//  LocalWeather
//
//  Created by Home on 3/4/16.
//  Copyright (c) 2016 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherInfo : NSObject

@property(strong, nonatomic) NSString *nameLocation;
@property(strong, nonatomic) NSString *weatherIconUrl;
@property(strong, nonatomic) NSString *humidity;
@property(strong, nonatomic) NSString *weatherDescription;
@property(strong, nonatomic) NSString *observationTime;
@property(strong,nonatomic) NSNumber *updatedOn;

-(instancetype) initWithDictionary:(NSDictionary *)dict;

@end
