//
//  Utilities.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 6/14/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import Foundation

public func isURLValid(_ url: URL) -> Bool {
    let request = NSMutableURLRequest(url: url)
    request.httpMethod = "HEAD"
    let semaphore = DispatchSemaphore(value: 1)
    var retVal: Bool = false
    _ = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
        if let httpResp = response as? HTTPURLResponse {
            retVal = (httpResp.statusCode == 200)
        }
        semaphore.signal()
    }
    semaphore.wait()
    return retVal
}
