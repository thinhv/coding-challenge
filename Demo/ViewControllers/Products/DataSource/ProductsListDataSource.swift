//
//  ProductsListDataSource.swift
//  Demo
//
//  Created by Thinh Vo on 4/19/19.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import UIKit
import SDWebImage

typealias ProductsListDataSourceProtocol = UICollectionViewDataSource & UICollectionViewDelegate & ContentLoading

protocol ProductsListDataSourceDelegate: class {
    func productsListDataSource(_ dataSource: ProductsListDataSource, didSelectItemAtIndexPath indexPath: IndexPath)
}

class ProductsListDataSource: NSObject, ProductsListDataSourceProtocol {

    enum Dimensions {
        static var collectionViewItemSpacing: CGFloat {
            return 8.0
        }

        static var collectionViewSectionInset: CGFloat {
            return 8.0
        }

        /// Height of bottom loading activity indicator
        static var loadingRowHeight: CGFloat {
            return 80.0
        }

        /// Threshold at which the app triggers action to load more content
        static var threshold: CGFloat {
            return 10.0
        }
    }

    /// Loading state
    @objc dynamic var loadingState: LoadingState = .initial

    weak var delegate: ProductsListDataSourceDelegate?

    weak var collectionView: UICollectionView? {
        willSet {
            collectionView?.dataSource = nil
        }
        didSet {
            collectionView?.dataSource = self
            collectionView?.delegate = self
            collectionView?.registerNib(ProductCollectionViewCell.self)
            collectionView?.registerNib(
                viewClass: LoadingCollectionViewFooter.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
            collectionView?.reloadData()
            contentOffsetObservationToken =
                collectionView?.observe(
                    \UICollectionView.contentOffset,
                    changeHandler: { (collectionView, _) in
                        let threshold = collectionView.contentSize.height - Dimensions.threshold
                        if collectionView.bounds.height + collectionView.contentOffset.y >= threshold {
                            self.loadMoreIfNeeded()
                        }
            })
        }
    }

    let requestLoader: APIRequestLoader<ProductsRequest>

    private(set) var items: [Item] = []

    /// URL string which is used to fetch next items
    private(set) var next: String?

    private var contentOffsetObservationToken: NSKeyValueObservation? {
        willSet {
            contentOffsetObservationToken?.invalidate()
        }
    }

    init(loader: APIRequestLoader<ProductsRequest>) {
        requestLoader = loader
        super.init()
    }

    // MARK: Helper methods
    /**
     Helper method which fetches more items
     - parameters:
        - refresh: `Bool` value. If `true` the `items` is reset to new data.
                    Otherwise, the new products is appended to `items` array.
    */
    func loadMoreIfNeeded(refresh: Bool = false) {

        // Return if it is loading
        guard loadingState != .loading else { return }

        // Return if no more to load
        if loadingState != .initial && next == nil { return }

        loadingState = .loading

        requestLoader.loadRequest(requestData: next) { [weak self] (itemResponse, error) in
            guard let strongSelf = self else { return }

            if error != nil {
                strongSelf.loadingState = .error
                return
            }

            DispatchQueue.main.async {
                guard let response = itemResponse else { return }

                strongSelf.loadingState = .loaded

                if refresh {
                    strongSelf.items = response.result
                    strongSelf.collectionView?.reloadData()
                } else {
                    var currentItem = strongSelf.items.count
                    strongSelf.items.append(contentsOf: response.result)
                    let indexPathes = response.result.map({ (item) -> IndexPath in
                        let indexPath = IndexPath(item: currentItem, section: 0)
                        currentItem += 1
                        return indexPath
                    })
                    strongSelf.collectionView?.insertItems(at: indexPathes)
                }

                strongSelf.collectionView?.refreshControl?.endRefreshing()
                strongSelf.next = response.next
            }
        }
    }

    // MARK: UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(forRowAtIndexPath: indexPath)
        cell.delegate = self

        let item = items[indexPath.item]

        cell.imageView.sd_imageTransition = SDWebImageTransition.fade
        cell.imageView.sd_setImage(with: item.imageURL,
                                   placeholderImage: nil,
                                   options: .transformAnimatedImage,
                                   progress: nil,
                                   completed: nil)
        cell.titleLabel.text = item.title
        cell.priceLabel.text = "\(item.price.currency) \(item.price.value)"
        cell.subTitleLabel.text = item.category
        cell.likeButton.isSelected = item.liked

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let view = collectionView.dequeueReusableSupplementaryView(LoadingCollectionViewFooter.self,
                                                                       ofKind: kind,
                                                                       indexPath: indexPath)
            return view

        default:
            return UICollectionReusableView(frame: .zero)
        }
    }

    // MARK: UICollectionViewDelegate methods
    func collectionView(_ collectionView: UICollectionView,
                        willDisplaySupplementaryView view: UICollectionReusableView,
                        forElementKind elementKind: String,
                        at indexPath: IndexPath) {

        if elementKind == UICollectionView.elementKindSectionFooter {
            if let loadingView = view as? LoadingCollectionViewFooter {
                let animated = !(loadingState != .initial && next == nil)
                loadingView.animate(animated)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.productsListDataSource(self, didSelectItemAtIndexPath: indexPath)
    }

    // MARK: ContentLoading method
    func reloadData() {
        next = nil
        loadingState = .initial
        loadMoreIfNeeded(refresh: true)
    }
}

// MARK: - ProductCollectionViewCellDelegate methods
extension ProductsListDataSource: ProductCollectionViewCellDelegate {
    func productCollectionViewCellDidTapLikeButton(_ cell: ProductCollectionViewCell) {
        if let indexPath = collectionView?.indexPath(for: cell),
            indexPath.item < items.count {

            var item = items[indexPath.item]
            item.liked = !item.liked
            items[indexPath.item] = item
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout methods
extension ProductsListDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: Dimensions.loadingRowHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.bounds.size
        let itemWidth: CGFloat = (collectionViewSize.width - Dimensions.collectionViewItemSpacing * 3) / 2
        return CGSize(width: itemWidth, height: 1.5 * itemWidth)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Dimensions.collectionViewItemSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Dimensions.collectionViewItemSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0,
                            left: Dimensions.collectionViewSectionInset,
                            bottom: 0.0,
                            right: Dimensions.collectionViewSectionInset)
    }
}
