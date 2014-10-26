//
//  GroupPrefs.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 10/26/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "GroupPrefs.h"

@implementation GroupPrefs

- (id) initWithServingURL:(NSString *) servingURL {
    self = [super init];
    if (self) {
        [self loadPictureWithServingURL:servingURL];
    }
    return self;
}

- (void) loadPictureWithServingURL:(NSString *) servingURL {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        if (servingURL != nil) {
            NSURL *imageURL = [[NSURL alloc] initWithString:servingURL];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                self.groupPicture = [UIImage imageWithData:imageData];
                
            });
        }
    });
    
}

- (NSDictionary *) groupPictureField {
    return @{FXFormFieldTitle: @"Change Group Picture"};
}

@end
