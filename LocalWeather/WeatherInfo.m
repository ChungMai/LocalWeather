//
//  WeatherInfo.m
//  LocalWeather
//
//  Created by Home on 3/4/16.
//  Copyright (c) 2016 Home. All rights reserved.
//

#import "WeatherInfo.h"

@implementation WeatherInfo

-(instancetype) initWithDictionary:(NSDictionary *)dict
{
    if(self = [super init])
    {
        [self getFullLocationNameWithDictionary:[[dict objectForKey:@"data"] objectForKey:@"request"]];
        [self getWeatherWithDictionary:[[dict objectForKey:@"data"] objectForKey:@"current_condition"]];
    }
    return self;
}

-(void) getWeatherWithDictionary:(NSDictionary *) dict
{
    self.humidity = [[dict valueForKey:@"humidity"] componentsJoinedByString:@""];
    self.observationTime = [[dict valueForKey:@"observation_time"] componentsJoinedByString:@""];
    
    NSDictionary *weatherIconUrlDict = [[dict valueForKey:@"weatherIconUrl"] objectAtIndex:0];
    self.weatherIconUrl = [[weatherIconUrlDict valueForKey:@"value"] componentsJoinedByString:@""];
    
    NSDictionary *weatherDescriptionDict = [[dict valueForKey:@"weatherDesc"] objectAtIndex:0];
    self.weatherDescription = [[weatherDescriptionDict valueForKey:@"value"] componentsJoinedByString:@""];
    self.updatedOn = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
}

-(void) getFullLocationNameWithDictionary:(NSDictionary *) dict
{
    self.nameLocation = [[dict valueForKey:@"query"] componentsJoinedByString:@""];
}
@end
