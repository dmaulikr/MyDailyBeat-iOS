//
//  GroupPrefs.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/17/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"
#import <RestAPI.h>

@interface GroupPrefs : NSObject <FXForm>

@property (nonatomic, retain) UIImage *groupPicture;

- (id) initWithServingURL:(NSString *) servingURL;

@end
