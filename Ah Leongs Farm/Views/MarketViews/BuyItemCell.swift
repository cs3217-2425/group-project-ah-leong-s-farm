//
//  BuyItemCell.swift
//  Ah Leongs Farm
//
//  Created by proglab on 1/4/25.
//

import UIKit

class BuyItemCell: UICollectionViewCell {
    private let itemImageView = UIImageView()
    private let priceStackView = UIStackView()
    private let coinImageView = UIImageView()
    private let priceLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: topAnchor),
                contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])

            contentView.backgroundColor = #colorLiteral(red: 0.8551856875, green: 0.8551856875, blue: 0.8551856875, alpha: 1)
            contentView.layer.cornerRadius = 8
            contentView.layer.masksToBounds = true

            itemImageView.contentMode = .scaleAspectFit
            itemImageView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(itemImageView)

            coinImageView.image = UIImage(imageLiteralResourceName: "coin")
            coinImageView.contentMode = .scaleAspectFit
            coinImageView.translatesAutoresizingMaskIntoConstraints = false
            coinImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
            coinImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true

            priceLabel.font = UIFont.systemFont(ofSize: 14)
            priceLabel.textColor = UIColor.black
            priceLabel.textAlignment = .left

            priceStackView.axis = .horizontal
            priceStackView.alignment = .center
            priceStackView.spacing = 4
            priceStackView.translatesAutoresizingMaskIntoConstraints = false
            priceStackView.addArrangedSubview(coinImageView)
            priceStackView.addArrangedSubview(priceLabel)
            contentView.addSubview(priceStackView)

            NSLayoutConstraint.activate([
                itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                itemImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                itemImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
                itemImageView.heightAnchor.constraint(equalTo: itemImageView.widthAnchor),

                priceStackView.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 5),
                priceStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                priceStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
            ])
        }

    func configure(with viewModel: BuyItemViewModel, currentCurrency: Int) {
        itemImageView.image = UIImage(named: viewModel.imageName)
        priceLabel.text = "\(Int(viewModel.buyPrice))"

        if currentCurrency < Int(viewModel.buyPrice) {
            contentView.alpha = 0.5
            isUserInteractionEnabled = false
        } else {
            contentView.alpha = 1.0
            isUserInteractionEnabled = true
        }
    }
}
