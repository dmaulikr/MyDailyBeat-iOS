//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  DLAVAlertView_TextFieldOptions.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/21/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import DLAlertView
extension DLAVAlertView {
    func setAutoCapitalizationType(_ autoCapitalizationType: UITextAutocapitalizationType, ofTextFieldAt index: Int) {
        self.textField(at: index)?.autocapitalizationType = autoCapitalizationType
    }

    func setAutoCorrectionType(_ autoCorrectionType: UITextAutocorrectionType, ofTextFieldAt index: Int) {
        self.textField(at: index)?.autocorrectionType = autoCorrectionType
    }
}
import Foundation
