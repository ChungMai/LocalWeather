//
//  ViewController.m
//  LocalWeather
//
//  Created by Home on 3/3/16.
//  Copyright (c) 2016 Home. All rights reserved.
//

#import "ViewController.h"
#import "SearchResultsController.h"
#import "APIEngine.h"
#import "CurrentWeatherInfo.h"
#import "WeatherInfoTableCellTableViewCell.h"
#import "WeatherInfo.h"
#import "DatabaseHelper.h"


static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) APIEngine *apiEngine;
@property (strong, nonatomic) CurrentWeatherInfo *curWeathherInfo;
@property (strong, nonatomic) DatabaseHelper *databaseHelper;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WeatherInfoTableCellTableViewCell" bundle:nil] forCellReuseIdentifier:SectionsTableIdentifier];
    
    //declare variables
    self.curWeathherInfo = [CurrentWeatherInfo sharedCurrentWeatherInfo];
    self.databaseHelper = [DatabaseHelper sharedDatabaseHelper];
    self.curWeathherInfo.weatherInfoArray = [self.databaseHelper getLastestWeatherInfo];
    
    //Add search bar
    SearchResultsController *resultsController =[[SearchResultsController alloc] initWithNames:nil];
    resultsController.delegate = self;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:resultsController];
    UISearchBar *searchBar = self.searchController.searchBar;
    searchBar.scopeButtonTitles = @[@"Weather Search", @"Awesome Weather"];
    searchBar.placeholder = @"Enter a search term";
    [searchBar sizeToFit];
    self.tableView.tableHeaderView = searchBar;
    
    //Add Referesh Controller
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refresheWeatherInfomation) forControlEvents:UIControlEventValueChanged];
    
    //Assign the current search bar to UISearchBar in SearchResultsController to delegate and call searchBarSearchButtonClicked function
    resultsController.searchBar = searchBar;

    self.apiEngine = [APIEngine sharedEngine];
    
}

-(void) refresheWeatherInfomation
{
    __weak typeof(self) weakSelf = self;
    [self.apiEngine searchLocalWeather:self.curWeathherInfo.currentSearchText withType:self.curWeathherInfo.currentSearchType completion:^(NSDictionary *results, NSError *error){
        UIAlertView *alert;
        typeof(self) theSelf = weakSelf;
        if (results) {
            NSDictionary *error = [[results objectForKey:@"data"] objectForKey:@"error"];
            //Location isn't valid
            if(error){
                [theSelf.refreshControl endRefreshing];
                alert = [[UIAlertView alloc] initWithTitle:@"Information" message:[[error valueForKey:@"msg"] componentsJoinedByString:@""] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            else{
                //update database and reload table
                WeatherInfo *weatherInfo = [[WeatherInfo alloc] initWithDictionary:results];
                theSelf.curWeathherInfo.weatherInfoArray = [[NSArray alloc] initWithObjects:weatherInfo, nil];
                [theSelf.tableView reloadData];
                dispatch_sync(dispatch_get_global_queue(0, 0), ^{
                    [theSelf.databaseHelper storeWeatherInfo:weatherInfo];
                });
                [theSelf.refreshControl endRefreshing];
            }
        }
        else{
            //Occurred the exception
            [theSelf.refreshControl endRefreshing];
            alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo objectForKey:@"NSLocalizedDescription"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

//Get new data to display
-(void)searchDidEnd:(NSArray*) arrays
{
    self.searchController.active = FALSE;
    if(self.curWeathherInfo.isSearchButtonClicked){
        if(self.curWeathherInfo.isSuccess){
            self.curWeathherInfo.weatherInfoArray = [self.databaseHelper getWeatherInfoWithLocation:self.curWeathherInfo.currentSearchText];
        }
        else{
            self.curWeathherInfo.weatherInfoArray = [self.databaseHelper getLastestWeatherInfo];
        }
    }
    else{
        self.curWeathherInfo.weatherInfoArray = nil;
    }
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.curWeathherInfo.weatherInfoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeatherInfoTableCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SectionsTableIdentifier forIndexPath:indexPath];
    WeatherInfo *w = (WeatherInfo *)self.curWeathherInfo.weatherInfoArray[indexPath.row];
    
    cell.location.text = w.nameLocation;
    cell.location.marqueeType = MLContinuous;
    cell.location.scrollDuration = 15.0;
    cell.humidity.text = w.humidity;
    cell.observeTime.text = w.observationTime;
    cell.weatherDescription.text = w.weatherDescription;
    
    // Use progress background to retrieve image from the url
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:w.weatherIconUrl]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{ 
            cell.iconImage.image = [UIImage imageWithData:data];
        });
    });
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
  
    NSLog(@"End table");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
