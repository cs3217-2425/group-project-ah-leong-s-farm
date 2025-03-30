//
//  InventoryViewController.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 30/3/25.
//

import UIKit

class InventoryViewController: UIViewController {
    // MARK: - Properties
    private var inventoryItems: [InventoryItemViewModel]
    private var containerView: UIView!
    private var scrollView: UIScrollView!

    // MARK: - Initialization
    init(inventoryItems: [InventoryItemViewModel]) {
        self.inventoryItems = inventoryItems
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - UI Setup
    private func setupView() {
        // Semi-transparent background
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        // Setup container view
        setupContainerView()

        // Setup header
        setupHeaderView()

        // Display inventory items
        setupInventoryList()
    }

    private func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
        ])
    }

    private func setupHeaderView() {
        // Title label
        let titleLabel = UILabel()
        titleLabel.text = "Inventory"
        titleLabel.font = UIFont(name: "Press Start 2P", size: 18) ?? UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)

        // Close button
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("X", for: .normal)
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(closeButton)

        // Separator line
        let separatorLine = UIView()
        separatorLine.backgroundColor = .lightGray
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLine)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 50),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -50),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),

            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40),

            separatorLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            separatorLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            separatorLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            separatorLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func setupInventoryList() {
        // Create scroll view for content
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(scrollView)

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 60),
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])

        if inventoryItems.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "Your inventory is empty"
            emptyLabel.textAlignment = .center
            emptyLabel.textColor = .gray
            emptyLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(emptyLabel)

            NSLayoutConstraint.activate([
                emptyLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                emptyLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -30),
                emptyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                emptyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                emptyLabel.heightAnchor.constraint(equalToConstant: 44),
                contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
            ])
        } else {
            var previousView: UIView?

            for (index, item) in inventoryItems.enumerated() {
                let itemView = createItemView(item: item)
                contentView.addSubview(itemView)

                NSLayoutConstraint.activate([
                    itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    itemView.heightAnchor.constraint(equalToConstant: 60)
                ])

                if let previousView = previousView {
                    itemView.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 10).isActive = true
                } else {
                    itemView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
                }

                // If last item, set bottom constraint
                if index == inventoryItems.count - 1 {
                    itemView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
                }

                previousView = itemView
            }
        }
    }

    private func createItemView(item: InventoryItemViewModel) -> UIView {
        let itemView = UIView()
        itemView.backgroundColor = UIColor.systemGray6
        itemView.layer.cornerRadius = 8
        itemView.translatesAutoresizingMaskIntoConstraints = false

        // Item image
        let itemImageView = UIImageView()
        itemImageView.contentMode = .scaleAspectFit
        itemImageView.image = UIImage(named: item.imageName) // Assuming asset exists
        // Fallback icon if image not found
        if itemImageView.image == nil {
            itemImageView.backgroundColor = .systemGray4
            itemImageView.layer.cornerRadius = 8
            itemImageView.clipsToBounds = true
        }
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemView.addSubview(itemImageView)

        // Item name
        let nameLabel = UILabel()
        nameLabel.text = item.name
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemView.addSubview(nameLabel)

        // Quantity
        let quantityLabel = UILabel()
        quantityLabel.text = "x\(item.quantity)"
        quantityLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        quantityLabel.textAlignment = .right
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        itemView.addSubview(quantityLabel)

        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: itemView.leadingAnchor, constant: 12),
            itemImageView.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 40),
            itemImageView.heightAnchor.constraint(equalToConstant: 40),

            nameLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: quantityLabel.leadingAnchor, constant: -10),

            quantityLabel.trailingAnchor.constraint(equalTo: itemView.trailingAnchor, constant: -16),
            quantityLabel.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
            quantityLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])

        return itemView
    }

    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}
