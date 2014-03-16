//
//  MovieImageView.m
//  rotten_tomatoes
//
//  Created by Arpan Nanavati on 3/15/14.
//  Copyright (c) 2014 Arpan Nanavati. All rights reserved.
//

#import "ImageView.h"

@interface ImageView()

@property (strong, nonatomic) NSString *filePath;

@end

@implementation ImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (NSString *)cachedImageFilePathForURL:(NSString *)url
{
    NSString *fileName = [url lastPathComponent];
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *pathExtension = [fileName pathExtension];
    NSRange extensionRange = [fileName rangeOfString:pathExtension];
    NSString *cachedFileName = [fileName stringByReplacingCharactersInRange:extensionRange withString:@"jpg"];
    NSString *cachedFilePath = [cachePath stringByAppendingPathComponent:cachedFileName];
    
    return cachedFilePath;
}

- (void)setImageWithURL:(NSString *)url
       placeholderImage:(UIImage *)placeholderImage
                success:(void (^)(BOOL cachedImage))success
                failure:(void (^)(void))failure
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _filePath = [self cachedImageFilePathForURL:url];
        if ([[NSFileManager defaultManager] fileExistsAtPath:_filePath]) {
            UIImage *image = [UIImage imageWithContentsOfFile:_filePath];
            self.image = image;
            if (self.image) {
                success(YES);
            } else {
                failure();
            }
        } else {
            self.image = nil; // As we probably don't want to view an old image while downloading a new one
            NSString *filePath = [_filePath copy];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            [self setImageWithURLRequest:urlRequest
                        placeholderImage:nil
                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                     self.image = image;
                                     NSError *error = nil;
                                     [UIImageJPEGRepresentation(image, 0.8) writeToFile:filePath options:NSDataWritingAtomic error:&error];
                                     if (error) {
                                         NSLog(@"Error saving image: %@", error);
                                     }
                                     success(NO);
                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                     failure();
                                 }];
        }
    });
}


@end
