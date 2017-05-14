//
//  Extensions.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 2/26/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto
extension UIColor {
    public convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    public convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension String {
    func md5() -> [UInt8] {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        if let data = self.data(using: String.Encoding.utf8) {
            _ = data.withUnsafeBytes { bytes in
                CC_MD5(bytes, CC_LONG(data.count), &digest)
            }
            
        }
        
        return digest
    }

}
