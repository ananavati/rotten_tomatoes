//
//  MovieDetailsViewController.h
//  rotten_tomatoes
//
//  Created by Arpan Nanavati on 3/16/14.
//  Copyright (c) 2014 Arpan Nanavati. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ImageView.h"
#import "UINavigationController+SGProgress.h"

#import "Movie.h"

@interface MovieDetailsViewController : UIViewController

@property (strong, nonatomic) Movie *movie;

@end
