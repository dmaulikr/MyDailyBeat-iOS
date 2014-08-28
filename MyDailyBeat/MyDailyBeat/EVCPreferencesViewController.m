//
//  EVCPreferencesViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/23/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCPreferencesViewController.h"

@interface EVCPreferencesViewController ()

@end

@implementation EVCPreferencesViewController

@synthesize changePic, date, makeFriends, fling, volunteer, social, imgPicker, api;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imgPicker = [[UIImagePickerController alloc] init];
    self.imgPicker.delegate = self;
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    api = [API getInstance];
    [self loadProfilePicture];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        NSData *imgData = UIImagePNGRepresentation(img);
        NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        NSLog(@"Asset URL = %@", assetURL);
        
        NSString *fileName = ASSET_FILENAME;
        
        BOOL success = [api uploadProfilePicture:imgData withName:fileName];
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
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)changeProfilePic:(id)sender {
    [self presentViewController:self.imgPicker animated:YES completion:nil];
    
}

- (void) loadProfilePicture {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        NSURL *imageURL = [api retrieveProfilePicture];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            UIImage *profilePic = [UIImage imageWithData:imageData];
            EVCProfilePicView *profile = [[EVCProfilePicView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height) andImage:profilePic];
            [self.navigationController.navigationBar addSubview:profile];
            
        });
    });

}

- (IBAction)makeFriends:(id)sender {
    EVCMakeFriendsPrefsViewController *controller = [[EVCMakeFriendsPrefsViewController alloc] initWithNibName:@"EVCMakeFriendsPrefsViewController_iPhone" bundle:nil];
    [self.navigationController pushViewController: controller animated:YES];
}

- (IBAction)socialActivites:(id)sender {
    EVCSocialPrefsViewController *controller = [[EVCSocialPrefsViewController alloc] initWithNibName:@"EVCSocialPrefsViewController_iPhone" bundle:nil];
    [self.navigationController pushViewController: controller animated:YES];
}

- (IBAction)relationship:(id)sender {
    EVCRelationshipPrefsViewController *controller = [[EVCRelationshipPrefsViewController alloc] initWithNibName:@"EVCRelationshipPrefsViewController_iPhone" bundle:nil];
    [self.navigationController pushViewController: controller animated:YES];
}
- (IBAction)fling:(id)sender {
    EVCFlingPrefsViewController *controller = [[EVCFlingPrefsViewController alloc] initWithNibName:@"EVCFlingPrefsViewController_iPhone" bundle:nil];
    [self.navigationController pushViewController: controller animated:YES];
}

- (IBAction)volunteer:(id)sender {
    EVCVolunteeringPrefsViewController *controller = [[EVCVolunteeringPrefsViewController alloc] initWithNibName:@"EVCVolunteeringPrefsViewController_iPhone" bundle:nil];
    [self.navigationController pushViewController: controller animated:YES];
}



@end
