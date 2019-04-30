//
//  UICollectionView+Extensions.swift
//  Demo
//
//  Created by Thinh Vo on 4/19/19.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import UIKit

protocol ReusableView {}

extension ReusableView where Self: UIView {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: ReusableView {}

extension UICollectionView {
    func registerClass<T: UICollectionViewCell>(_ : T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reusableIdentifier)
    }

    func registerNib<T: UICollectionViewCell>(_ : T.Type, bundle: Bundle? = nil) {
        let nibName = String(describing: T.self)
        register(UINib(nibName: nibName, bundle: bundle), forCellWithReuseIdentifier: T.reusableIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(forRowAtIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reusableIdentifier, for: indexPath) as? T else {
            fatalError("\(String(describing: T.self)) type has never been registered to the collection view.)")
        }

        return cell
    }

    func register<T: UICollectionReusableView>(viewClass: T.Type, forSupplementaryViewOfKind kind: String) {
        register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reusableIdentifier)
    }

    func registerNib<T: UICollectionReusableView>(viewClass: T.Type, forSupplementaryViewOfKind kind: String) {
        let nibName = String(describing: T.self)
        register(UINib(nibName: nibName, bundle: nil),
                 forSupplementaryViewOfKind: kind,
                 withReuseIdentifier: T.reusableIdentifier)
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        _ : T.Type,
        ofKind kind: String,
        indexPath: IndexPath) -> UICollectionReusableView {

        return dequeueReusableSupplementaryView(ofKind: kind,
                                                withReuseIdentifier: T.reusableIdentifier,
                                                for: indexPath)
    }
}
