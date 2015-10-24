//
//  EVCMenuTableViewCell.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/21/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import "EVCMenuTableViewCell.h"

@implementation EVCMenuTableViewCell

@synthesize lbl, imgView;

- (id) initWithFrame:(CGRect)frame andTag: (NSString *) tag{
    self = [self initWithFrame:frame];
    if (self) {
        if ([tag isEqualToString:@"feelingBlue"]) {
            self.lbl = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 260, 43)];
            self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(275, 15, 30, 30)];
            UIView *placeholder = [[UIView alloc] initWithFrame:CGRectMake(0, 51, 320, 8)];
            [self.contentView addSubview:placeholder];
        } else {
            self.lbl = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 260, 29)];
            self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(277, 6, 30, 30)];
        }
        
        lbl.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:lbl];
        [self.contentView addSubview:imgView];
    }
    return self;

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
