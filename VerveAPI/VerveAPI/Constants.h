//
//  Constants.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/18/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#ifndef VerveAPI_Constants_h
#define VerveAPI_Constants_h

#define WELCOME_MESSAGE_1 @"You are about to join the most vibrant community for older adults.\n\nLook No Further!"
#define WELCOME_MESSAGE_2 @"Let MyDailyBeat be the place you come to every day to help manage your personal life, keep you engaged, socialize, and stay connected."

#define APP_ID_C_STRING "com.verve.MyDailyBeat"
#define APP_ID_NSSTRING @"com.verve.MyDailyBeat"

#define ASSET_FILENAME @"asset.JPG"

typedef NS_ENUM(NSInteger, SexualPreference) {
    ManLookingForWoman = 0,
    WomanLookingForMan = 1,
    ManLookingForMan = 2,
    WomanLookingForWoman = 3,
    CoupleLookingForCouple = 4,
    BisexualLookingForBisexual = 5
};

#define KEY_SCREENNAME @"screenName"
#define KEY_PASSWORD @"password"

#define CREATE_NEW_GROUP @"New Group"

// hex color
#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif
