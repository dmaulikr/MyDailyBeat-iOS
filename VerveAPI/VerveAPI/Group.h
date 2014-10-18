//
//  Group.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 9/2/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject

@property (nonatomic, retain) NSString *groupName;
@property (nonatomic, retain) NSString *adminName;
@property (nonatomic) int groupID;
@property (nonatomic, retain) NSMutableArray *posts;
@property (nonatomic, retain) NSString *blobKey;
@property (nonatomic, retain) NSString *servingURL;

@end
