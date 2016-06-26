//
//  BankInfo.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 5/20/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankInfo : NSObject <NSCoding> {
    int _uniqueId;
    NSString *_appName;
    NSString *_appURL;
    NSString *_iconURL;
}

@property (nonatomic, assign) int uniqueId;
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *appURL;
@property (nonatomic, copy) NSString *iconURL;

- (id)initWithUniqueId:(int)uniqueId name:(NSString *)appName appURL:(NSString *)appURL
                 iconURL:(NSString *)iconURL;

@end
