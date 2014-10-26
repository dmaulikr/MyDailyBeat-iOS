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
    EVCComposeViewControllerCompletionHandler completionHandler = ^(NSString* message, UIImage* image) {
        NSLog(@"Text: %@", message);
        UIImage *attachedImage = image;
        NSString *postText = message;
        long long millis = [[NSDate date] timeIntervalSince1970];
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view hideToastActivity];
                if (success)
                    [self.view makeToast:@"Upload successful!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"VerveAPIBundle.bundle/check.png"]];
                else {
                    [self.view makeToast:@"Upload failed!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"VerveAPIBundle.bundle/error.png"]];
                    return;
                }
                [self refreshGroupData];
                [self loadPosts];
            });
            
        });
        [self dismissModalViewControllerAnimated:YES];
    };
    EVCComposeViewController *composeNewPost = [[EVCComposeViewController alloc] initWithPostBlock:completionHandler];
    composeNewPost.title = @"New Post";
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentModalViewController:[[UINavigationController alloc] initWithRootViewController:composeNewPost] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scroll.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    if (self.scroll.bounds.size.height >= max_post_height) {
        self.scroll.contentSize = self.scroll.bounds.size;
    } else {
       self.scroll.contentSize = CGSizeMake(self.scroll.bounds.size.width, max_post_height+10);
    }
    
    self.scroll.alwaysBounceVertical = YES;
    self.imageView.layer.shadowColor = [UIColor purpleColor].CGColor;
    self.imageView.layer.shadowOffset = CGSizeMake(0, 1);
    self.imageView.layer.shadowOpacity = 1;
    self.imageView.layer.shadowRadius = 1.0;
    self.imageView.clipsToBounds = NO;
    
    
    self.screenNameLbl.text = self.group.groupName;
    
    UIImage* image3 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"1408346500_menu-alt"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(showMenu)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *menuButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem = menuButton;
    
    UIImage* image4 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"user-50"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg2 = CGRectMake(0, 0, image4.size.width, image4.size.height);
    UIButton *someButton2 = [[UIButton alloc] initWithFrame:frameimg2];
    [someButton2 setBackgroundImage:image4 forState:UIControlStateNormal];
    [someButton2 addTarget:self action:@selector(showProfile)
          forControlEvents:UIControlEventTouchUpInside];
    [someButton2 setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *profileButton =[[UIBarButtonItem alloc] initWithCustomView:someButton2];
    self.navigationItem.leftBarButtonItem = profileButton;
    
    if ([[[API getInstance] getCurrentUser].screenName isEqualToString:self.group.adminName]) {
        _settingsButton.hidden = NO;
    } else {
        _settingsButton.hidden = YES;
    }
    
    [self refreshGroupData];
    [self loadPicture];
    [self loadPosts];
    
    
}

- (void) loadPicture {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        NSURL *imageURL = [[API getInstance] retrieveGroupPictureForGroup:self.group];
        if (imageURL == nil) return;
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            self.imageView.image = [UIImage imageWithData:imageData];
            
        });
    });
    
}

- (IBAction)groupSettings:(id)sender {
    EVCGroupSettingsViewController *settingsController = [[EVCGroupSettingsViewController alloc] initWithGroup:self.group andCompletionBlock:^{
        [self refreshGroupData];
        [self loadPicture];
        [self loadPosts];
    }];
    [settingsController setTitle:@"Group Settings"];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:settingsController] animated:YES completion:nil];
}

- (void) loadPosts {
    NSArray *viewsToRemove = [self.scroll subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        [self refreshGroupData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.group.posts sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
                int id1 = [(Post *)obj1 post_id];
                int id2 = [(Post *)obj2 post_id];
                NSLog(@"Sorting, id1=%d, id2=%d", id1, id2);
                return id1 > id2;
            }];
            max_post_height = 10;
            for (int i = [self.group.posts count]-1 ; i >= 0 ; --i) {
                [self.scroll addSubview:[self createViewForPost:[self.group.posts objectAtIndex:i]]];
            }
            self.scroll.contentSize = CGSizeMake(self.scroll.bounds.size.width, max_post_height+10);
        });
    });
    
}

- (UIView *) createViewForPost: (Post *) inputPost {
    UIView *postView;
    [postView setBackgroundColor:[UIColor whiteColor]];
    if (inputPost.blobKey != nil) {
        EVCPostView *post = [[EVCPostView alloc] initWithFrame:CGRectMake(0, 0, 300, 400) andPost:inputPost withPostType:EVCPostTypeHasPicture];
        postView = [[UIView alloc] initWithFrame:CGRectMake(10, max_post_height, 300, 400)];
        [postView addSubview:post];
        
        max_post_height += 430;
        
        
    } else {
        EVCPostView *post = [[EVCPostView alloc] initWithFrame:CGRectMake(0, 0, 300, 178) andPost:inputPost withPostType:EVCPostTypeDoesNotHavePicture];
        postView = [[UIView alloc] initWithFrame:CGRectMake(10, max_post_height, 300, 178)];
        [postView addSubview:post];
        
        max_post_height += 208;
        
    }
    
    // drop shadow
    [postView.layer setShadowColor:[UIColor blackColor].CGColor];
    [postView.layer setShadowOpacity:0.8];
    [postView.layer setShadowRadius:3.0];
    [postView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    return postView;
    
}

- (void) showMenu {
    [self.sideMenuViewController presentRightMenuViewController];
}

- (void) showProfile {
    [self.sideMenuViewController presentLeftMenuViewController];
}

@end
