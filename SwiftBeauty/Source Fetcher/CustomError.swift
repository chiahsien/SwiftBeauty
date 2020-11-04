//
//  CustomError.swift
//  SwiftBeauty
//
//  Created by Nelson on 2018/8/3.
//  Copyright © 2018年 Nelson. All rights reserved.
//

import Foundation

enum CustomError: Error {
    case network(error: Error) // Capture any underlying Error from the URLSession API
    case dataSerialization(error: Error)
    case parse(error: Error)
    case networkError(_: Error)
    case parseError(_: Error)
    case invalidData(_: Data)
    case emptyData
}
