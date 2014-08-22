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

-(BOOL)uploadProfilePicture:(NSData *)profilePicture withName: (NSString *) name {
    
    //start by getting upload url
    NSDictionary *getURLResult = [self makeRequestWithBaseUrl:BASE_URL withPath:@"users/getuploadurl" withParameters:@"" withRequestType:GET_REQUEST andPostData:nil];
    NSString *uploadurl = [getURLResult objectForKey:@"response"];
    
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

-(NSString *)getMimeType:(NSString *)path{
    CFStringRef pathExtension = (__bridge_retained CFStringRef)[path pathExtension];
    CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);
    // The UTI can be converted to a mime type:
    NSString *mimeType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType);
    return mimeType;
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

@end
