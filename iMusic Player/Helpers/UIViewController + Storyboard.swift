//
//  UIViewController + Storyboard.swift
//  iMusic Player
//
//  Created by Юрий Могорита on 01.10.2020.
//  Copyright © 2020 Yuri Mogorita. All rights reserved.
//

import UIKit

extension UIViewController {
    class func loadFromStoryboard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        if let viewController = storyboard.instantiateInitialViewController() as? T {
            return viewController
        } else {
            fatalError("Error name storyboard \(name)")
        }
    }
}
