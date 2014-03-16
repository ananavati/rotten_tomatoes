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
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void)onRefresh:(id)sender forState:(UIControlState)state;

@end

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.5]

@implementation MoviesListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Movies";
    }
    return self;
}

- (void)onRefresh:(id)sender forState:(UIControlState)state {
    [self.refreshControl endRefreshing];
    
    [self getData];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
}

- (void) viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
    
    NSArray *cells = [self.tableView visibleCells];
    
    for (UITableViewCell *cell in cells) {
        cell.backgroundColor = [UIColor whiteColor];
    }
}


-(void) initialize {
    self.movies = [[NSMutableArray alloc] init];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector( onRefresh:forState: ) forControlEvents:UIControlEventValueChanged];
    // not sure if this is the right way to add refresh control
    [self.tableView addSubview:self.refreshControl];
    
    UINib *movieCellNib = [UINib nibWithNibName:@"MovieListCellView" bundle:nil];
    [self.tableView registerNib:movieCellNib forCellReuseIdentifier:@"MovieCell"];
    
    [self getData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.movies count];
}

// Tap on table Row
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
//    NSLog(@"tapped on row: %ld", indexPath.row);
    NSArray *cells = [self.tableView visibleCells];
    
    UITableViewCell *currentcell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    for (UITableViewCell *cell in cells) {
        cell.backgroundColor = [UIColor whiteColor];
        if ([cell isEqual:currentcell] == NO) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            cell.alpha = 0.5;
            [UIView commitAnimations];
        }
        else {
            [UIView animateWithDuration:0.2f
                                  delay:0.0f
                                options:UIViewAnimationCurveEaseInOut
                             animations:^{
                                 cell.alpha = 1.0;
                                 cell.backgroundColor = UIColorFromRGB(0xF39C12);
                             }
                             completion:^(BOOL finished) {
                                 MovieDetailsViewController *detailsController = [[MovieDetailsViewController alloc] init];
                                 
                                 Movie *movie = self.movies[indexPath.row];
                                 [detailsController setMovie:movie];
                                 
                                 [self.navigationController pushViewController:detailsController animated:YES];
                             }];
        }
    }
}

// Tap on row accessory
- (void) tableView: (UITableView *) tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *) indexPath{
//    NSLog(@"tapped on row: %ld", indexPath.row);
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
    [self.navigationController showSGProgressWithDuration:3];
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=87mrtv95egu4cfx6s6x9yqm8";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError) {
            // throw the network error popup
            [self.navigationController finishSGProgress];
            [self.refreshControl endRefreshing];
            
            // show the network error in the navbar alert view
            [self.navigationController.navigationBar showAlertWithTitle:@"Network Error"];
        } else {
            NSDictionary *movies = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            [self.movies removeAllObjects];
            
            for (NSDictionary *movie in movies[@"movies"]) {
                [self.movies addObject:[[Movie alloc] initWithDictionary:movie]];
            };
            
            [self.tableView reloadData];
            
            [self.navigationController.navigationBar hideAlert];
            [self.navigationController finishSGProgress];
        }
    }];
}

@end
