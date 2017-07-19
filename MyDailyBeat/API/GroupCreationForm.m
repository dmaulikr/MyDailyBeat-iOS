//
//  GroupCreationForm.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/31/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "GroupCreationForm.h"

@implementation GroupCreationForm

- (NSDictionary *) hobbiesField {
    return @{FXFormFieldTitle: @"Select Hobbies", FXFormFieldOptions: @[@"Books", @"Golf", @"Cars", @"Walking", @"Hiking", @"Wine", @"Woodworking", @"Online Card Games", @"Card Games", @"Online Games", @"Arts & Crafts", @"Prayer", @"Support Groups", @"Shopping", @"Travel", @"Local Field Trips", @"History", @"Sports"], FXFormFieldViewController: @"EVCGroupSettingsHobbiesSelectionTableViewController"};
}

- (NSArray *)extraFields
{
    return @[
             @{FXFormFieldTitle: @"Create", FXFormFieldHeader: @"", FXFormFieldAction: @"createGroup:"},
             ];
}



@end
