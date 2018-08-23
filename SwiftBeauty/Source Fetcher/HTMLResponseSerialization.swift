//
//  HTMLResponseSerialization.swift
//  SwiftBeauty
//
//  Created by Nelson on 2018/8/3.
//  Copyright © 2018年 Nelson. All rights reserved.
//

import Foundation
import Alamofire
import SwiftSoup

extension DataRequest {
    static func htmlResponseSerializer(encoding: String.Encoding?) -> DataResponseSerializer<Document> {
        return DataResponseSerializer { _, response, data, error in
            // Pass through any underlying URLSession error to the .network case.
            guard error == nil else { return .failure(CustomError.network(error: error!)) }

            // Use Alamofire's existing data serializer to extract the data, passing the error as nil, as it has
            // already been handled.
            let result = Request.serializeResponseString(encoding: encoding, response: response, data: data, error: nil)

            guard case let .success(validData) = result else {
                return .failure(CustomError.dataSerialization(error: result.error! as! AFError))
            }

            do {
                let html: Document = try SwiftSoup.parse(validData)
                return .success(html)
            } catch {
                return .failure(CustomError.parse(error: error))
            }
        }
    }

    // swiftlint:disable opening_brace
    @discardableResult
    func responseHTMLDocument(
        queue: DispatchQueue? = nil,
        encoding: String.Encoding? = nil,
        completionHandler: @escaping (DataResponse<Document>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.htmlResponseSerializer(encoding: encoding),
            completionHandler: completionHandler
        )
    }

    @discardableResult
    func responseHTMLDocument(
        encoding: String.Encoding? = nil,
        completionHandler: @escaping (DataResponse<Document>) -> Void)
        -> Self
    {
        return response(
            queue: nil,
            responseSerializer: DataRequest.htmlResponseSerializer(encoding: encoding),
            completionHandler: completionHandler
        )
    }
}
