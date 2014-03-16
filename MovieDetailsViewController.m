//
//  MovieDetailsViewController.m
//  rotten_tomatoes
//
//  Created by Arpan Nanavati on 3/16/14.
//  Copyright (c) 2014 Arpan Nanavati. All rights reserved.
//

#import "MovieDetailsViewController.h"

@interface MovieDetailsViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (strong, nonatomic) IBOutlet UILabel *castLabel;

@property (strong, nonatomic) IBOutlet UIView *detailsView;

@end

@implementation MovieDetailsViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self render];
}

- (void) render {
    // set the navbar title
    self.title = self.movie.title;
    
    [self.navigationController showSGProgressWithDuration:10];
    
    self.synopsisLabel.text = self.movie.synopsis;
    self.castLabel.text = self.movie.castText;
    
    NSURL *url = [NSURL URLWithString:self.movie.posterUrl];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [self.backgroundImage setImageWithURLRequest:urlRequest
                               placeholderImage:nil
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            self.backgroundImage.image = image;
                                            [self.navigationController finishSGProgress];
                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                            NSLog(@"Failed to download image: %@", error);
                                        }];

}

@end
