//
//  InventoryItemCell.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 4/4/25.
//

import UIKit
class InventoryItemCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let quantityLabel = UILabel()
    private let emptyView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        // Cell background
        backgroundColor = #colorLiteral(red: 0.8551856875, green: 0.8551856875, blue: 0.8551856875, alpha: 1)
        layer.cornerRadius = 8
        clipsToBounds = true

        // Image view
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        // Empty state background
        emptyView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        emptyView.isHidden = true
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emptyView)

        // Quantity label
        quantityLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        quantityLabel.textColor = .white
        quantityLabel.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        quantityLabel.textAlignment = .center
        quantityLabel.layer.cornerRadius = 8
        quantityLabel.clipsToBounds = true
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(quantityLabel)

        NSLayoutConstraint.activate([
            // Image view fills the cell
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

            // Empty view same size as image view
            emptyView.topAnchor.constraint(equalTo: imageView.topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),

            // Quantity label at bottom right
            quantityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            quantityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            quantityLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 24),
            quantityLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    func configure(with viewModel: InventoryItemViewModel) {
        let image = UIImage(named: viewModel.imageName)

        if let image = image {
            imageView.image = image
            emptyView.isHidden = true
        } else {
            // If image not found, show placeholder
            imageView.image = nil
            emptyView.isHidden = false
        }

        quantityLabel.text = "x\(viewModel.quantity)"
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        quantityLabel.text = nil
    }

}
