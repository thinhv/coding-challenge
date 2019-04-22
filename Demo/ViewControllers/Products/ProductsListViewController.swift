//
//  ProductsListViewController.swift
//  Demo
//
//  Created by Thinh Vo on 4/19/19.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import UIKit

class ProductsListViewController: UIViewController {

    struct Dimensions {
        static let itemSpacing: CGFloat = 8.0
        static let inset: CGFloat = 8.0
    }

    private lazy var dataSource: ProductsListDataSource = ProductsListDataSource()

    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let itemWidth: CGFloat = (CGFloat.screenWidth - Dimensions.itemSpacing * 3) / 2
        layout.itemSize = CGSize(width: itemWidth, height: 1.5 * itemWidth)
        layout.minimumLineSpacing = Dimensions.itemSpacing
        layout.minimumInteritemSpacing = Dimensions.itemSpacing
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: Dimensions.inset, bottom: 0.0, right: Dimensions.inset)
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let view: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)

        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        dataSource.collectionView = collectionView
    }
}
