//
//  VerveMatchingPreferences.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/13/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import "VerveMatchingPreferences.h"

@implementation VerveMatchingPreferences

- (NSMutableDictionary *) toJSON {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:[NSNumber numberWithInt:self.gender] forKey:@"gender"];
    [dic setObject:[NSNumber numberWithInt:self.age] forKey:@"age"];
    [dic setObject:[NSNumber numberWithInt:self.status] forKey:@"status"];
    [dic setObject:[NSNumber numberWithInt:self.ethnicity] forKey:@"ethnicity"];
    [dic setObject:[NSNumber numberWithInt:self.drinker] forKey:@"drinker"];
    [dic setObject:[NSNumber numberWithInt:self.beliefs] forKey:@"beliefs"];
    [dic setObject:[NSNumber numberWithBool:self.smoker] forKey:@"smoker"];
    [dic setObject:[NSNumber numberWithBool:self.veteran] forKey:@"veteran"];
    
    return dic;
}

- (NSDictionary *) genderField {
    return @{FXFormFieldOptions: GENDER_STRING_LIST};
}

- (NSDictionary *) statusField {
    return @{FXFormFieldOptions: STATUS_STRING_LIST};
}
- (NSDictionary *) ethnicityField {
    return @{FXFormFieldOptions: ETHNICITY_STRING_LIST_2};
}

- (NSDictionary *) drinkerField {
    return @{FXFormFieldOptions: DRINKER_STRING_LIST};
}
- (NSDictionary *) beliefsField {
    return @{FXFormFieldOptions: BELIEFS_STRING_LIST_2};
}

- (NSDictionary *) ageField {
    return @{FXFormFieldOptions: AGE_STRING_LIST};
}

@end
