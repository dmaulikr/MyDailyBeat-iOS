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
    self.formController.form = [[GroupPrefs alloc] init];
    self.api = [API getInstance];
    
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelBarButton;

    
    UIBarButtonItem *postBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = postBarButton;


}

- (void) cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) done {
    GroupPrefs *prefs = self.formController.form;
    
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        NSData *imgData = UIImagePNGRepresentation(prefs.groupPicture);
        
        NSString *fileName = ASSET_FILENAME;
        
        BOOL success = [[API getInstance] uploadGroupPicture:imgData withName:fileName toGroup:self.g];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            if (success)
                [self.view makeToast:@"Upload successful!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"VerveAPIBundle.bundle/check.png"]];
            else {
                [self.view makeToast:@"Upload failed!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"VerveAPIBundle.bundle/error.png"]];
                return;
            }
            _handler();
            
        });
        
    });
    [self dismissViewControllerAnimated:YES completion:nil];

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
        NSURL *imageURL = [[API getInstance] retrieveGroupPictureForGroup:self.g];
        if (imageURL == nil) return;
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            GroupPrefs *prefs = self.formController.form;
             prefs.groupPicture = [UIImage imageWithData:imageData];
            
        });
    });
    
}

- (void)deleteGroup:(UITableViewCell<FXFormFieldCell> *)cell {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        
        BOOL success = [[API getInstance] deleteGroup:self.g];
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
