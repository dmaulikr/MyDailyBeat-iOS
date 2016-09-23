//
//  RegisterObject1.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 9/18/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"
#import "RegisterForm2.h"

@interface RegisterObject1 : NSObject <FXForm>

@property (nonatomic, retain) NSString *first, *last;
@property (nonatomic, retain) NSDate *birthday;
@property (nonatomic, retain) NSString *zipcode;
@property (nonatomic, retain) RegisterForm2 *part2;


@end
