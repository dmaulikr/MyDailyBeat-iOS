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
#import "AFNetworking.h"
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
#import "CocoaWSSE.h"
#import "JsonEncoder.h"

#define PUBLIC_BASE_URL @"http://mydailybeat.com"
#define AUTH_BASE_URL @"http://mydailybeat.com/api"
#define VOLUNTEER_MATCH_API_KEY @"091831c0b92450d7a598b3e4640504b5"
#define VOLUNTEER_MATCH_API_USER @"MyDailyBeat"
#define VOLUNTEER_MATCH_API_URL @"https://www.volunteermatch.org/api/call"
#define VOLUNTEER_MATCH_TEST_API_URL @"https://www.stage.volunteermatch.org/api/call"

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
- (BOOL) doesUserExistWithName: (NSString *) name;
- (BOOL) doesUserExistWithScreenName: (NSString *) screenName;
- (BOOL) doesUserExistWithEmail:(NSString *)email;
- (BOOL) doesUserExistWithMobile:(NSString *)mobile;
- (BOOL) loginWithScreenName:(NSString *) screenName andPassword:(NSString *) password;
- (void) refreshCurrentUserData;
- (BOOL) logout;
- (BOOL) sendReferralFromUser: (VerveUser *) user toPersonWithName: (NSString *) name andEmail: (NSString *) email;

- (NSMutableDictionary *) getOpportunitiesInLocation: (NSString *) zipcode onPage: (int) page;


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
- (BOOL) setHobbiesforGroup: (Group *) group;

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
- (NSArray *) getFriendsForUser: (VerveUser *) user;
- (BOOL) addUser:(VerveUser *) user1 ToFlingFavoritesOfUser:(VerveUser *) user2;
- (BOOL) addUser:(VerveUser *) user1 ToFriendsOfUser:(VerveUser *) user2;
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
-(NSData *) fetchImageAtRemoteURL: (NSURL *) location;

@end
