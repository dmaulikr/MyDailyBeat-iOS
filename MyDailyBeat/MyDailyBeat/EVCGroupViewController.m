//
//  EVCGroupViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/25/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCGroupViewController.h"

@interface EVCGroupViewController ()

@end

@implementation EVCGroupViewController

- (id) initWithGroup:(Group *) g {
    self = [self initWithNibName:@"EVCGroupViewController_iPhone" bundle:nil];
    if (self) {
        self.group = g;
    }
    return self;
}

- (void) refreshGroupData {
    
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
            self.group.posts = [[API getInstance] getPostsForGroup:self.group];
            [self.view hideToastActivity];
        });
    });
}

- (IBAction)writePost:(id)sender {
    REComposeViewController *composeNewPost = [[REComposeViewController alloc] init];
    composeNewPost.title = @"New Post";
    composeNewPost.hasAttachment = YES;
    composeNewPost.delegate = self;
    [composeNewPost presentFromViewController:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scroll = [[GTScrollViewController alloc] initWithFrame:CGRectMake(0, 172, 320, 307)];
    [self.view addSubview:self.scroll.view];
    [self addChildViewController:self.scroll];
    [self.scroll setBackgroundImage:[UIImage imageNamed:@"texture.png"]];
    [self.scroll setShadowRadius:3 shadowOpacity:0.5 andCornerRadius:2];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.imageView.layer.shadowColor = [UIColor purpleColor].CGColor;
    self.imageView.layer.shadowOffset = CGSizeMake(0, 1);
    self.imageView.layer.shadowOpacity = 1;
    self.imageView.layer.shadowRadius = 1.0;
    self.imageView.clipsToBounds = NO;
    

    self.screenNameLbl.text = self.group.groupName;
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshGroupData];
    [self loadPicture];
    [self loadPosts];
}

- (void) loadPicture {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        if (self.group.servingURL != nil) {
            NSURL *imageURL = [[NSURL alloc] initWithString:self.group.servingURL];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                [self.imageView setImage:[UIImage imageWithData:imageData]];
                
            });
        }
    });
    
}

- (void) loadPosts {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = [self.group.posts count] ; i > 0 ; --i) {
                [self.scroll addView:[self createViewForPost:[self.group.posts objectAtIndex:i]]];
            }
            
        });
    });
    
}

- (UIView *) createViewForPost: (Post *) inputPost {
    UIView *postView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 120)];
    [postView setBackgroundColor:[UIColor whiteColor]];
    if (inputPost.blobKey != nil) {
        [postView setFrame:CGRectMake(0, 0, 300, 335)];
        NSURL *imageURL = [[NSURL alloc] initWithString:inputPost.servingURL];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 120, 120)];
        UIImageView *postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 130, 290, 200)];
        [postImageView setImage:[UIImage imageWithData:imageData]];
        UILabel *userNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(130, 10, 170, 10)];
        userNameLbl.text = inputPost.userScreenName;
        UILabel *postTextLbl = [[UILabel alloc] initWithFrame:CGRectMake(130, 30, 170, 10)];
        postTextLbl.text = inputPost.postText;
        UILabel *whenLbl = [[UILabel alloc] initWithFrame:CGRectMake(130, 50, 170, 10)];
        double startDateDb=inputPost.dateTimeMillis;
        NSDate *date=[NSDate dateWithTimeIntervalSince1970:(startDateDb/1000.0)];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        
        [dateFormatter setLocale:usLocale];
        
        whenLbl.text = [@"Posted: " stringByAppendingString:[dateFormatter stringFromDate:date]];
        [postView addSubview:userImageView];
        [postView addSubview:postImageView];
        [postView addSubview:userNameLbl];
        [postView addSubview:postTextLbl];
        [postView addSubview:whenLbl];
        
        
    } else {
        [postView setFrame:CGRectMake(0, 0, 300, 130)];
        UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 120, 120)];
        UILabel *userNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(130, 10, 170, 10)];
        userNameLbl.text = inputPost.userScreenName;
        UILabel *postTextLbl = [[UILabel alloc] initWithFrame:CGRectMake(130, 30, 170, 10)];
        postTextLbl.text = inputPost.postText;
        UILabel *whenLbl = [[UILabel alloc] initWithFrame:CGRectMake(130, 50, 170, 10)];
        double startDateDb=inputPost.dateTimeMillis;
        NSDate *date=[NSDate dateWithTimeIntervalSince1970:(startDateDb/1000.0)];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        
        [dateFormatter setLocale:usLocale];
        
        whenLbl.text = [@"Posted: " stringByAppendingString:[dateFormatter stringFromDate:date]];
        [postView addSubview:userImageView];
        [postView addSubview:userNameLbl];
        [postView addSubview:postTextLbl];
        [postView addSubview:whenLbl];
        
    }
    
    return postView;
    
}

#pragma mark -
#pragma mark REComposeViewControllerDelegate
- (void)composeViewController:(REComposeViewController *)composeViewController didFinishWithResult:(REComposeResult)result
{
    NSLog(@"Inside delegate");
    [composeViewController dismissViewControllerAnimated:YES completion:nil];
    if (result == REComposeResultCancelled) {
        NSLog(@"Cancelled");
    }
    if (result == REComposeResultPosted) {
        NSLog(@"Text: %@", composeViewController.text);
        UIImage *attachedImage = composeViewController.attachmentImage;
        NSString *postText = composeViewController.text;
        long millis = [[NSDate date] timeIntervalSince1970]/1000;
        Post *written = [[Post alloc] init];
        written.postText = postText;
        written.dateTimeMillis = millis;
        written.userScreenName = [[API getInstance] getCurrentUser].screenName;
        dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
        dispatch_async(queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToastActivity];
            });
            NSData *imgData = UIImagePNGRepresentation(attachedImage);
            
            NSString *fileName = ASSET_FILENAME;
            
            BOOL success = [[API getInstance] writePost:written withPictureData:imgData andPictureName:fileName toGroup:self.group];
            NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.verve.VerveAPIBundle"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view hideToastActivity];
                if (success)
                    [self.view makeToast:@"Upload successful!" duration:3.5 position:@"bottom" image:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"check" ofType:@"png"]]];
                else {
                    [self.view makeToast:@"Upload failed!" duration:3.5 position:@"bottom" image:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"error" ofType:@"png"]]];
                    return;
                }
                
            });
            
        });

    }
}

@end
