//
//  ProductsListDataSource.swift
//  Demo
//
//  Created by Thinh Vo on 4/19/19.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import UIKit

class ProductsListDataSource: NSObject, UICollectionViewDataSource {

    weak var collectionView: UICollectionView? {
        willSet {
            collectionView?.dataSource = nil
        }
        didSet {
            collectionView?.dataSource = self
            collectionView?.registerNib(ProductCollectionViewCell.self)
            collectionView?.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(forRowAtIndexPath: indexPath)
        return cell
    }
}
