//
//  HealthInfo.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 5/28/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthInfo : NSObject <NSCoding> {
    int _uniqueId;
    NSString *_URL;
    NSString *_logoURL;
}

@property (nonatomic, assign) int uniqueId;
@property (nonatomic, copy) NSString *URL;
@property (nonatomic, copy) NSString *logoURL;

- (id)initWithUniqueId:(int)uniqueId URL:(NSString *)URL logoURL:(NSString *)logoURL;

@end
