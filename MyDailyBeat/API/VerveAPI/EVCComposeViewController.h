//
//  EVCComposeViewController.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 10/25/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestAPI.h"

typedef void (^EVCComposeViewControllerCompletionHandler)(NSString* message, UIImage* image);


@interface EVCComposeViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>

@property (nonatomic, retain) IBOutlet UIImageView *profilePicView, *attachmentImageView;
@property (nonatomic, retain) IBOutlet UITextView *postTextView;
@property (nonatomic, retain) IBOutlet UIToolbar *accessoryViewBar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *camera, *gallery;

@property (nonatomic, retain) UIImage *attachedImage;
@property (nonatomic) BOOL hasAttachment;
@property (nonatomic, retain) NSString *postText;

@property (nonatomic, copy) EVCComposeViewControllerCompletionHandler completionHandler;

- (IBAction)addPhotoFromLibrary:(id)sender;
- (IBAction)takePhoto:(id)sender;

- (id) initWithPostBlock:(EVCComposeViewControllerCompletionHandler) callback;




@end
