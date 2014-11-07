//
//  EVCPostView.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/19/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCPostView.h"

@implementation EVCPostView
@synthesize postObj, postType, postTextLbl, screenNameLbl, whenLbl, postPicView, profilePicView;

- (id) initWithFrame:(CGRect)frame andPost:(Post *) pObj withPostType:(EVCPostType) type andParent:(UIViewController *) parent {
    NSLog(@"Loading a post...");
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    if (type == EVCPostTypeHasPicture) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EVCPostView_WithPicture" owner:self options:nil];
        [self addSubview:[nib lastObject]];
        
    } else {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EVCPostView_WithoutPicture" owner:self options:nil];
        [self addSubview:[nib lastObject]];
    }
    
    postObj = pObj;
    postType = type;
    self.parentViewController = parent;
    [self loadData];
    return self;
}

- (IBAction)deletePost:(id)sender {
    [(EVCGroupViewController *) _parentViewController deletePost:postObj];
}

- (BOOL) automaticallyAdjustsScrollViewInsets {
    return NO;
}

- (void) loadData {
    NSLog(@"Awoke from nib");
    if (self.postType == EVCPostTypeHasPicture) {
        [self loadPicture];
    }
    [self loadProfilePicture];
    self.postTextLbl.text = postObj.postText;
    self.screenNameLbl.text = postObj.userScreenName;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:postObj.dateTimeMillis];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
    self.whenLbl.text = [formatter stringFromDate:date];
}

- (void) loadPicture {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        if (self.postObj.servingURL != nil) {
            NSURL *imageURL = [[NSURL alloc] initWithString:self.postObj.servingURL];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                [postPicView setImage:[UIImage imageWithData:imageData]];
                
            });
        }
    });
    
}

- (void) loadProfilePicture {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        NSURL *imageURL = [[API getInstance] retrieveProfilePicture];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [profilePicView setImage:[UIImage imageWithData:imageData]];
            
        });
    });
    
}

@end
