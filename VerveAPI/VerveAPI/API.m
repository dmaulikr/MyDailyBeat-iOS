//
//  API.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/17/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "API.h"

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
