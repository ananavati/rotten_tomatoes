//
//  MoviesListViewController.h
//  rotten_tomatoes
//
//  Created by Arpan Nanavati on 3/14/14.
//  Copyright (c) 2014 Arpan Nanavati. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UINavigationBarAlert.h"
#import "UINavigationController+SGProgress.h"

#import "MovieCell.h"
#import "Movie.h"
#import "ImageView.h"
#import "MovieDetailsViewController.h"

@interface MoviesListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@end
