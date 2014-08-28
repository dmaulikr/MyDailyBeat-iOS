//
//  EVCProfilePicView.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/24/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCProfilePicView.h"

@implementation EVCProfilePicView

@synthesize nameLbl, profilePic;

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *) pic
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"EVCProfilePicView_iPhone" owner:self options:nil] objectAtIndex:0];
        // now add the view to ourselves...
        [xibView setFrame:[self bounds]];
        [self addSubview:xibView];
        self.profilePic.image = pic;
        self.nameLbl.text =[[API getInstance] getCurrentUser].screenName;
    }
    return self;
}

@end
