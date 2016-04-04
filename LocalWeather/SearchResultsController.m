//
//  SearchResultsController.m
//  LocalWeather
//
//  Created by Home on 3/3/16.
//  Copyright (c) 2016 Home. All rights reserved.
//

#import "SearchResultsController.h"
#import "APIEngine.h"
#import "CurrentWeatherInfo.h"
#import "WeatherInfoTableCellTableViewCell.h"
#import "DatabaseHelper.h"
#import "ViewController.h"

static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
@interface SearchResultsController ()
@property (copy, nonatomic) NSArray *weatherInfos;
@property (strong, nonatomic) APIEngine *apiEngine;
@property (strong, nonatomic) CurrentWeatherInfo *curWeatherInfo;
@property (strong, nonatomic) DatabaseHelper *databaseHelper;
@property (assign, nonatomic) BOOL isIgnore;

@end

@implementation SearchResultsController

- (instancetype)initWithNames:(NSArray *) weatherInfo {
    if (self = [super init]){
        
        //self.weatherInfos = [weatherInfo copy];
        self.curWeatherInfo = [CurrentWeatherInfo sharedCurrentWeatherInfo];
        self.databaseHelper = [DatabaseHelper sharedDatabaseHelper];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //Delegate search bar in mainpac controll to self.searchBar
    self.apiEngine = [APIEngine sharedEngine];
    self.searchBar.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"WeatherInfoTableCellTableViewCell" bundle:nil] forCellReuseIdentifier:SectionsTableIdentifier];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchText= searchBar.text;
    NSInteger searchType= searchBar.selectedScopeButtonIndex;
    
    self.curWeatherInfo.currentSearchType = searchBar.selectedScopeButtonIndex;
    self.curWeatherInfo.isSuccess = NO;
    self.curWeatherInfo.isSearchButtonClicked = NO;
    
    //
    __weak typeof(self) weakSelf = self;
    [self.apiEngine searchLocalWeather:searchText withType:searchType completion:^(NSDictionary *results, NSError *error){
        UIAlertView *alert;
        typeof(self) theSelf = weakSelf;
        if (results) {
            NSDictionary *error = [[results objectForKey:@"data"] objectForKey:@"error"];
            if(error){
                //Location is not valid
                theSelf.curWeatherInfo.isSearchButtonClicked = YES;
                alert = [[UIAlertView alloc] initWithTitle:@"Information" message:[[error valueForKey:@"msg"] componentsJoinedByString:@""] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            else{
                //Save data and back to main View
                theSelf.curWeatherInfo.isSuccess = YES;
                theSelf.curWeatherInfo.isSearchButtonClicked = YES;
                WeatherInfo *weatherInfo = [[WeatherInfo alloc] initWithDictionary:results];
                theSelf.curWeatherInfo.weatherInfoArray = [[NSArray alloc] initWithObjects:weatherInfo, nil];
                theSelf.curWeatherInfo.currentSearchText = weatherInfo.nameLocation;
                
                dispatch_sync(dispatch_get_global_queue(0, 0), ^{
                    [theSelf.databaseHelper storeWeatherInfo:weatherInfo];
                });
            }
        }
        else{
            //Occurred the exception
            theSelf.curWeatherInfo.isSearchButtonClicked = YES;
            alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo objectForKey:@"NSLocalizedDescription"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        [self searchBarTextDidEndEditing:searchBar];
    }];
}

#pragma mark - Search Bar Delegate

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    //Delegate to View Controller to process
    if ([_delegate respondsToSelector:@selector(searchDidEnd:)]) {
        [_delegate searchDidEnd:nil];
    }
}

-(void)searchDidEnd:(NSArray*)results
{
    NSLog(@"SearchResultsController searchDidEnd");
};

#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //Don't need to display table
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    WeatherInfoTableCellTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SectionsTableIdentifier forIndexPath:indexPath];
    WeatherInfo *w = (WeatherInfo *)[self.curWeatherInfo.weatherInfoArray objectAtIndex:indexPath.row];
    cell.location.text = w.nameLocation;
    cell.humidity.text = w.humidity;
    cell.observeTime.text = w.observationTime;
    cell.weatherDescription.text = w.weatherDescription;
    NSData *data = [[NSData alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:w.weatherIconUrl]];
    cell.imageView.image = [UIImage imageWithData:data];
    return cell;
     */
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 155.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    NSLog(@"Dealloc called");
}

@end
