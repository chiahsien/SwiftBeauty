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

protocol SourceFetchable {
    static var sourceName: String { get }
    init()
    func fetchPosts(at page: UInt, completionHandler: @escaping (FetchResult<[Post]>) -> Void)
    func fetchPhotos(at url: URL, completionHandler: @escaping (FetchResult<[URL]>) -> Void)
}
