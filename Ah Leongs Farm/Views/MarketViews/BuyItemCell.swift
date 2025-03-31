//
//  BuyItemCell.swift
//  Ah Leongs Farm
//
//  Created by proglab on 1/4/25.
//
import UIKit

class BuyItemCell: UICollectionViewCell {
    private let itemImageView = UIImageView()
    private let priceLabel = UILabel()
    private let buyButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        itemImageView.contentMode = .scaleAspectFit
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(itemImageView)

        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textAlignment = .center
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)

        buyButton.setTitle("Buy", for: .normal)
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        contentView.addSubview(buyButton)

        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 100),
            itemImageView.heightAnchor.constraint(equalToConstant: 100),

            priceLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 10),
            priceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            buyButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            buyButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with item: MarketItem) {
        itemImageView.image = item.image
        priceLabel.text = "Price: \(item.price)"
    }

    @objc private func buyButtonTapped() {
        print("Buy button tapped!")
        // Add buy action handling here
    }
}

// MARK: - SellItemCell

class SellItemCell: UICollectionViewCell {
    private let itemImageView = UIImageView()
    private let priceLabel = UILabel()
    private let sellButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        itemImageView.contentMode = .scaleAspectFit
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(itemImageView)

        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textAlignment = .center
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)

        sellButton.setTitle("Sell", for: .normal)
        sellButton.translatesAutoresizingMaskIntoConstraints = false
        sellButton.addTarget(self, action: #selector(sellButtonTapped), for: .touchUpInside)
        contentView.addSubview(sellButton)

        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 100),
            itemImageView.heightAnchor.constraint(equalToConstant: 100),

            priceLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 10),
            priceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            sellButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            sellButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            sellButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configure(with item: MarketItem) {
        itemImageView.image = item.image
        priceLabel.text = "Price: \(item.price)"
    }

    @objc private func sellButtonTapped() {
        print("Sell button tapped!")
        // Add sell action handling here
    }
}
