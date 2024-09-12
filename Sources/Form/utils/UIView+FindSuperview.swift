//
//  UIView+Extensions.swift
//
//  Created by xueqooy on 2022/9/14.
//

import UIKit
import SnapKit
import Combine

extension UIView {
    
    func findSuperview<T>(ofType _: T.Type) -> T? {
        guard let superview = superview else {
            return nil
        }

        if let superview = superview as? T {
            return superview
        }

        return superview.findSuperview(ofType: T.self)
    }
}
