//
//  GroupPrefs.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/17/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
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
            NSData *imageData = [[RestAPI getInstance] fetchImageAtRemoteURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                self.groupPicture = [UIImage imageWithData:imageData];
                
            });
        }
    });
    
}

- (NSDictionary *) groupPictureField {
    return @{FXFormFieldTitle: @"Change Group Picture", FXFormFieldAction: @"saveImage:"};
}

- (NSDictionary *) hobbiesField {
    return @{FXFormFieldTitle: @"Select Hobbies", FXFormFieldOptions: @[@"Books", @"Golf", @"Cars", @"Walking", @"Hiking", @"Wine", @"Woodworking", @"Online Card Games", @"Card Games", @"Online Games", @"Arts & Crafts", @"Prayer", @"Support Groups", @"Shopping", @"Travel", @"Local Field Trips", @"History", @"Sports"], FXFormFieldViewController: @"EVCGroupSettingsHobbiesSelectionTableViewController"};
}

- (NSArray *)extraFields
{
    return @[
             @{FXFormFieldTitle: @"Delete Group", FXFormFieldHeader: @"", FXFormFieldAction: @"deleteGroup:", @"contentView.backgroundColor": [UIColor redColor], @"textLabel.color": [UIColor whiteColor]},
             ];
}

@end
