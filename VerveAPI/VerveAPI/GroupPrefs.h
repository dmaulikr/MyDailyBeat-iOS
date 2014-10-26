//
//  GroupPrefs.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 10/26/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@interface GroupPrefs : NSObject <FXForm>

@property (nonatomic) UIImage *groupPicture;

- (id) initWithServingURL:(NSString *) servingURL;

@end
