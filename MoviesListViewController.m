//
//  MoviesListViewController.m
//  rotten_tomatoes
//
//  Created by Arpan Nanavati on 3/14/14.
//  Copyright (c) 2014 Arpan Nanavati. All rights reserved.
//

#import "MoviesListViewController.h"

@interface MoviesListViewController()

@property (strong, nonatomic) NSMutableArray *movies;
@property (strong, nonatomic) NSArray *nibObjects;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MoviesListViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    
    UINib *movieCellNib = [UINib nibWithNibName:@"MovieListCellView" bundle:nil];
    [self.tableView registerNib:movieCellNib forCellReuseIdentifier:@"MovieCell"];
}

-(void) initialize {
    self.movies = [[NSMutableArray alloc] init];
    [self getData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.movies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MovieCell";
    MovieCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Movie *movie = self.movies[indexPath.row];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:movie.thumbUrl, indexPath.row]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    // set the cell attributes
    cell.titleLabel.text = movie.title;
    cell.synopsisLabel.text = movie.synopsis;
    cell.castLabel.text = movie.castText;
    
    [cell.movieImageView setImageWithURLRequest:urlRequest
                               placeholderImage:nil
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            cell.movieImageView.image = image;
                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                            NSLog(@"Failed to download image: %@", error);
                                        }];
    
    return cell;
}

-(void) getData {
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=87mrtv95egu4cfx6s6x9yqm8";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError) {
            // throw the network error popup
        }
        
        NSDictionary *movies = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [self.movies removeAllObjects];
        
        for (NSDictionary *movie in movies[@"movies"]) {
            [self.movies addObject:[[Movie alloc] initWithDictionary:movie]];
        };
        
        [self.tableView reloadData];
        
    }];
}

@end
