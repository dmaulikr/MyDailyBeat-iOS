//
//  API.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/17/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Reachability.h"
#import "VerveUser.h"
#import "AFHTTPRequestOperation.h"
#import <MobileCoreServices/UTType.h>
#import <sys/time.h>
#import "MakeFriendsPrefs.h"
#import "SocialPrefs.h"
#import "RelationshipPrefs.h"
#import "VolunteeringPrefs.h"

#define BASE_URL @"https://1-dot-mydailybeat-api.appspot.com/_ah/api/mydailybeat/v1"

@interface API : NSObject

/* getInstance */
+(API *)getInstance;
/* Checks for Connectivity */
+(BOOL)hasConnectivity;

-(VerveUser *) getCurrentUser;
- (BOOL) createUser: (VerveUser *) userData;
- (BOOL) loginWithScreenName:(NSString *) screenName andPassword:(NSString *) password;

-(BOOL)uploadProfilePicture:(NSData *)profilePicture withName: (NSString *) name;
-(NSURL *) retrieveProfilePicture;

- (BOOL) uploadMakeFriendsPrefs: (MakeFriendsPrefs *) prefsObject;
- (BOOL) uploadSocialPrefs: (SocialPrefs *) prefsObject;
- (BOOL) uploadRelationshipPrefs: (RelationshipPrefs *) prefsObject;
- (BOOL) uploadFlingPrefs: (RelationshipPrefs *) prefsObject;
- (BOOL) uploadVolunteeringPrefs: (VolunteeringPrefs *) prefsObject;

- (MakeFriendsPrefs *) retrieveMakeFriendsPrefs;
- (SocialPrefs *) retrieveSocialPrefs;
- (VolunteeringPrefs *) retrieveVolunteeringPrefs;
- (RelationshipPrefs *) retrieveRelationshipPrefs;
- (RelationshipPrefs *) retrieveFlingPrefs;




@end
