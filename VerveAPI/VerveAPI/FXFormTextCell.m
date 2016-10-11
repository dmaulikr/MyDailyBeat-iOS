//
//  FXFormTextCell.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 9/18/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "FXFormTextCell.h"

@implementation FXFormTextCell

- (void) setUp {
    self.textLabel.text = self.field.value;
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    self.textLabel.numberOfLines = 0;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void) update {
    self.textLabel.text = self.field.value;
    self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.textLabel.numberOfLines = 0;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
