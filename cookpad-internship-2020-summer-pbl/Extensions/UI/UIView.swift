//
//  UIView.swift
//  cookpad-internship-2020-summer-pbl
//
//  Created by Ren Matsushita on 2020/08/27.
//  Copyright © 2020 Ren Matsushita. All rights reserved.
//

import UIKit

public extension UIView {
    class func create<T>(owner: UIViewController? = nil) -> T where T: UIView {
        let nib = UINib(nibName: NSStringFromClass(self).components(separatedBy: ".").last!, bundle: nil)
        return nib.instantiate(withOwner: owner, options: nil)[0] as! T
    }
}
