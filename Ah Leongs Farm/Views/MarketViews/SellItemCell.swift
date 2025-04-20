//
//  SellItemCell.swift
//  Ah Leongs Farm
//
//  Created by proglab on 3/4/25.
//
import UIKit

class SellItemCell: UICollectionViewCell {
    private let itemImageView = UIImageView()
    private let priceStackView = UIStackView()
    private let coinImageView = UIImageView()
    private let priceLabel = UILabel()
    private let quantityLabel = UILabel()

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
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        priceStackView.axis = .horizontal
        priceStackView.alignment = .center
        priceStackView.spacing = 4
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        priceStackView.addArrangedSubview(coinImageView)
        priceStackView.addArrangedSubview(priceLabel)
        contentView.addSubview(priceStackView)

        quantityLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        quantityLabel.textColor = .white
        quantityLabel.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        quantityLabel.textAlignment = .center
        quantityLabel.layer.cornerRadius = 8
        quantityLabel.clipsToBounds = true
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(quantityLabel)

        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            itemImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            itemImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            itemImageView.heightAnchor.constraint(equalTo: itemImageView.widthAnchor),

            priceStackView.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 5),
            priceStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            quantityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            quantityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            quantityLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 24),
            quantityLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    func configure(with viewModel: SellItemViewModel) {
        itemImageView.image = UIImage(named: viewModel.imageName)
        priceLabel.text = "\(Int(viewModel.sellPrice))"
        quantityLabel.text = "x\(viewModel.quantity)"

        // Disable interaction if that item has 0 quantity
        if viewModel.quantity == 0 {
            contentView.alpha = 0.5
            isUserInteractionEnabled = false
        } else {
            contentView.alpha = 1.0
            isUserInteractionEnabled = true
        }
    }

    @objc private func sellButtonTapped() {
    }
}
