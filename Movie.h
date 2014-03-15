//
//  Movie.h
//  rotten_tomatoes
//
//  Created by Arpan Nanavati on 3/15/14.
//  Copyright (c) 2014 Arpan Nanavati. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (weak, nonatomic) NSString *title;

- (Movie *)initWithDictionary: (NSDictionary *)movie;

@end
