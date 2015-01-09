//
//  RelationshipPrefs.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/25/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "RelationshipPrefs.h"

@implementation RelationshipPrefs
@synthesize sexualPref, age;

- (NSArray *)fields
{
    return @[
             @{FXFormFieldKey: @"sexualPref", FXFormFieldTitle:@"Sexual Preference", FXFormFieldOptions: [self stringArray], FXFormFieldAction: @"itemSelected"},
             @{FXFormFieldKey: @"age", FXFormFieldTitle: @"Age", FXFormFieldCell: [FXFormStepperCell class]},
             ];
    
}

- (NSArray *)extraFields
{
    return @[
             @{FXFormFieldTitle: @"OK", FXFormFieldHeader: @"", FXFormFieldAction: @"submit:"},
             ];
}

- (NSArray *) stringArray {
    return @[@"Man looking for Woman", @"Woman looking for Man", @"Man looking for Man", @"Woman looking for Woman", @"Couple looking for Couple", @"Bisexual looking for Bisexual"];
}

- (int) enumToIndex {
    switch (self.sexualPref) {
        case ManLookingForWoman:
            return 0;
        case WomanLookingForMan:
            return 1;
        case ManLookingForMan:
            return 2;
        case WomanLookingForWoman:
            return 3;
        case CoupleLookingForCouple:
            return 4;
        case BisexualLookingForBisexual:
            return 5;
    }
}

- (SexualPreference) indexToEnum: (int) index{
    switch(index) {
        case 0:
            return ManLookingForWoman;
        case 1:
            return WomanLookingForMan;
        case 2:
            return ManLookingForMan;
        case 3:
            return WomanLookingForWoman;
        case 4:
            return CoupleLookingForCouple;
        case 5:
            return BisexualLookingForBisexual;
    }
    
    return ManLookingForWoman;
}

@end
