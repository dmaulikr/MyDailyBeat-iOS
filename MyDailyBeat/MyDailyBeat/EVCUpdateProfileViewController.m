//
//  EVCUpdateProfileViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/21/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCUpdateProfileViewController.h"

@interface EVCUpdateProfileViewController ()

@end

@implementation EVCUpdateProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.opaque = NO;
    self.mTableView.backgroundColor = [UIColor clearColor];
    self.mTableView.backgroundView = nil;
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mTableView.bounces = NO;
    self.view.backgroundColor = [UIColor clearColor];
    self.mTableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    self.name = [[API getInstance] getCurrentUser].name;
    self.email = [[API getInstance] getCurrentUser].email;
    self.mobile = [[API getInstance] getCurrentUser].mobile;
    self.month = [[API getInstance] getCurrentUser].birth_month;
    self.year = [[API getInstance] getCurrentUser].birth_year;
    self.zipcode = [[API getInstance] getCurrentUser].zipcode;
    self.imgPicker = [[UIImagePickerController alloc] init];
    self.imgPicker.delegate = self;
    
    months = [NSMutableArray arrayWithObjects:@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November",@"December", nil];
    years = [[NSMutableArray alloc] init];
    
    self.picker = [[UIPickerView alloc] init];
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    for (int i = [[[NSCalendar currentCalendar]
                   components:NSYearCalendarUnit fromDate:[NSDate date]]
                  year] ; i >= 1900 ; i--) {
        [years addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
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
        
        BOOL success = [[API getInstance] uploadProfilePicture:imgData withName:fileName];
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

- (void) loadProfilePicture {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        NSURL *imageURL = [[API getInstance] retrieveProfilePicture];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            UIImage *profilePic = [UIImage imageWithData:imageData];
            EVCProfilePicView *profile = [[EVCProfilePicView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height) andImage:profilePic];
            [self.navigationController.navigationBar addSubview:profile];
            
        });
    });
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [self presentViewController:self.imgPicker animated:YES completion:nil];
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                DLAVAlertView *nameAlert = [[DLAVAlertView alloc] initWithTitle:@"Enter New Name" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                [nameAlert addTextFieldWithText:[[API getInstance] getCurrentUser].name placeholder:@"Name"];
                [nameAlert textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
                [nameAlert textFieldAtIndex:0].autocorrectionType = UITextAutocorrectionTypeNo;
                [nameAlert showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                    switch (buttonIndex) {
                        case 0:
                            break;
                        case 1:
                        {
                            self.name = [alertView textFieldTextAtIndex:0];
                        }
                            break;
                    }
                }];
            }
                break;
            case 1:
            {
                DLAVAlertView *emailAlert = [[DLAVAlertView alloc] initWithTitle:@"Enter New Email" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                [emailAlert addTextFieldWithText:[[API getInstance] getCurrentUser].email placeholder:@"Email"];
                [emailAlert textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeNone;
                [emailAlert textFieldAtIndex:0].autocorrectionType = UITextAutocorrectionTypeNo;
                [emailAlert textFieldAtIndex:0].keyboardType = UIKeyboardTypeEmailAddress;
                [emailAlert showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                    switch (buttonIndex) {
                        case 0:
                            break;
                        case 1:
                        {
                            self.email = [alertView textFieldTextAtIndex:0];
                        }
                            break;
                    }
                }];
            }
                break;
            case 2:
                //mobile
            {
                DLAVAlertView *mobileAlert = [[DLAVAlertView alloc] initWithTitle:@"Enter New Mobile Phone #" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                [mobileAlert addTextFieldWithText:[[API getInstance] getCurrentUser].mobile placeholder:@"Name"];
                [mobileAlert textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
                [mobileAlert textFieldAtIndex:0].autocorrectionType = UITextAutocorrectionTypeNo;
                [mobileAlert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNamePhonePad;
                [mobileAlert showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                    switch (buttonIndex) {
                        case 0:
                            break;
                        case 1:
                        {
                            self.mobile = [alertView textFieldTextAtIndex:0];
                        }
                            break;
                    }
                }];
 
            }
                
                break;
            case 3:
                //dob
            {
                DLAVAlertView *dobAlert = [[DLAVAlertView alloc] initWithTitle:@"Enter New Date of Birth" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                [dobAlert setContentView:self.picker];
                [dobAlert showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                    switch (buttonIndex) {
                        case 0:
                            break;
                        case 1:
                        {
                            self.month = [self pickerView:self.picker titleForRow:[self.picker selectedRowInComponent:0] forComponent:0];
                            self.year = [[years objectAtIndex:[self.picker selectedRowInComponent:1]] intValue];
                        }
                            break;
                    }
                }];
            }
                break;
            case 4:
                //zipcode
            {
                DLAVAlertView *zipAlert = [[DLAVAlertView alloc] initWithTitle:@"Enter New Zip Code" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                [zipAlert addTextFieldWithText:[[API getInstance] getCurrentUser].zipcode placeholder:@"Name"];
                [zipAlert textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
                [zipAlert textFieldAtIndex:0].autocorrectionType = UITextAutocorrectionTypeNo;
                [zipAlert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
                [zipAlert showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                    switch (buttonIndex) {
                        case 0:
                            break;
                        case 1:
                        {
                            self.zipcode = [alertView textFieldTextAtIndex:0];
                        }
                            break;
                    }
                }];
                
            }

                break;
                
            default:
                break;
        }
        
    } else {
        //save
        VerveUser *current = [[API getInstance] getCurrentUser];
        [current setName:self.name];
        [current setEmail:self.email];
        [current setMobile:self.mobile];
        [current setBirth_month:self.month];
        [current setBirth_year:self.year];
        [current setZipcode:self.zipcode];
        
        dispatch_queue_t queue = dispatch_queue_create(APP_ID_C_STRING, NULL);
        dispatch_async(queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToastActivity];
            });
            
            BOOL result = [[API getInstance] editUser:current];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view hideToastActivity];
                NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.verve.VerveAPIBundle"];
                if (result)
                    [self.view makeToast:@"User edit successful!" duration:3.5 position:@"bottom" image:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"check" ofType:@"png"]]];
                else {
                    [self.view makeToast:@"User edit failed!" duration:3.5 position:@"bottom" image:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"error" ofType:@"png"]]];
                    return;
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                
                
            });
        });

    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return 5;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.highlightedTextColor = [UIColor lightGrayColor];
    cell.selectedBackgroundView = [[UIView alloc] init];

    if (indexPath.section == 0) {
        cell.textLabel.text = @"Change Profile Picture";
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Name";
                break;
            case 1:
                cell.textLabel.text = @"Email";
                break;
            case 2:
                cell.textLabel.text = @"Mobile";
                break;
            case 3: {
                cell.textLabel.text = @"DOB";
                break;
            }
            case 4:
                cell.textLabel.text = @"Zip Code";
                break;
                
            default:
                cell.detailTextLabel.text  = @"";
                break;
        }
    } else {
        cell.textLabel.text = @"Save";
    }
    
    
    
    
    
    return cell;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 12;
    } else {
        return [years count];
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [months objectAtIndex:row];
    } else {
        return [years objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // do nothing really
}

@end
