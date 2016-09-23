//
//  VerveUserPreferences.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/13/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import "VerveUserPreferences.h"

@implementation VerveUserPreferences

- (NSMutableDictionary *) toJSON {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:[NSNumber numberWithInt:self.gender] forKey:@"gender"];
    [dic setObject:[NSNumber numberWithInt:self.age] forKey:@"age"];
    [dic setObject:[NSNumber numberWithInt:self.status] forKey:@"status"];
    [dic setObject:[NSNumber numberWithInt:self.ethnicity] forKey:@"ethnicity"];
    [dic setObject:[NSNumber numberWithInt:self.drinker] forKey:@"drinker"];
    [dic setObject:[NSNumber numberWithInt:self.beliefs] forKey:@"beliefs"];
    [dic setObject:[NSNumber numberWithInt:self.contact] forKey:@"contact"];
    if (self.otherEthnicity == nil) {
        self.otherEthnicity = @"";
    }
    if (self.otherBeliefs == nil) {
        self.otherBeliefs = @"";
    }
    [dic setObject:self.otherEthnicity forKey:@"otherEthnicity"];
    [dic setObject:self.otherBeliefs forKey:@"otherBeliefs"];
    [dic setObject:[NSNumber numberWithBool:self.smoker] forKey:@"smoker"];
    [dic setObject:[NSNumber numberWithBool:self.veteran] forKey:@"veteran"];
    [dic setObject:[NSNumber numberWithBool:self.feelingBlue] forKey:@"feelingBlue"];
    
    return dic;
}

- (NSArray *) excludedFields {
    return @[@"age"];
}

- (NSDictionary *) genderField {
    return @{FXFormFieldOptions: GENDER_STRING_LIST, FXFormFieldTitle: @"Gender"};
}

- (NSDictionary *) statusField {
    return @{FXFormFieldOptions: STATUS_STRING_LIST, FXFormFieldTitle: @"Status"};
}
- (NSDictionary *) ethnicityField {
    return @{FXFormFieldOptions: ETHNICITY_STRING_LIST_1, FXFormFieldTitle: @"Ethnicity"};
}

- (NSDictionary *) drinkerField {
    return @{FXFormFieldOptions: DRINKER_STRING_LIST, FXFormFieldTitle: @"Drinker"};
}
- (NSDictionary *) beliefsField {
    return @{FXFormFieldOptions: BELIEFS_STRING_LIST_1,FXFormFieldTitle: @"Beliefs"};
}

- (NSDictionary *) contactField {
    return @{FXFormFieldOptions: CONTACT_STRING_LIST, FXFormFieldTitle: @"Contact"};
}

- (NSArray *) fields {
    
    return @[@"gender", @"status", @"ethnicity", @"otherEthnicity", @"smoker", @"drinker", @"beliefs", @"otherBeliefs", @"veteran", @"feelingBlue", @"contact"];

}

@end
