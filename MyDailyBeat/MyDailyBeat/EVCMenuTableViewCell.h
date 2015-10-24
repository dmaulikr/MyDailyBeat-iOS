//
//  EVCMenuTableViewCell.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/21/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVCMenuTableViewCell : UITableViewCell

@property (nonatomic) UIImageView *imgView;
@property (nonatomic) UILabel *lbl;
- (id) initWithFrame:(CGRect)frame andTag: (NSString *) tag;
@end
