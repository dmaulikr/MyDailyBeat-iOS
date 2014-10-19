//
//  EVCLabelTableViewCell.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/18/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVCLabelTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet UILabel *messageLbl;
@property (nonatomic) NSString *message;

- (id) initWithMessage:(NSString *) lblText;

@end
