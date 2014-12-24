//
//  EVCFlingProfileViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/21/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVCFlingProfileViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *profilePicView, *favoriteImgView;
@property (nonatomic, retain) IBOutlet UILabel *nameLbl, *ageLbl, *genderLbl, *distanceLbl;
@property (nonatomic, retain) IBOutlet UIButton *addFavsBtn, *sendMessageBtn;
@property (nonatomic, retain) IBOutlet UITextView *aboutMeView;

@end
