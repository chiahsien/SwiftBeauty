//
//  CustomNavigationController.swift
//  SwiftBeauty
//
//  Created by Nelson on 2018/8/19.
//  Copyright © 2018年 Nelson. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
