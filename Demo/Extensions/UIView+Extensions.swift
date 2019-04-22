//
//  UIView+Extensions.swift
//  Demo
//
//  Created by Thinh Vo on 4/20/19.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import UIKit

extension UIView {

    /**
     Helper method.
     This method is a shortcut to create a view which is going to be
     laid out using Auto Layout.
     */
    class func autoLayoutView<T: UIView>() -> T {
        let view = T(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
