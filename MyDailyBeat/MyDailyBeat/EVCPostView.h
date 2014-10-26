//
//  EVCPostView.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/19/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import <API.h>

typedef enum {
    EVCPostTypeHasPicture = 1,
    EVCPostTypeDoesNotHavePicture = 0
} EVCPostType;

@interface EVCPostView : UIView

@property (nonatomic) IBOutlet UIImageView *profilePicView, *postPicView;
@property EVCPostType postType;
@property (nonatomic) IBOutlet UILabel *screenNameLbl, *whenLbl;
@property (nonatomic) IBOutlet UITextView *postTextLbl;
@property (nonatomic) Post *postObj;

- (id) initWithFrame:(CGRect)frame andPost:(Post *) pObj withPostType:(EVCPostType) type;

@end
