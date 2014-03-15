//
//  MovieCell.h
//  rotten_tomatoes
//
//  Created by Arpan Nanavati on 3/14/14.
//  Copyright (c) 2014 Arpan Nanavati. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *castLabel;

@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;

@end
