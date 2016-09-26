//
//  EVCComposeViewController.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 10/25/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCComposeViewController.h"
#import <IQKeyboardManager.h>

@interface EVCComposeViewController ()
{
    BOOL _wasKeyboardManagerEnabled;
}

@end

@implementation EVCComposeViewController

- (id) initWithPostBlock:(EVCComposeViewControllerCompletionHandler) callback {
    self = [self initWithNibName:@"EVCComposeViewController_iPhone" bundle:[NSBundle bundleForClass:[self class]]];
    if (self) {
        _completionHandler = callback;
        
    }
    
    return self;
}

- (BOOL) automaticallyAdjustsScrollViewInsets {
    return NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadProfilePicture];
    [_postTextView setInputAccessoryView:_accessoryViewBar];
    [_postTextView becomeFirstResponder];
    _postTextView.delegate = self;
    _postTextView.frame = CGRectMake(75, 65, 248, 151);
    
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPost)];
    self.navigationItem.leftBarButtonItem = cancelBarButton;
    
    UIBarButtonItem *postBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleDone target:self action:@selector(writePost)];
    self.navigationItem.rightBarButtonItem = postBarButton;
}

- (void) cancelPost {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) writePost {
    self.postText = self.postTextView.text;
    self.completionHandler(self.postText, self.attachedImage);
}

- (void) textViewDidChange:(UITextView *)textView {
    if ([textView.text length] == 0) {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    } else if ([textView.text length] > 200) {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
}


- (void) loadProfilePicture {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        NSURL *imageURL = [[RestAPI getInstance] retrieveProfilePicture];
        if (imageURL == nil) {
            return;
        }
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            UIImage *profilePic  = [UIImage imageWithData:imageData];
            [self.profilePicView setImage:profilePic];
            
        });
    });
}

- (IBAction)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if (!_hasAttachment) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                  message:@"Device has no camera"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            
            [myAlertView show];
            
        } else {
            [self presentViewController:picker animated:YES completion:NULL];
        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"This post already has an attachment!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
}

- (IBAction)addPhotoFromLibrary:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if (!_hasAttachment) {
        [self presentViewController:picker animated:YES completion:NULL];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"This post already has an attachment!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    _attachedImage = chosenImage;
    _attachmentImageView.image = _attachedImage;
    _hasAttachment = YES;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
