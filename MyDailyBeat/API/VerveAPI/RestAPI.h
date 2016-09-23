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
#import "Group.h"
#import "Post.h"
#import "Constants.h"
#import "MessageChatroom.h"
#import "FlingProfile.h"
#import "VerveMessage.h"
#import "VerveUserPreferences.h"
#import "VerveMatchingPreferences.h"
#import "VerveBankObject.h"
#import "VerveVolunteering.h"
#import "MapPoint.h"
#import "XMLDictionary.h"
#import "PrescripProviderInfo.h"
#import "HobbiesPreferences.h"
#import "HobbiesMatchObject.h"

#define BASE_URL @"https://1-dot-mydailybeat-api.appspot.com/_ah/api/mydailybeat/v1"

#define GET_REQUEST @"GET"
#define POST_REQUEST @"POST"
#define PUT_REQUEST @"PUT"
#define DELETE_REQUEST @"DELETE"
#define NONE @""
#define BOUNDARY @"*****"

@interface RestAPI : NSObject

/* getInstance */
+(RestAPI *)getInstance;
/* Checks for Connectivity */
+(BOOL)hasConnectivity;

-(VerveUser *) getCurrentUser;
- (BOOL) createUser: (VerveUser *) userData;
- (BOOL) editUser: (VerveUser *) userData;
- (BOOL) loginWithScreenName:(NSString *) screenName andPassword:(NSString *) password;
- (void) refreshCurrentUserData;
- (VerveUser *) getUserDataForUserWithScreenName: (NSString *) screenName;
- (BOOL) logout;

-(BOOL)uploadProfilePicture:(NSData *)profilePicture withName: (NSString *) name;
-(NSURL *) retrieveProfilePicture;
-(NSURL *) retrieveProfilePictureForUserWithScreenName:(NSString *) screenName;

- (VerveUserPreferences *) getUserPreferencesForUser: (VerveUser *) user;
- (VerveMatchingPreferences *) getMatchingPreferencesForUser: (VerveUser *) user;
- (BOOL) saveUserPreferences: (VerveUserPreferences *) preferences andMatchingPreferences: (VerveMatchingPreferences *) matchingPreferences forUser: (VerveUser *) user;
- (BOOL) saveUserPreferences: (VerveUserPreferences *) preferences forUser: (VerveUser *) user;
- (BOOL) saveMatchingPreferences: (VerveMatchingPreferences *) matchingPreferences forUser: (VerveUser *) user;

- (BOOL) doesAppExistWithTerm: (NSString *) name andCountry: (NSString *) country;
- (VerveBankObject *) getBankInfoForBankWithName: (NSString *) name inCountry: (NSString *) country;

- (HobbiesPreferences *) getHobbiesPreferencesForUserWithScreenName: (NSString *) screenName;
- (BOOL) saveHobbiesPreferences: (HobbiesPreferences *) prefs forUserWithScreenName: (NSString *) screenName;
- (NSMutableArray *) getHobbiesMatchesForUserWithScreenName:(NSString *) screenName;

- (NSMutableArray *) getGroupsForCurrentUser;
- (NSMutableArray *) getGroupsForUser:(VerveUser *) user;
- (BOOL) createGroupWithName:(NSString *) groupName;
- (BOOL) joinGroupWithName:(NSString *) groupName;
-(BOOL)uploadGroupPicture:(NSData *)groupPicture withName: (NSString *) name toGroup:(Group *) group;
-(NSURL *) retrieveGroupPictureForGroup:(Group *) group;
-(BOOL) writePost:(Post *) p withPictureData:(NSData *) attachedPic andPictureName:(NSString *) picName toGroup:(Group *) g;
- (NSMutableArray *) getPostsForGroup:(Group *) g;

- (BOOL) deletePost:(Post *) p;
- (BOOL) deleteGroup:(Group *) g;

- (NSMutableArray *) getPlacesWithType: (NSString *) searchType withName: (NSString *) name andCategory: (NSString *) category fromLocation: (CLLocationCoordinate2D) coordinate;
- (NSMutableArray *) getGeocodesForPlaces: (NSArray *) places;
- (NSDictionary *) getDetailsForPlaceWithID: (NSString *) placeID;


- (NSDictionary *) searchUsersWithQueryString:(NSString *) query andQueryType:(UserSearchType) type withSortOrder:(EVCSearchSortOrder) sortOrder;

- (BOOL) inviteUser:(VerveUser *) invitee toJoinGroup:(Group *) groupOfChoice by:(EVCUserInviteSendingMethod) method withMessage:(NSString *) inviteMessage;

- (NSDictionary *) searchGroupsWithQueryString:(NSString *) query withSortOrder:(EVCSearchSortOrder) sortOrder; 

- (BOOL) writeMessage:(NSString *) message asUser:(VerveUser *) user inChatRoomWithID: (int) chatID atTime: (long long) dateTimeMillis;
- (MessageChatroom *) createChatroomForUsersWithScreenName: (NSString *) firstUser andScreenName: (NSString *) secondUser;

- (NSArray *) getChatroomsForUser: (VerveUser *) user;

- (NSArray *) getFlingProfilesBasedOnPrefsOfUser:(VerveUser *) user;
- (NSArray *) getFlingFavoritesForUser: (VerveUser *) user;
- (BOOL) addUser:(VerveUser *) user1 ToFlingFavoritesOfUser:(VerveUser *) user2;
- (FlingProfile *) getFlingProfileForUser:(VerveUser *) user;
- (BOOL) saveFlingProfileForUser:(VerveUser *) user withAge: (int) age andDescription:(NSString *) about andInterests: (NSArray *) array;

- (NSArray *) getVolunteeringList;
- (BOOL) saveVolunteeringList:(NSArray *) arr;

- (MessageChatroom *) getChatroomByID: (int) ID;
- (NSArray *) getMessagesForChatroomWithID: (int) ID;

- (NSDictionary *) searchShoppingURLSWithQueryString: (NSString *) query withSortOrder: (EVCSearchSortOrder) sortOrder;
- (NSDictionary *) getShoppingFavoritesForUser: (VerveUser *) user withSortOrder: (EVCSearchSortOrder) sortOrder;
- (BOOL) addShoppingFavoriteURL: (NSString * ) string ForUser: (VerveUser *) user;

- (NSDictionary *) getUsersForFeelingBlue;
- (NSString *)urlencode: (NSString *) input;

-(id)makeRequestWithBaseUrl:(NSString *)baseUrl withPath:(NSString *)path withParameters:(NSString *)parameters withRequestType:(NSString *)reqType andPostData:(NSData *)postData;
-(id)makeXMLRequestWithBaseUrl:(NSString *)baseUrl withPath:(NSString *)path withParameters:(NSString *)parameters withRequestType:(NSString *)reqType andPostData:(NSData *)postData;

@end
