//
//  Movie.m
//  rotten_tomatoes
//
//  Created by Arpan Nanavati on 3/15/14.
//  Copyright (c) 2014 Arpan Nanavati. All rights reserved.
//

#import "Movie.h"

@interface Movie ()

@property NSDictionary *movie;
@property NSMutableArray *castMembers;

@end

@implementation Movie

- (Movie *)initWithDictionary:(NSDictionary *)movie
{
    self = [super init];
    
	if (self) {
		self.movie = movie;
        
		[self setTitle:self.movie[@"title"]];
		[self setSynopsis:self.movie[@"synopsis"]];
		[self setThumbUrl:self.movie[@"posters"][@"profile"]];
        
        // TODO: arpan investigate more into the memory spike
        // loading the original JPG causes a 20MB spike in memory ?!
        // original JPG size is not that big when saved on disk
		[self setPosterUrl:self.movie[@"posters"][@"detailed"]];

		self.castMembers = [[NSMutableArray alloc] init];
		for (NSDictionary *cast in self.movie[@"abridged_cast"]) {
			[self.castMembers addObject:cast[@"name"]];
		}
	}
    
	return self;
}

- (NSString *)castText
{
	return [self.castMembers componentsJoinedByString:@", "];
}


@end
