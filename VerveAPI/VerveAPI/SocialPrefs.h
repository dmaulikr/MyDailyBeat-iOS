//
//  SocialPrefs.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/24/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@interface SocialPrefs : NSObject <FXForm>

@property(nonatomic) BOOL artsCulture;
@property(nonatomic) BOOL books;
@property(nonatomic) BOOL carEnthusiast;
@property(nonatomic) BOOL cardGames;
@property(nonatomic) BOOL dancing;
@property(nonatomic) BOOL diningOut;
@property(nonatomic) BOOL fitnessWellbeing;
@property(nonatomic) BOOL golf;
@property(nonatomic) BOOL ladiesNightOut;
@property(nonatomic) BOOL mensNightOut;
@property(nonatomic) BOOL movies;
@property(nonatomic) BOOL outdoorActivities;
@property(nonatomic) BOOL spiritual;
@property(nonatomic) BOOL baseball;
@property(nonatomic) BOOL football;
@property(nonatomic) BOOL hockey;
@property(nonatomic) BOOL carRacing;
@property(nonatomic) BOOL woodworking;

- (NSMutableArray *) getBoolArray;

@end
