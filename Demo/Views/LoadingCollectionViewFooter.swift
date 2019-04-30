//
//  LoadingCollectionViewFooter.swift
//  Demo
//
//  Created by Thinh Vo Duc on 29/04/2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import UIKit

class LoadingCollectionViewFooter: UICollectionReusableView {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()

        loadingIndicator.hidesWhenStopped = true
        animate(true)
    }

    func animate(_ animating: Bool) {
        if animating {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
}
