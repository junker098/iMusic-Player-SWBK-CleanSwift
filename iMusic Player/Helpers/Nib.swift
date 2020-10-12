//
//  Nib.swift
//  iMusic Player
//
//  Created by Юрий Могорита on 13.10.2020.
//  Copyright © 2020 Yuri Mogorita. All rights reserved.
//

import UIKit

extension UIView {
    
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
