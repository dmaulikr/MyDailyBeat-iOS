//
//  API.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/17/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "API.h"

#define GET_REQUEST @"GET"
#define POST_REQUEST @"POST"
#define PUT_REQUEST @"PUT"
#define DELETE_REQUEST @"DELETE"
#define NONE @""
#define BOUNDARY @"*****"

@implementation API

static VerveUser *currentUser;

+(id)getInstance {
    static API *api = nil;
    static dispatch_once_t initApi;
    dispatch_once(&initApi, ^{
        api = [[self alloc] init];
    });
    return api;
}

- (id)init {
    if (self = [super init]) {
        currentUser = nil;
    }
    return self;
}

- (BOOL) loginWithScreenName:(NSString *) screenName andPassword:(NSString *) password {
    NSString *parameters = [@"screen_name=" stringByAppendingString:[self urlencode:screenName]];
    parameters = [parameters stringByAppendingString:[@"&password=" stringByAppendingString:[self urlencode:password]]];
    NSDictionary *resultDic = [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/getInfo" withParameters:parameters withRequestType:GET_REQUEST andPostData:nil];
    if ([resultDic objectForKey:@"name"] != nil) {
        currentUser = [[VerveUser alloc] init];
        currentUser.name = [resultDic objectForKey:@"name"];
        currentUser.email = [resultDic objectForKey:@"email"];
        currentUser.screenName = screenName;
        currentUser.password = password;
        currentUser.mobile = [resultDic objectForKey:@"mobile"];
        currentUser.zipcode = [resultDic objectForKey:@"zipcode"];
        currentUser.birth_month = [resultDic objectForKey:@"birth_month"];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        currentUser.birth_year = [[f numberFromString:[resultDic objectForKey:@"birth_year"]] longValue];
        
        return YES;
    }
    
    return NO;
}

- (void) refreshCurrentUserData {
    NSString *parameters = [@"screen_name=" stringByAppendingString:[self urlencode:currentUser.screenName]];
    parameters = [parameters stringByAppendingString:[@"&password=" stringByAppendingString:[self urlencode:currentUser.password]]];
    NSDictionary *resultDic = [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/getInfo" withParameters:parameters withRequestType:GET_REQUEST andPostData:nil];
    if ([resultDic objectForKey:@"name"] != nil) {
        currentUser.name = [resultDic objectForKey:@"name"];
        currentUser.email = [resultDic objectForKey:@"email"];
        currentUser.screenName = [resultDic objectForKey:@"screenName"];
        currentUser.password = [resultDic objectForKey:@"password"];
        currentUser.mobile = [resultDic objectForKey:@"mobile"];
        currentUser.zipcode = [resultDic objectForKey:@"zipcode"];
        currentUser.birth_month = [resultDic objectForKey:@"birth_month"];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        currentUser.birth_year = [[f numberFromString:[resultDic objectForKey:@"birth_year"]] longValue];
        
    }
    
}

- (NSMutableArray *) getPostsForGroup:(Group *) g {
    NSString *parameters = [NSString stringWithFormat:@"id=%d", g.groupID];
    NSDictionary *resultDic = [self makeRequestWithBaseUrl:BASE_URL withPath:@"groups/posts/get" withParameters:parameters withRequestType:GET_REQUEST andPostData:nil];
    
    NSMutableArray *items = [resultDic objectForKey:@"items"];
    NSMutableArray *retItems = [[NSMutableArray alloc] init];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];

    for (int i= 0 ; i < [items count] ; ++i) {
        Post *p = [[Post alloc] init];
        NSDictionary *post = [items objectAtIndex:i];
        p.postText = [post objectForKey:@"postText"];
        p.blobKey = [post objectForKey:@"blobKey"];
        p.servingURL = [post objectForKey:@"servingURL"];
        p.userScreenName = [post objectForKey:@"userScreenName"];
        p.post_id = [[post objectForKey:@"id"] intValue];
        p.dateTimeMillis = [[f numberFromString:[post objectForKey:@"when"]] longLongValue];
        [retItems addObject:p];
    }
    
    
    return retItems;
    
}

- (BOOL) createUser: (VerveUser *) userData {
    
    @try {
        
        NSMutableDictionary *postData = [userData toJSON];
        
        NSError *error;
        NSData *postReqData = [NSJSONSerialization dataWithJSONObject:postData options:0 error:&error];
        
        if (error) {
            NSLog(@"Error parsing object to JSON: %@", error);
        }
        
        NSDictionary *result = [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/register" withParameters:@"" withRequestType:POST_REQUEST andPostData:postReqData];
        
        NSString *response = [result objectForKey:@"response"];
        if ([response isEqualToString:@"Operation succeeded"]) {
            return YES;
        }
        
    } @catch (NSException *e) {
        NSLog(@"%@", e);
    }
    
    return NO;
}

- (BOOL) editUser: (VerveUser *) userData {
    
    @try {
        
        NSMutableDictionary *postData = [userData toJSON];
        
        NSError *error;
        NSData *postReqData = [NSJSONSerialization dataWithJSONObject:postData options:0 error:&error];
        
        if (error) {
            NSLog(@"Error parsing object to JSON: %@", error);
        }
        
        NSDictionary *result = [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/edit" withParameters:@"" withRequestType:POST_REQUEST andPostData:postReqData];
        
        NSString *response = [result objectForKey:@"response"];
        if ([response isEqualToString:@"Operation succeeded"]) {
            return YES;
        }
        
    } @catch (NSException *e) {
        NSLog(@"%@", e);
    }
    
    return NO;
}

- (BOOL) uploadMakeFriendsPrefs: (MakeFriendsPrefs *) prefsObject {
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    [postData setObject:currentUser.screenName forKey:@"screenName"];
    [postData setObject:currentUser.password forKey:@"password"];
    
    NSMutableArray *interests = [self interestsJSON];
    NSMutableArray *selected = [prefsObject getBoolArray];
    
    [postData setObject:interests forKey:@"options"];
    [postData setObject:selected forKey:@"selected"];
    
    NSError *error;
    NSData *postReqData = [NSJSONSerialization dataWithJSONObject:postData options:0 error:&error];
    
    if (error) {
        NSLog(@"Error parsing object to JSON: %@", error);
    }
    
    NSDictionary *result = [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/prefs/hobby/save" withParameters:@"" withRequestType:POST_REQUEST andPostData:postReqData];
    
    if ([[result objectForKey:@"response"] isEqualToString:@"Operation succeeded"]) {
        return YES;
    }
    
    return NO;
    
}

- (MakeFriendsPrefs *) retrieveMakeFriendsPrefs {
    NSString *parameters = [@"screen_name=" stringByAppendingString:[self urlencode:currentUser.screenName]];
    parameters = [parameters stringByAppendingString:[@"&password=" stringByAppendingString:[self urlencode:currentUser.password]]];
    
    NSDictionary *result  = [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/prefs/hobby/retrieve" withParameters:parameters withRequestType:GET_REQUEST andPostData:nil];
    
    NSArray *boolArr = [result objectForKey:@"selected"];
    MakeFriendsPrefs *prefsObject = [[MakeFriendsPrefs alloc] init];
    prefsObject.artsCulture = [[boolArr objectAtIndex:0] boolValue];
    prefsObject.books = [[boolArr objectAtIndex:1] boolValue];
    prefsObject.carEnthusiast = [[boolArr objectAtIndex:2] boolValue];
    prefsObject.cardGames = [[boolArr objectAtIndex:3] boolValue];
    prefsObject.dancing = [[boolArr objectAtIndex:4] boolValue];
    prefsObject.diningOut = [[boolArr objectAtIndex:5] boolValue];
    prefsObject.fitnessWellbeing = [[boolArr objectAtIndex:6] boolValue];
    prefsObject.golf = [[boolArr objectAtIndex:7] boolValue];
    prefsObject.ladiesNightOut = [[boolArr objectAtIndex:8] boolValue];
    prefsObject.mensNightOut = [[boolArr objectAtIndex:9] boolValue];
    prefsObject.movies = [[boolArr objectAtIndex:10] boolValue];
    prefsObject.outdoorActivities = [[boolArr objectAtIndex:11] boolValue];
    prefsObject.spiritual = [[boolArr objectAtIndex:12] boolValue];
    prefsObject.baseball = [[boolArr objectAtIndex:13] boolValue];
    prefsObject.football = [[boolArr objectAtIndex:14] boolValue];
    prefsObject.hockey = [[boolArr objectAtIndex:15] boolValue];
    prefsObject.carRacing = [[boolArr objectAtIndex:16] boolValue];
    prefsObject.woodworking = [[boolArr objectAtIndex:17] boolValue];
    
    return prefsObject;
}

- (BOOL) uploadSocialPrefs: (SocialPrefs *) prefsObject {
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    [postData setObject:currentUser.screenName forKey:@"screenName"];
    [postData setObject:currentUser.password forKey:@"password"];
    
    NSMutableArray *interests = [self interestsJSON];
    NSMutableArray *selected = [prefsObject getBoolArray];
    
    [postData setObject:interests forKey:@"options"];
    [postData setObject:selected forKey:@"selected"];
    
    NSError *error;
    NSData *postReqData = [NSJSONSerialization dataWithJSONObject:postData options:0 error:&error];
    
    if (error) {
        NSLog(@"Error parsing object to JSON: %@", error);
    }
    
    NSDictionary *result = [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/prefs/social/save" withParameters:@"" withRequestType:POST_REQUEST andPostData:postReqData];
    
    if ([[result objectForKey:@"response"] isEqualToString:@"Operation succeeded"]) {
        return YES;
    }
    
    return NO;
    
}

- (SocialPrefs *) retrieveSocialPrefs {
    NSString *parameters = [@"screen_name=" stringByAppendingString:[self urlencode:currentUser.screenName]];
    parameters = [parameters stringByAppendingString:[@"&password=" stringByAppendingString:[self urlencode:currentUser.password]]];
    
    NSDictionary *result  = [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/prefs/social/retrieve" withParameters:parameters withRequestType:GET_REQUEST andPostData:nil];
    
    NSArray *boolArr = [result objectForKey:@"selected"];
    SocialPrefs *prefsObject = [[SocialPrefs alloc] init];
    prefsObject.artsCulture = [[boolArr objectAtIndex:0] boolValue];
    prefsObject.books = [[boolArr objectAtIndex:1] boolValue];
    prefsObject.carEnthusiast = [[boolArr objectAtIndex:2] boolValue];
    prefsObject.cardGames = [[boolArr objectAtIndex:3] boolValue];
    prefsObject.dancing = [[boolArr objectAtIndex:4] boolValue];
    prefsObject.diningOut = [[boolArr objectAtIndex:5] boolValue];
    prefsObject.fitnessWellbeing = [[boolArr objectAtIndex:6] boolValue];
    prefsObject.golf = [[boolArr objectAtIndex:7] boolValue];
    prefsObject.ladiesNightOut = [[boolArr objectAtIndex:8] boolValue];
    prefsObject.mensNightOut = [[boolArr objectAtIndex:9] boolValue];
    prefsObject.movies = [[boolArr objectAtIndex:10] boolValue];
    prefsObject.outdoorActivities = [[boolArr objectAtIndex:11] boolValue];
    prefsObject.spiritual = [[boolArr objectAtIndex:12] boolValue];
    prefsObject.baseball = [[boolArr objectAtIndex:13] boolValue];
    prefsObject.football = [[boolArr objectAtIndex:14] boolValue];
    prefsObject.hockey = [[boolArr objectAtIndex:15] boolValue];
    prefsObject.carRacing = [[boolArr objectAtIndex:16] boolValue];
    prefsObject.woodworking = [[boolArr objectAtIndex:17] boolValue];
    
    return prefsObject;
}

- (BOOL) uploadRelationshipPrefs: (RelationshipPrefs *) prefsObject {
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    [postData setObject:currentUser.screenName forKey:@"screenName"];
    [postData setObject:currentUser.password forKey:@"password"];
    
    NSMutableArray *prefArray = [[NSMutableArray alloc] init];
    NSMutableArray *strings = [prefsObject stringArray];
    
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] init];
    [prefs setObject:strings forKey:@"strings"];
    [prefs setObject:[NSNumber numberWithInt:[prefsObject enumToIndex]] forKey:@"index"];
    
    [prefArray addObject:prefs];
    [prefArray addObject:[NSNumber numberWithInt:prefsObject.age]];
    
    [postData setObject:prefArray forKey:@"prefs"];
    
    NSError *error;
    NSData *postReqData = [NSJSONSerialization dataWithJSONObject:postData options:0 error:&error];
    
    if (error) {
        NSLog(@"Error parsing object to JSON: %@", error);
    }
    
    NSDictionary *result = [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/prefs/relationship/save" withParameters:@"" withRequestType:POST_REQUEST andPostData:postReqData];
    
    if ([[result objectForKey:@"response"] isEqualToString:@"Operation succeeded"]) {
        return YES;
    }
    
    return NO;
    
}

- (RelationshipPrefs *) retrieveRelationshipPrefs {
    NSString *parameters = [@"screen_name=" stringByAppendingString:[self urlencode:currentUser.screenName]];
    parameters = [parameters stringByAppendingString:[@"&password=" stringByAppendingString:[self urlencode:currentUser.password]]];
    
    NSDictionary *result  = [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/prefs/relationship/retrieve" withParameters:parameters withRequestType:GET_REQUEST andPostData:nil];
    
    NSArray *prefs = [result objectForKey:@"prefs"];
    NSDictionary *sex = [prefs objectAtIndex:0];
    NSDictionary *ageObject =  [prefs objectAtIndex:1];
    RelationshipPrefs *prefsObject = [[RelationshipPrefs alloc] init];
    int index = [[sex objectForKey:@"index"] intValue];
    SexualPreference sexualPref = [prefsObject indexToEnum:index];
    int age = [[ageObject objectForKey:@"data"] intValue];
    prefsObject.sexualPref = sexualPref;
    prefsObject.age = age;
    
    
    return  prefsObject;
    
}

- (BOOL) uploadFlingPrefs: (RelationshipPrefs *) prefsObject {
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    [postData setObject:currentUser.screenName forKey:@"screenName"];
    [postData setObject:currentUser.password forKey:@"password"];
    
    NSMutableArray *prefArray = [[NSMutableArray alloc] init];
    NSMutableArray *strings = [prefsObject stringArray];
    
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] init];
    [prefs setObject:strings forKey:@"strings"];
    [prefs setObject:[NSNumber numberWithInt:[prefsObject enumToIndex]] forKey:@"index"];
    
    [prefArray addObject:prefs];
    [prefArray addObject:[NSNumber numberWithInt:prefsObject.age]];
    
    [postData setObject:prefArray forKey:@"prefs"];
    
    NSError *error;
    NSData *postReqData = [NSJSONSerialization dataWithJSONObject:postData options:0 error:&error];
    
    if (error) {
        NSLog(@"Error parsing object to JSON: %@", error);
    }
    
    NSDictionary *result = [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/prefs/fling/save" withParameters:@"" withRequestType:POST_REQUEST andPostData:postReqData];
    
    if ([[result objectForKey:@"response"] isEqualToString:@"Operation succeeded"]) {
        return YES;
    }
    
    return NO;
    
}

- (RelationshipPrefs *) retrieveFlingPrefs {
    NSString *parameters = [@"screen_name=" stringByAppendingString:[self urlencode:currentUser.screenName]];
    parameters = [parameters stringByAppendingString:[@"&password=" stringByAppendingString:[self urlencode:currentUser.password]]];
    
    NSDictionary *result  = [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/prefs/fling/retrieve" withParameters:parameters withRequestType:GET_REQUEST andPostData:nil];
    
    NSArray *prefs = [result objectForKey:@"prefs"];
    NSDictionary *sex = [prefs objectAtIndex:0];
    NSDictionary *ageObject =  [prefs objectAtIndex:1];
    RelationshipPrefs *prefsObject = [[RelationshipPrefs alloc] init];
    int index = [[sex objectForKey:@"index"] intValue];
    SexualPreference sexualPref = [prefsObject indexToEnum:index];
    int age = [[ageObject objectForKey:@"data"] intValue];
    prefsObject.sexualPref = sexualPref;
    prefsObject.age = age;
    
    
    return  prefsObject;
    
}


- (BOOL) uploadVolunteeringPrefs: (VolunteeringPrefs *) prefsObject {
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    [postData setObject:currentUser.screenName forKey:@"screenName"];
    [postData setObject:currentUser.password forKey:@"password"];
    
    NSMutableArray *interests = [self interestsJSON];
    NSMutableArray *selected = [prefsObject getBoolArray];
    
    [postData setObject:interests forKey:@"options"];
    [postData setObject:selected forKey:@"selected"];
    
    NSError *error;
    NSData *postReqData = [NSJSONSerialization dataWithJSONObject:postData options:0 error:&error];
    
    if (error) {
        NSLog(@"Error parsing object to JSON: %@", error);
    }
    
    NSDictionary *result = [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/prefs/volunteering/save" withParameters:@"" withRequestType:POST_REQUEST andPostData:postReqData];
    
    if ([[result objectForKey:@"response"] isEqualToString:@"Operation succeeded"]) {
        return YES;
    }
    
    return NO;
    
}

- (VolunteeringPrefs *) retrieveVolunteeringPrefs {
    NSString *parameters = [@"screen_name=" stringByAppendingString:[self urlencode:currentUser.screenName]];
    parameters = [parameters stringByAppendingString:[@"&password=" stringByAppendingString:[self urlencode:currentUser.password]]];
    
    NSDictionary *result  = [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/prefs/volunteering/retrieve" withParameters:parameters withRequestType:GET_REQUEST andPostData:nil];
    
    NSArray *boolArr = [result objectForKey:@"selected"];
    VolunteeringPrefs *prefsObject = [[VolunteeringPrefs alloc] init];
    prefsObject.spiritual = [[boolArr objectAtIndex:0] boolValue];
    prefsObject.nonprofit = [[boolArr objectAtIndex:1] boolValue];
    prefsObject.community = [[boolArr objectAtIndex:2] boolValue];
    
    return prefsObject;
}

-(NSURL *) retrieveProfilePicture {
    return [self retrieveProfilePictureForUserWithScreenName:currentUser.screenName];
}

-(NSURL *) retrieveProfilePictureForUserWithScreenName:(NSString *) screenName{
    NSString *parameters = [@"screen_name=" stringByAppendingString:[self urlencode:screenName]];
    NSDictionary *getServingURLResult = [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/profile/blobkey/retrieve" withParameters:parameters withRequestType:GET_REQUEST andPostData:nil];
    NSString *s = [getServingURLResult objectForKey:@"servingURL"];
    if (s == nil) {
        return nil;
    }
    NSURL *url = [[NSURL alloc] initWithString:s];
    return url;
}

-(BOOL) uploadProfilePicture:(NSData *)profilePicture withName: (NSString *) name {
    
    //start by getting upload url
    NSDictionary *getURLResult = [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/getuploadurl" withParameters:@"" withRequestType:GET_REQUEST andPostData:nil];
    NSString *uploadurl = [getURLResult objectForKey:@"response"];
    
    NSLog(@"Upload URL=%@", uploadurl);
    
    AFHTTPRequestSerializer *ser = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [ser multipartFormRequestWithMethod:POST_REQUEST URLString:uploadurl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:profilePicture name:@"file" fileName:name mimeType:[self getMimeType:name]];
        [formData appendPartWithFormData:[[name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding] name:@"name"];
    } error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:YES];
    [request setTimeoutInterval:30];
    NSLog(@"%@", request);
    // send the request
    NSError *requestError;
    NSHTTPURLResponse *urlResponse;
    NSData *dataResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    if (requestError) NSLog(@"Error received from server: %@", requestError);
    if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
        NSDictionary *parsedJSONResponse = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableContainers error:&requestError];
        NSString *blobKey = [parsedJSONResponse objectForKey:@"blobKey"];
        NSString *servingURL = [parsedJSONResponse objectForKey:@"servingUrl"];
        
        NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
        [postData setObject:blobKey forKey:@"blobKey"];
        [postData setObject:servingURL forKey:@"servingURL"];
        [postData setObject:currentUser.screenName forKey:@"screenName"];
        [postData setObject:currentUser.password forKey:@"password"];
        
        NSData *postReqData = [NSJSONSerialization dataWithJSONObject:postData options:0 error:&requestError];
        
        NSDictionary *result = [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/profile/blobkey/save" withParameters:@"" withRequestType:POST_REQUEST andPostData:postReqData];
        
        NSString *response = [result objectForKey:@"response"];
        if ([response isEqualToString:@"Operation succeeded"]) {
            return YES;
        } else
            return NO;
        
        
    } else if (urlResponse.statusCode == 401) {
        NSLog(@"Unauthorized. %@", [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding]);
    } else if (urlResponse.statusCode == 422) {
        NSLog(@"Unprocessable entity. %@", [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding]);
    } else if (urlResponse.statusCode == 500) {
        NSLog(@"Internal server error. %@", [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding]);
    } else {
        NSLog(@"Unrecognized status code = %ld. %@", (long)urlResponse.statusCode, [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding]);
    }
    return NO;
}

-(NSURL *) retrieveGroupPictureForGroup:(Group *) group {
    NSString *parameters = [NSString stringWithFormat:@"id=%d", group.groupID];
    NSDictionary *getServingURLResult = [self makeRequestWithBaseUrl:BASE_URL withPath:@"groups/blobkey/retrieve" withParameters:parameters withRequestType:GET_REQUEST andPostData:nil];
    NSString *s = [getServingURLResult objectForKey:@"servingURL"];
    if (s == nil) {
        return nil;
    }
    group.servingURL = s;
    group.blobKey = [getServingURLResult objectForKey:@"blobKey"];
    NSURL *url = [[NSURL alloc] initWithString:s];
    return url;

}

-(BOOL) writePost:(Post *) p withPictureData:(NSData *) attachedPic andPictureName:(NSString *) picName toGroup:(Group *) g {
    
    NSError *requestError;
    
    if (attachedPic != nil) {
        NSDictionary *getURLResult = [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/getuploadurl" withParameters:@"" withRequestType:GET_REQUEST andPostData:nil];
        NSString *uploadurl = [getURLResult objectForKey:@"response"];
        
        NSLog(@"Upload URL=%@", uploadurl);
        
        AFHTTPRequestSerializer *ser = [AFHTTPRequestSerializer serializer];
        NSMutableURLRequest *request = [ser multipartFormRequestWithMethod:POST_REQUEST URLString:uploadurl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:attachedPic name:@"file" fileName:picName mimeType:[self getMimeType:picName]];
            [formData appendPartWithFormData:[[picName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding] name:@"name"];
        } error:nil];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [request setHTTPShouldHandleCookies:YES];
        [request setTimeoutInterval:30];
        NSLog(@"%@", request);
        // send the request
        
        NSHTTPURLResponse *urlResponse;
        NSData *dataResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
        if (requestError) NSLog(@"Error received from server: %@", requestError);
        if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
            NSDictionary *parsedJSONResponse = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableContainers error:&requestError];
            NSString *blobKey = [parsedJSONResponse objectForKey:@"blobKey"];
            NSString *servingURL = [parsedJSONResponse objectForKey:@"servingUrl"];
            
            NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
            [postData setObject:blobKey forKey:@"blobKey"];
            [postData setObject:servingURL forKey:@"servingURL"];
            [postData setObject:p.postText forKey:@"postText"];
            [postData setObject:p.userScreenName forKey:@"userScreenName"];
            [postData setObject:[NSNumber numberWithLongLong:p.dateTimeMillis] forKey:@"when"];
            [postData setObject:[NSNumber numberWithInt:g.groupID] forKey:@"id"];
            
            NSData *postReqData = [NSJSONSerialization dataWithJSONObject:postData options:0 error:&requestError];
            
            
            NSDictionary *result = [self makeRequestWithBaseUrl:BASE_URL withPath:@"groups/post" withParameters:@"" withRequestType:POST_REQUEST andPostData:postReqData];
            
            NSString *response = [result objectForKey:@"response"];
            if ([response isEqualToString:@"Operation succeeded"]) {
                return YES;
            } else
                return NO;
            
            
        } else if (urlResponse.statusCode == 401) {
            NSLog(@"Unauthorized. %@", [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding]);
        } else if (urlResponse.statusCode == 422) {
            NSLog(@"Unprocessable entity. %@", [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding]);
        } else if (urlResponse.statusCode == 500) {
            NSLog(@"Internal server error. %@", [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding]);
        } else {
            NSLog(@"Unrecognized status code = %ld. %@", (long)urlResponse.statusCode, [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding]);
        }
    } else {
        NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
        [postData setObject:@"" forKey:@"blobKey"];
        [postData setObject:@"" forKey:@"servingURL"];
        [postData setObject:p.postText forKey:@"postText"];
        [postData setObject:p.userScreenName forKey:@"userScreenName"];
        [postData setObject:[NSNumber numberWithDouble:p.dateTimeMillis] forKey:@"when"];
        [postData setObject:[NSNumber numberWithInt:g.groupID] forKey:@"id"];
        
        NSData *postReqData = [NSJSONSerialization dataWithJSONObject:postData options:0 error:&requestError];

        
        NSDictionary *result = [self makeRequestWithBaseUrl:BASE_URL withPath:@"groups/post" withParameters:@"" withRequestType:POST_REQUEST andPostData:postReqData];
        
        NSString *response = [result objectForKey:@"response"];
        if ([response isEqualToString:@"Operation succeeded"]) {
            return YES;
        } else
            return NO;

    }
    return NO;
}

-(BOOL)uploadGroupPicture:(NSData *)groupPicture withName: (NSString *) name toGroup:(Group *) group {
    
    //start by getting upload url
    NSDictionary *getURLResult = [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/getuploadurl" withParameters:@"" withRequestType:GET_REQUEST andPostData:nil];
    NSString *uploadurl = [getURLResult objectForKey:@"response"];
    
    NSLog(@"Upload URL=%@", uploadurl);
    
    AFHTTPRequestSerializer *ser = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [ser multipartFormRequestWithMethod:POST_REQUEST URLString:uploadurl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:groupPicture name:@"file" fileName:name mimeType:[self getMimeType:name]];
        [formData appendPartWithFormData:[[name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding] name:@"name"];
    } error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:YES];
    [request setTimeoutInterval:30];
    NSLog(@"%@", request);
    // send the request
    NSError *requestError;
    NSHTTPURLResponse *urlResponse;
    NSData *dataResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    if (requestError) NSLog(@"Error received from server: %@", requestError);
    if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
        NSDictionary *parsedJSONResponse = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableContainers error:&requestError];
        NSString *blobKey = [parsedJSONResponse objectForKey:@"blobKey"];
        NSString *servingURL = [parsedJSONResponse objectForKey:@"servingUrl"];
        
        NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
        [postData setObject:blobKey forKey:@"blobKey"];
        [postData setObject:servingURL forKey:@"servingURL"];
        [postData setObject:[NSNumber numberWithInt:group.groupID] forKey:@"id"];
        
        NSData *postReqData = [NSJSONSerialization dataWithJSONObject:postData options:0 error:&requestError];
        
        NSDictionary *result = [self makeRequestWithBaseUrl:BASE_URL withPath:@"groups/blobkey/save" withParameters:@"" withRequestType:POST_REQUEST andPostData:postReqData];
        
        NSString *response = [result objectForKey:@"response"];
        if ([response isEqualToString:@"Operation succeeded"]) {
            return YES;
        } else
            return NO;
        
        
    } else if (urlResponse.statusCode == 401) {
        NSLog(@"Unauthorized. %@", [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding]);
    } else if (urlResponse.statusCode == 422) {
        NSLog(@"Unprocessable entity. %@", [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding]);
    } else if (urlResponse.statusCode == 500) {
        NSLog(@"Internal server error. %@", [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding]);
    } else {
        NSLog(@"Unrecognized status code = %ld. %@", (long)urlResponse.statusCode, [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding]);
    }
    return NO;
}


-(NSString *)getMimeType:(NSString *)path{
    CFStringRef pathExtension = (__bridge_retained CFStringRef)[path pathExtension];
    CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);
    // The UTI can be converted to a mime type:
    NSString *mimeType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType);
    return mimeType;
}

- (NSDictionary *) searchUsersWithQueryString:(NSString *) query andQueryType:(SearchType) type withSortOrder:(EVCSearchSortOrder) sortOrder {
    NSString *parameters = [@"query=" stringByAppendingString:[self urlencode:currentUser.screenName]];
    parameters = [parameters stringByAppendingString:[@"&sort_order=" stringByAppendingString:[NSString stringWithFormat:@"%d", sortOrder]]];

    switch (type) {
        case SearchByScreenName: {
            return [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/search/screenName" withParameters:parameters withRequestType:GET_REQUEST andPostData:nil];
        }
            break;
        
        case SearchByEmail: {
            return [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/search/email" withParameters:parameters withRequestType:GET_REQUEST andPostData:nil];
        }
            break;
            
        case SearchByName: {
            return [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/search/name" withParameters:parameters withRequestType:GET_REQUEST andPostData:nil];
        }
            break;
    }
}

- (NSMutableArray *) getGroupsForCurrentUser {
    NSString *parameters = [@"screen_name=" stringByAppendingString:[self urlencode:currentUser.screenName]];
    parameters = [parameters stringByAppendingString:[@"&password=" stringByAppendingString:[self urlencode:currentUser.password]]];
    
    NSDictionary *resultDic = [self makeRequestWithBaseUrl:BASE_URL withPath:@"groups/get" withParameters:parameters withRequestType:GET_REQUEST andPostData:nil];
    
    NSMutableArray *items = [resultDic objectForKey:@"items"];
    NSMutableArray *retItems = [[NSMutableArray alloc] init];
    
    for (int i= 0 ; i < [items count] ; ++i) {
        Group *g = [[Group alloc] init];
        NSDictionary *item = [items objectAtIndex:i];
        g.groupName = [item objectForKey:@"groupName"];
        g.adminName = [item objectForKey:@"adminScreenName"];
        g.blobKey = [item objectForKey:@"blobKey"];
        g.servingURL = [item objectForKey:@"servingURL"];
        g.groupID = [[item objectForKey:@"id"] intValue];
        NSMutableArray *postJSON = [item objectForKey:@"posts"];
        NSMutableArray *posts = [[NSMutableArray alloc] init];
        for (int j=0 ; j < [postJSON count] ; ++j) {
            Post *p = [[Post alloc] init];
            NSDictionary *post = [postJSON objectAtIndex:j];
            p.postText = [post objectForKey:@"postText"];
            p.blobKey = [post objectForKey:@"blobKey"];
            p.servingURL = [post objectForKey:@"servingURL"];
            p.post_id = [[post objectForKey:@"id"] intValue];
            p.userScreenName = [post objectForKey:@"userScreenName"];
            p.dateTimeMillis = [[post objectForKey:@"when"] longLongValue];
            [posts addObject:p];
        }
        g.posts = posts;
        [retItems addObject:g];
    }
    
    
    return retItems;
}

- (BOOL) createGroupWithName:(NSString *) groupName {
    
    
    @try {
        
        NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
        [postData setObject:currentUser.screenName forKey:@"screenName"];
        [postData setObject:currentUser.password forKey:@"password"];
        [postData setObject:groupName forKey:@"groupName"];
        NSError *error;
        NSData *postReqData = [NSJSONSerialization dataWithJSONObject:postData options:0 error:&error];
        
        if (error) {
            NSLog(@"Error parsing object to JSON: %@", error);
        }
        
        NSDictionary *result = [self makeRequestWithBaseUrl:BASE_URL withPath:@"groups/create" withParameters:@"" withRequestType:POST_REQUEST andPostData:postReqData];
        
        
        NSString *response = [result objectForKey:@"response"];
        if ([response isEqualToString:@"Operation succeeded"]) {
            return YES;
        }
        
    } @catch (NSException *e) {
        NSLog(@"%@", e);
    }
    
    return NO;
}

- (BOOL) joinGroupWithName:(NSString *) groupName {
    @try {
        
        NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
        [postData setObject:currentUser.screenName forKey:@"screenName"];
        [postData setObject:currentUser.password forKey:@"password"];
        [postData setObject:groupName forKey:@"groupName"];
        NSError *error;
        NSData *postReqData = [NSJSONSerialization dataWithJSONObject:postData options:0 error:&error];
        
        if (error) {
            NSLog(@"Error parsing object to JSON: %@", error);
        }
        
        NSDictionary *result = [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/groups/join" withParameters:@"" withRequestType:POST_REQUEST andPostData:postReqData];
        
        
        NSString *response = [result objectForKey:@"response"];
        if ([response isEqualToString:@"Operation succeeded"]) {
            return YES;
        }
        
    } @catch (NSException *e) {
        NSLog(@"%@", e);
    }
    
    return NO;
    
}

- (BOOL) deletePost:(Post *) p {
    NSString *parameters = [@"id=" stringByAppendingString:[NSString stringWithFormat:@"%d", p.post_id]];

    NSDictionary *resultDic = [self makeRequestWithBaseUrl:BASE_URL withPath:@"groups/posts/delete" withParameters:parameters withRequestType:GET_REQUEST andPostData:nil];
    
    NSString *response = [resultDic objectForKey:@"response"];
    if ([response isEqualToString:@"Operation succeeded"]) {
        return YES;
    }
    
    return NO;

}

- (BOOL) deleteGroup:(Group *) g {
    NSString *parameters = [@"id=" stringByAppendingString:[NSString stringWithFormat:@"%d", g.groupID]];
    
    NSDictionary *resultDic = [self makeRequestWithBaseUrl:BASE_URL withPath:@"groups/delete" withParameters:parameters withRequestType:GET_REQUEST andPostData:nil];
    
    NSString *response = [resultDic objectForKey:@"response"];
    if ([response isEqualToString:@"Operation succeeded"]) {
        return YES;
    }
    
    return NO;
    
}




/*
 * Returns the current saved user object.
 *
 * @return A VerveUser object that corresponds to the owner of the current session
 */
-(VerveUser *)getCurrentUser {
    return currentUser;
}

+(BOOL)hasConnectivity {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

/**
 * Makes an HTTP request for JSON-formatted data. Functions that
 * call this function should not be run on the UI thread.
 *
 * @param baseUrl The base of the URL to which the request will be made
 * @param path The path to append to the request URL
 * @param parameters Parameters separated by ampersands (&)
 * @param reqType The request type as a string (i.e. GET or POST)
 * @param postData The data to be given to iSENSE as NSData
 * @return An object dump of a JSONObject or JSONArray representing the requested data
 */
-(id)makeRequestWithBaseUrl:(NSString *)baseUrl withPath:(NSString *)path withParameters:(NSString *)parameters withRequestType:(NSString *)reqType andPostData:(NSData *)postData {
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/%@?%@", baseUrl, path, parameters]];
    NSLog(@"Connect to: %@", url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod:reqType];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    if (postData) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
        NSString *LOG_STR = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"API: posting data:\n%@", LOG_STR);
    }
    NSError *requestError;
    NSHTTPURLResponse *urlResponse;
    NSData *dataResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    if (requestError) NSLog(@"Error received from server: %@", requestError);
    if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
        id parsedJSONResponse = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableContainers error:&requestError];
        return parsedJSONResponse;
    } else if (urlResponse.statusCode == 401) {
        NSLog(@"Unauthorized. %@", [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding]);
    } else if (urlResponse.statusCode == 422) {
        NSLog(@"Unprocessable entity. %@", [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding]);
    } else if (urlResponse.statusCode == 500) {
        NSLog(@"Internal server error. %@", [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding]);
    } else if (urlResponse.statusCode == 404) {
        NSLog(@"Not found. %@", [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding]);
    } else {
        NSLog(@"Unrecognized status code = %ld. %@", (long)urlResponse.statusCode, [[NSString alloc] initWithData:dataResponse encoding:NSUTF8StringEncoding]);
    }
    return nil;
}
- (NSString *)urlencode: (NSString *) input {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[input UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

- (NSMutableArray *) interestsJSON {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    [arr addObject:@"Arts/Culture"];
    [arr addObject:@"Books"];
    [arr addObject:@"Car Enthusiast"];
    [arr addObject:@"Card Games"];
    [arr addObject:@"Dancing"];
    [arr addObject:@"Dining Out"];
    [arr addObject:@"Fitness/Wellbeing"];
    [arr addObject:@"Golf"];
    [arr addObject:@"Ladies' Night Out"];
    [arr addObject:@"Men's Night Out"];
    [arr addObject:@"Movies"];
    [arr addObject:@"Outdoor Activities"];
    [arr addObject:@"Spiritual"];
    [arr addObject:@"Baseball"];
    [arr addObject:@"Football"];
    [arr addObject:@"Hockey"];
    [arr addObject:@"Car Racing"];
    [arr addObject:@"Woodworking"];
    
    return arr;
}

@end
