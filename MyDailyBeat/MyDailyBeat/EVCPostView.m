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
                self.mediaFocusManager = [[ASMediaFocusManager alloc] init];
                self.mediaFocusManager.delegate = self;
                [self.mediaFocusManager installOnView:postPicView];
                self.mediaFocusManager.defocusOnVerticalSwipe = YES;
                
            });
        }
    });
    
}

- (void) loadProfilePicture {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        NSURL *imageURL = [[RestAPI getInstance] retrieveProfilePicture];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [profilePicView setImage:[UIImage imageWithData:imageData]];
            
        });
    });
    
}

#pragma mark - ASMediaFocusDelegate
// Returns the view controller in which the focus controller is going to be added.
// This can be any view controller, full screen or not.
- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediaFocusManager
{
    return self.parentViewController;
}

// Returns the URL where the media (image or video) is stored. The URL may be local (file://) or distant (http://).
- (NSURL *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager mediaURLForView:(UIView *)view
{
    NSURL *imageURL = [[NSURL alloc] initWithString:self.postObj.servingURL];
    
    return imageURL;
}

// Returns the title for this media view. Return nil if you don't want any title to appear.
- (NSString *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager titleForView:(UIView *)view
{
    return nil;
}

- (void)mediaFocusManagerWillAppear:(ASMediaFocusManager *)mediaFocusManager
{
    self.parentViewController.navigationController.navigationBar.hidden = TRUE;
}

- (void)mediaFocusManagerWillDisappear:(ASMediaFocusManager *)mediaFocusManager
{
    self.parentViewController.navigationController.navigationBar.hidden = FALSE;
}

@end
