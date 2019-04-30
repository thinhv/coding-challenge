//
//  ProductCollectionViewCell.swift
//  Demo
//
//  Created by Thinh Vo on 4/19/19.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import UIKit

protocol ProductCollectionViewCellDelegate: class {
    func productCollectionViewCellDidTapLikeButton(_ cell: ProductCollectionViewCell)
}

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!

    weak var delegate: ProductCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel.textColor = .black
        subTitleLabel.textColor = .lightGray
        priceLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        subTitleLabel.font = UIFont.systemFont(ofSize: 12.0)
        priceLabel.font = UIFont.systemFont(ofSize: 14.0)
        likeButton.setBackgroundImage(UIImage(named: "unlike"), for: .normal)
        likeButton.setBackgroundImage(UIImage(named: "like"), for: .selected)
        likeButton.tintColor = .clear
    }

    @IBAction func likeButtonTapped(_ sender: Any) {
        likeButton.isSelected = !likeButton.isSelected
        delegate?.productCollectionViewCellDidTapLikeButton(self)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
        subTitleLabel.text = nil
        priceLabel.text = nil
    }
}
