//
//  SwiftyJSONExtension.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 2/22/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension DataRequest {
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter options:           The JSON serialization reading options. Defaults to `.allowFragments`.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseSwiftyJSON(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DataResponse<JSON>) -> Void) -> Self {
        return response(
            queue: queue,
            responseSerializer: DataRequest.swiftyJSONResponseSerializer(options: options),
            completionHandler: completionHandler
        )
    }
    
    /// Creates a response serializer that returns a SwiftyJSON instance result type constructed from the response data using
    /// `JSONSerialization` with the specified reading options.
    ///
    /// - parameter options: The JSON serialization reading options. Defaults to `.allowFragments`.
    ///
    /// - returns: A SwiftyJSON response serializer.
    public static func swiftyJSONResponseSerializer(
        options: JSONSerialization.ReadingOptions = .allowFragments) -> DataResponseSerializer<JSON> {
        return DataResponseSerializer { _, response, data, error in
            let result = Request.serializeResponseJSON(options: options, response: response, data: data, error: error)
            switch result {
            case .success(let value):
                return .success(JSON(value))
            case .failure(let error):
                return .failure(error)
            }
        }
    }
}
