//
//  WeatherInfoTableCellTableViewCell.h
//  LocalWeather
//
//  Created by Home on 3/5/16.
//  Copyright (c) 2016 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"

@interface WeatherInfoTableCellTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet MarqueeLabel *location;
@property(weak, nonatomic) IBOutlet UILabel *humidity;
@property(weak, nonatomic) IBOutlet UILabel *observeTime;
@property(weak, nonatomic) IBOutlet UILabel *weatherDescription;
@property(weak, nonatomic) IBOutlet UIImageView *iconImage;

@end
