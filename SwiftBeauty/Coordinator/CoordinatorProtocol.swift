//
//  CoordinatorProtocol.swift
//  SwiftBeauty
//
//  Created by Nelson on 2018/8/12.
//  Copyright © 2018年 Nelson. All rights reserved.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    init(navigationController: UINavigationController)
    func start()
}
