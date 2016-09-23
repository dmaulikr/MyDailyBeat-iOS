//
//  Constants.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/18/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#ifndef VerveAPI_Constants_h
#define VerveAPI_Constants_h

#import "UIView+Toast.h"

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

#define GENDER_STRING_LIST @[@"Male",@"Female",@"Transgender Male",@"Transgender Female"]
#define STATUS_STRING_LIST @[@"Single", @"Married", @"Widow/Widower"]
#define ETHNICITY_STRING_LIST_1 @[@"White/Caucasian", @"Black/African-American", @"Asian", @"Native American Indian/Native Alaskan", @"Latino/Hispanic", @"Other"]
#define ETHNICITY_STRING_LIST_2 @[@"White/Caucasian", @"Black/African-American", @"Asian", @"Native American Indian/Native Alaskan", @"Latino/Hispanic", @"No Preference"]
#define DRINKER_STRING_LIST @[@"I don't drink.", @"I seldom drink.", @"I enjoy drinking regularly."]
#define BELIEFS_STRING_LIST_1 @[@"Buddhist", @"Christian", @"Catholic", @"Hindu", @"Jewish", @"Muslim", @"Agnostic", @"Non-religious", @"Other"]
#define BELIEFS_STRING_LIST_2 @[@"Buddhist", @"Christian", @"Catholic", @"Hindu", @"Jewish", @"Muslim", @"Agnostic", @"Non-religious", @"No preference"]
#define CONTACT_STRING_LIST @[@"MDB online chat", @"Mobile - phone/text", @"Email", @"In person"]
#define AGE_STRING_LIST @[@"50-54", @"55-59", @"60-64", @"65-69", @"70-74", @"75-79", @"80-84", @"85-89", @"90-94", @"95-99", @"100+"]
#define RELATIONSHIP_STRING_LIST @[@"Fling", @"Companionship", @"Committed Relationship"]

#define TOP_TEN_BANKS @[@"JPMorgan Chase", @"Bank of America", @"Citigroup", @"Wells Fargo", @"The Bank of New York Mellon", @"U.S. Bancorp", @"HSBC Bank USA", @"Capital One", @"PNC Financial Services", @"State Street Bank", @"TD Bank", @"BB&T", @"SunTrust Banks", @"American Express", @"Ally Financial", @"Santander", @"Citizen's Bank", @"Eastern Bank"];
#define TRAVEL_SITES @[@"kayak.com", @"hotels.com", @"priceline.com", @"orbitz.com", @"travelocity.com", @"expedia.com", @"BreadAndBreakfast.com", @"airbnb.com", @"Hotwire.com", @"cruises.com", @"GrandcircleCruiseline.com", @"Cheaptickets.com", @"Onetravel.com", @"CheapAir.com", @"fly.com"]
#define PRESCRIP_PROVIDERS @[@"caremark.com", @"drugstore.com", @"familymeds.com", @"express-scripts.com"]
#define PRESCRIP_PROVIDER_LOGO_URLS @[@"http://info.caremark.com/images/Caremark_Microsite_images/Header/default/caremark_logo/CVS-Caremark-Logo.png", @"http://www.drugstore.com/img/sites/0/ds_logo_context.gif", @"http://www.familymeds.com/images/jpegs/logo.jpg", @"https://www.express-scripts.com/wps/themes/html/SelfService/images/esiLogo.gif"]
#define HEALTH_PORTALS @[@"myhealth.atriushealth.org", @"myhealthrecord.com", @"www.nextmd.com", @"my.patientfusion.com", @"www.mymedicalencounters.com", @"chartmakerpatientportal.com", @"app.relayhealth.com"]
#define HEALTH_PORTAL_LOGO_URLS @[@"https://rmbt.atriushealth.org/AtriusHealth.jpg", @"http://www.greenwayhealth.com/wp-content/themes/greenway_responsive/images/logo.svg", @"http://www.memorialcare.org/sites/default/files/nextmd-logo-280_0.png", @"https://www.patientfusion.com/content/images/patientFusion-logo-blue.png", @"https://www.mymedicalencounters.com/logos/patportal_logo2.jpg", @"http://sticomputer.com/newwebsite/wp-content/themes/sti/images/logo.png", @"http://media.relayhealth.com/designimages/RelayHealth-Logo-Full-Color-Tagline-new-palette.jpg"]

// hex color
#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define RES_LINKS [[NSBundle mainBundle] pathForResource:@"res_links" ofType:@"plist"]

typedef enum {
    SendByEmail = 0,
    SendByMobile = 1
} EVCUserInviteSendingMethod;

typedef enum {
    SearchByScreenName = 0,
    SearchByName = 1,
    SearchByEmail = 2
}UserSearchType;

typedef enum {
    ASCENDING = 0,
    DESCENDING = 1
} EVCSearchSortOrder;

typedef enum {
    FRIENDS_MODE = 0, FLING_MODE = 1, RELATIONSHIP_MODE = 2
} REL_MODE;

#define PLACES_API_KEY @"AIzaSyD12-W6HiSv3gVnCIQSUCvDTNtXrQRp1o8"

#endif
