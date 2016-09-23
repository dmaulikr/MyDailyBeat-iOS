//
//  RegisterForm2.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 9/18/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"
#import "RegisterForm3.h"

@interface RegisterForm2 : NSObject <FXForm>

@property (nonatomic, retain) NSString *screenName, *text1, *text2, *password, *verifyPassword;
@property (nonatomic, retain) RegisterForm3 *part3;
@end
