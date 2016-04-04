//
//  SearchResultsController.h
//  LocalWeather
//
//  Created by Home on 3/3/16.
//  Copyright (c) 2016 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherInfo.h"



@interface SearchResultsController : UITableViewController<UISearchBarDelegate>

@property (weak, nonatomic) id delegate;
@property(strong, nonatomic) UISearchBar *searchBar;

- (instancetype)initWithNames:(NSArray *) weatherInfo;
-(void)searchDidEnd:(NSArray*)results;

@end
