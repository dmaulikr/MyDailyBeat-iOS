//
//  GroupCreationForm.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/31/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@interface GroupCreationForm : NSObject <FXForm>

@property (nonatomic, retain) NSString *groupName;
@property (nonatomic, retain) NSArray *hobbies;

@end
