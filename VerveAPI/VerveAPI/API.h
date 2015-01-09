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
#import "Group.h"
#import "Post.h"
#import "Constants.h"
#import "MessageChatroom.h"
#import "FlingProfile.h"
#import "VerveMessage.h"

#define BASE_URL @"https://1-dot-mydailybeat-api.appspot.com/_ah/api/mydailybeat/v1"

@interface API : NSObject

/* getInstance */
+(API *)getInstance;
/* Checks for Connectivity */
+(BOOL)hasConnectivity;

-(VerveUser *) getCurrentUser;
- (BOOL) createUser: (VerveUser *) userData;
- (BOOL) editUser: (VerveUser *) userData;
- (BOOL) loginWithScreenName:(NSString *) screenName andPassword:(NSString *) password;
- (void) refreshCurrentUserData;
- (VerveUser *) getUserDataForUserWithScreenName: (NSString *) screenName;

-(BOOL)uploadProfilePicture:(NSData *)profilePicture withName: (NSString *) name;
-(NSURL *) retrieveProfilePicture;
-(NSURL *) retrieveProfilePictureForUserWithScreenName:(NSString *) screenName;

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
- (RelationshipPrefs *) retrieveFlingPrefsWithScreenName:(NSString *) screenName;

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
- (BOOL) saveFlingProfileForUser:(VerveUser *) user withAge: (int) age andDescription:(NSString *) about;

- (MessageChatroom *) getChatroomByID: (int) ID;
- (NSArray *) getMessagesForChatroomWithID: (int) ID;


@end
