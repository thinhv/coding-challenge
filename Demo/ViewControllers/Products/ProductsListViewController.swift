//
//  ProductsListViewController.swift
//  Demo
//
//  Created by Thinh Vo on 4/19/19.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import UIKit

class ProductsListViewController: UIViewController {

    lazy var loader: APIRequestLoader<ProductsRequest> = APIRequestLoader(request: ProductsRequest())

    lazy var dataSource: ProductsListDataSource = ProductsListDataSource(loader: loader)

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var refreshControl = UIRefreshControl()

    private lazy var collectionView: UICollectionView = {
        let view: UICollectionView = UICollectionView(frame: .zero,
                                                      collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.refreshControl = refreshControl
        return view
    }()

    var dataSourceStateObservationToken: NSKeyValueObservation? {
        willSet {
            dataSourceStateObservationToken?.invalidate()
        }
    }

    var initialLoading: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    deinit {
        // Prior to iOS 11 it is required to set observation token to nil
        dataSourceStateObservationToken = nil
    }

    @objc func refreshContent(_ sender: Any) {
        dataSource.reloadData()
    }

    // MARK: Helper methods
    func setup() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)

        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        dataSourceStateObservationToken = dataSource.observe(
            \ProductsListDataSource.loadingState,
            options: [.initial, .new], changeHandler: { [weak self] (dataSource, _) in
                switch dataSource.loadingState {
                case .initial:
                    self?.collectionView.isHidden = true
                    self?.loadingIndicator.isHidden = false
                    self?.loadingIndicator.startAnimating()
                case .error:
                    #if DEBUG
                    print("Error while loading product list")
                    #endif
                default:
                    guard let initialLoading = self?.initialLoading, !initialLoading else {
                        self?.initialLoading = false
                        return
                    }
                    self?.collectionView.isHidden = false
                    self?.loadingIndicator.isHidden = true
                    self?.loadingIndicator.stopAnimating()
                }
        })

        dataSource.collectionView = collectionView
        refreshControl.addTarget(self, action: #selector(refreshContent(_:)), for: .valueChanged)
    }

}
