//
//  SourceFetchable.swift
//  SwiftBeauty
//
//  Created by Nelson on 2018/8/8.
//  Copyright © 2018年 Nelson. All rights reserved.
//

import Foundation

enum FetchResult<Value> {
    case success(Value)
    case failure(CustomError)
}

typealias Parser<T> = (_ html: String) throws -> [T]

protocol SourceFetchable {
    var sourceName: String { get }
    func fetchPosts(at page: UInt, completionHandler: @escaping (FetchResult<[Post]>) -> Void)
    func fetchPhotos(at url: URL, completionHandler: @escaping (FetchResult<[URL]>) -> Void)
}

extension SourceFetchable {
    func fetchHTML<T>(at url: URL, encoding: String.Encoding, using parser: @escaping Parser<T>, completionHandler: @escaping (FetchResult<[T]>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else {
                let result = FetchResult<[T]>.failure(.networkError(error!))
                completionHandler(result)
                return
            }

            guard let html = String(data: data, encoding: encoding) else {
                let result = FetchResult<[T]>.failure(.invalidData(data))
                completionHandler(result)
                return
            }

            do {
                let parseResult = try parser(html)
                let result: FetchResult<[T]> = (parseResult.isEmpty ? .failure(.emptyData) : .success(parseResult))
                completionHandler(result)
            } catch {
                let result: FetchResult<[T]> = .failure(.parseError(error))
                completionHandler(result)
            }
        }
        task.resume()
    }
}
