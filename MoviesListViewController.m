//
//  MoviesListViewController.m
//  rotten_tomatoes
//
//  Created by Arpan Nanavati on 3/14/14.
//  Copyright (c) 2014 Arpan Nanavati. All rights reserved.
//

#import "MoviesListViewController.h"
#import "Movie.h"

@interface MoviesListViewController()

@property (strong, nonatomic) NSMutableArray *movies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MoviesListViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"MoviesListView" bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma - private methods

-(void) initialize {
    self.movies = [[NSMutableArray alloc] init];
    [self getData];
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"movieCell";
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Movie *movie;

    if (!cell) {
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"MovieListCellView" owner:nil options:nil];
        cell = [nibObjects objectAtIndex:0];
    }
    
    if (self.movies.count > 0) {
        movie = self.movies[indexPath.row];
        
        // set the cell attributes
        cell.titleLabel.text = movie.title;
    }
    
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
