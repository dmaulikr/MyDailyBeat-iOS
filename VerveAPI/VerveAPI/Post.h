//
//  Post.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 10/1/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject <NSCopying>

@property (nonatomic) int post_id;
@property (nonatomic, retain) NSString *postText;
@property (nonatomic, retain) NSString *blobKey;
@property (nonatomic, retain) NSString *servingURL;
@property (nonatomic, retain) NSString *userScreenName;
@property (nonatomic) long long dateTimeMillis;

@end
