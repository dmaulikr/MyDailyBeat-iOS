//
//  EVCGroupSettingsViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/26/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCGroupSettingsViewController.h"

@interface EVCGroupSettingsViewController ()

@end

@implementation EVCGroupSettingsViewController

- (id) initWithGroup:(Group *) group andCompletionBlock:(EVCGroupSettingsViewControllerCompletionHandler) completion {
    self = [self initWithNibName:@"EVCGroupSettingsViewController_iPhone" bundle:nil];
    if (self) {
        _g = group;
        _handler = completion;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.formController = [[FXFormController alloc] init];
    self.formController.tableView = self.tableView;
    self.formController.delegate = self;
    GroupPrefs *prefs = [[GroupPrefs alloc] initWithServingURL:self.g.servingURL];
    prefs.hobbies = [[NSArray alloc] initWithArray:self.g.hobbies];
    self.formController.form = prefs;
    self.api = [RestAPI getInstance];
    
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelBarButton;

    
    UIBarButtonItem *postBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = postBarButton;


}

- (void) cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void) done {
    [self dismissViewControllerAnimated:YES completion:^{
        // save group preferences
        GroupPrefs *prefs = self.formController.form;
        
        if ([prefs.hobbies count] > 3) {
            [self.view makeToast:@"Cannot select more than 3 hobbies" duration:3.5 position:@"bottom"];
            return;
        }
        
        dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
        dispatch_async(queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToastActivity];
            });
            self.g.hobbies = [[NSMutableArray alloc] initWithArray:prefs.hobbies];
            BOOL success = [self.api setHobbiesforGroup:self.g];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view hideToastActivity];
                if (success) {
                    [self.view makeToast:@"Upload successful!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"check.png"]];
                    _handler();
                } else {
                    [self.view makeToast:@"Upload failed!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"error.png"]];
                    return;
                }
                
            });
            
        });
        
    }];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadGroupPicture];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadGroupPicture {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        NSURL *imageURL = [[RestAPI getInstance] retrieveGroupPictureForGroup:self.g];
        if (imageURL == nil) return;
        NSData *imageData = [[RestAPI getInstance] fetchImageAtRemoteURL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            GroupPrefs *prefs = self.formController.form;
             prefs.groupPicture = [UIImage imageWithData:imageData];
            
        });
    });
    
}

- (void)saveImage:(UITableViewCell<FXFormFieldCell> *)cell {
    GroupPrefs *prefs = self.formController.form;
    
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        NSData *imgData = UIImagePNGRepresentation(prefs.groupPicture);
        
        NSString *fileName = ASSET_FILENAME;
        
        BOOL success = [[RestAPI getInstance] uploadGroupPicture:imgData withName:fileName toGroup:self.g];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            if (success)
                [self.view makeToast:@"Upload successful!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"check.png"]];
            else {
                [self.view makeToast:@"Upload failed!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"error.png"]];
                return;
            }
            
        });
        
    });
}

- (void)deleteGroup:(UITableViewCell<FXFormFieldCell> *)cell {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        
        BOOL success = [[RestAPI getInstance] deleteGroup:self.g];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            if (success)
                [self.delegate EVCGroupSettingsViewControllerDelegateDidDeleteGroup:self];
            else
                NSLog(@"Failed");
            
        });
    });
}


@end
