//
//  EVCProfilePicView.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/24/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVCProfilePicView : UIView

@property (nonatomic, retain) IBOutlet UILabel *nameLbl;
@property (nonatomic, retain) IBOutlet UIImageView *profilePic;

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *) pic withName:(NSString *)name;

@end
