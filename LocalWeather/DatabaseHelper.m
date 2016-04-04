//
//  DatabaseHelper.m
//  LocalWeather
//
//  Created by Home on 3/5/16.
//  Copyright (c) 2016 Home. All rights reserved.
//

#import "DatabaseHelper.h"
#import "AppDelegate.h"

static NSString * const kWeatherEntityName = @"WeatherInfo";
static NSString * const kWeatherHumidityKey = @"humidity";
static NSString * const kWeatherLocationNameKey = @"locationName";
static NSString * const kWeatherObservationTimeKey = @"observationTime";
static NSString * const kWeatherDescriptionKey = @"weatherDescription";
static NSString * const kWeatherIconURLKey = @"weatherIconUrl";
static NSString * const kWeatherUpdatedOnKey = @"updatedOn";

@implementation DatabaseHelper
+(instancetype) sharedDatabaseHelper
{
    static DatabaseHelper *_sharedInstance;
    static dispatch_once_t one;
    dispatch_once(&one, ^{
        _sharedInstance = [[DatabaseHelper alloc] init];
    });
    return _sharedInstance;
}

-(NSArray *)getLastestWeatherInfo
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:kWeatherEntityName];
    NSSortDescriptor *sortDescription = [NSSortDescriptor sortDescriptorWithKey:kWeatherUpdatedOnKey ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescription]];
    [request setFetchLimit:10];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error]; if (objects == nil) {
        NSLog(@"There was an error!");
        // Do whatever error handling is appropriate
        return nil;
    }
    
    NSMutableArray *weatherInfos = [[NSMutableArray alloc] init];
    for (NSManagedObject *oneObject in objects) {
        WeatherInfo *w =  [[WeatherInfo alloc] init];
        w.humidity= [oneObject valueForKey:kWeatherHumidityKey];
        w.nameLocation = [oneObject valueForKey:kWeatherLocationNameKey];
        w.observationTime = [oneObject valueForKey:kWeatherObservationTimeKey];
        w.weatherDescription = [oneObject valueForKey:kWeatherDescriptionKey];
        w.weatherIconUrl = [oneObject valueForKey:kWeatherIconURLKey];
        [weatherInfos addObject:w];
    }
    
    return weatherInfos;
}

-(void) storeWeatherInfo:(WeatherInfo *)weatherInfo
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:kWeatherEntityName];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(%K = %@)", kWeatherLocationNameKey, weatherInfo.nameLocation];
    [request setPredicate:pred];
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (objects == nil) {
        NSLog(@"There was an error!");
        // Do whatever error handling is appropriate
    }
    NSManagedObject *weatherObject = nil;
    if ([objects count] > 0) {
        weatherObject = [objects objectAtIndex:0];
    } else {
        weatherObject = [NSEntityDescription insertNewObjectForEntityForName:kWeatherEntityName inManagedObjectContext:context];
    }
    [weatherObject setValue:weatherInfo.nameLocation forKey:kWeatherLocationNameKey];
    [weatherObject setValue:weatherInfo.humidity forKey:kWeatherHumidityKey];
    [weatherObject setValue:weatherInfo.observationTime forKey:kWeatherObservationTimeKey];
    [weatherObject setValue:weatherInfo.weatherDescription forKey:kWeatherDescriptionKey];
    [weatherObject setValue:weatherInfo.weatherIconUrl forKey:kWeatherIconURLKey];
    [weatherObject setValue:weatherInfo.updatedOn forKey:kWeatherUpdatedOnKey];
    
    [appDelegate saveContext];
}

-(NSArray *) getWeatherInfoWithLocation:(NSString *) locationName
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:kWeatherEntityName];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K = %@", kWeatherLocationNameKey, locationName];
    [request setPredicate:pred];
    NSArray *weathers = [context executeFetchRequest:request error:&error];
    if(weathers == nil)
    {
        NSLog(@"There was an error!");
    }
    
    NSMutableArray *weatherArray = [[NSMutableArray alloc] init];
    for (NSManagedObject *object in weathers) {
        WeatherInfo *w = [[WeatherInfo alloc] init];
        w.humidity= [object valueForKey:kWeatherHumidityKey];
        w.nameLocation = [object valueForKey:kWeatherLocationNameKey];
        w.observationTime = [object valueForKey:kWeatherObservationTimeKey];
        w.weatherDescription = [object valueForKey:kWeatherDescriptionKey];
        w.weatherIconUrl = [object valueForKey:kWeatherIconURLKey];
        w.updatedOn = [object valueForKey:kWeatherUpdatedOnKey] ;
        [weatherArray addObject:w];
    }
    return weatherArray;
    
}
@end
