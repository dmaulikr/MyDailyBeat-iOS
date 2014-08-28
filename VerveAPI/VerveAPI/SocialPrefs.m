//
//  SocialPrefs.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/24/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "SocialPrefs.h"

@implementation SocialPrefs

@synthesize artsCulture;
@synthesize books;
@synthesize carEnthusiast;
@synthesize cardGames;
@synthesize dancing;
@synthesize diningOut;
@synthesize fitnessWellbeing;
@synthesize golf;
@synthesize ladiesNightOut;
@synthesize mensNightOut;
@synthesize movies;
@synthesize outdoorActivities;
@synthesize spiritual;
@synthesize baseball;
@synthesize football;
@synthesize hockey;
@synthesize carRacing;
@synthesize woodworking;

- (NSMutableArray *) getBoolArray {
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:artsCulture], [NSNumber numberWithBool:books], [NSNumber numberWithBool:carEnthusiast], [NSNumber numberWithBool:cardGames], [NSNumber numberWithBool:dancing], [NSNumber numberWithBool:diningOut], [NSNumber numberWithBool:fitnessWellbeing], [NSNumber numberWithBool:golf],[NSNumber numberWithBool:ladiesNightOut], [NSNumber numberWithBool:mensNightOut], [NSNumber numberWithBool:movies], [NSNumber numberWithBool:outdoorActivities], [NSNumber numberWithBool:spiritual],[NSNumber numberWithBool:baseball], [NSNumber numberWithBool:football],[NSNumber numberWithBool:hockey], [NSNumber numberWithBool:carRacing], [NSNumber numberWithBool:woodworking], nil];
    return arr;
}

- (NSArray *)fields
{
    return @[
             @{FXFormFieldKey: @"artsCulture", FXFormFieldTitle: @"Arts/Culture"},
             @{FXFormFieldKey: @"books", FXFormFieldTitle: @"Books"},
             @{FXFormFieldKey: @"carEnthusiast", FXFormFieldTitle: @"Car Enthusiast"},
             @{FXFormFieldKey: @"cardGames", FXFormFieldTitle: @"Card Games"},
             @{FXFormFieldKey: @"dancing", FXFormFieldTitle: @"Dancing"},
             @{FXFormFieldKey: @"diningOut", FXFormFieldTitle: @"Dining Out"},
             @{FXFormFieldKey: @"fitnessWellbeing", FXFormFieldTitle: @"Fitness/Wellbeing"},
             @{FXFormFieldKey: @"golf", FXFormFieldTitle: @"Golf"},
             @{FXFormFieldKey: @"ladiesNightOut", FXFormFieldTitle: @"Ladies' Night Out"},
             @{FXFormFieldKey: @"mensNightOut", FXFormFieldTitle: @"Men's Night Out"},
             @{FXFormFieldKey: @"movies", FXFormFieldTitle: @"Movies"},
             @{FXFormFieldKey: @"outdoorActivities", FXFormFieldTitle: @"Outdoor Activities"},
             @{FXFormFieldKey: @"spiritual", FXFormFieldTitle: @"Spritual"},
             @{FXFormFieldKey: @"baseball", FXFormFieldTitle: @"Baseball"},
             @{FXFormFieldKey: @"football", FXFormFieldTitle: @"Football"},
             @{FXFormFieldKey: @"hockey", FXFormFieldTitle: @"Hockey"},
             @{FXFormFieldKey: @"carRacing", FXFormFieldTitle: @"Car Racing"},
             @{FXFormFieldKey: @"woodworking", FXFormFieldTitle: @"Woodworking"}
             ];
}

- (NSArray *)extraFields
{
    return @[
             @{FXFormFieldTitle: @"OK", FXFormFieldHeader: @"", FXFormFieldAction: @"submit:"},
             ];
}





@end
