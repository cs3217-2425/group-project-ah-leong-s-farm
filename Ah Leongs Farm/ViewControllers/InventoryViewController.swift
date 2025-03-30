//
//  InventoryViewController.swift
//  Ah Leongs Farm
//

import UIKit

class InventoryViewController: UIViewController {
    // MARK: - Properties
    private var inventoryItems: [InventoryItemViewModel]
    private var containerView: UIView!
    private var collectionView: UICollectionView!
    private var selectedItemLabel: UILabel!

    private let itemsPerRow: CGFloat = 10
    private let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    // MARK: - Initialization
    init(inventoryItems: [InventoryItemViewModel]) {
        self.inventoryItems = inventoryItems
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        // Add tap gesture to dismiss the item name label
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissItemName))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    // MARK: - UI Setup
    private func setupView() {
        // Semi-transparent background
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        // Setup container view
        setupContainerView()

        // Setup header
        setupHeaderView()

        // Setup collection view
        setupCollectionView()

        // Setup item name label
        setupItemNameLabel()
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

    private func setupCollectionView() {
        // Create a flow layout for the grid
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = sectionInsets

        // Create the collection view
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = true
        collectionView.alwaysBounceVertical = true

        // Register the cell
        collectionView.register(InventoryItemCell.self, forCellWithReuseIdentifier: "InventoryItemCell")

        containerView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 60),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -50) // Leave space for the item name label
        ])
    }

    private func setupItemNameLabel() {
        selectedItemLabel = UILabel()
        selectedItemLabel.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        selectedItemLabel.textAlignment = .center
        selectedItemLabel.textColor = .black
        selectedItemLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        selectedItemLabel.layer.cornerRadius = 8
        selectedItemLabel.clipsToBounds = true
        selectedItemLabel.isHidden = true // Initially hidden
        selectedItemLabel.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(selectedItemLabel)

        NSLayoutConstraint.activate([
            selectedItemLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            selectedItemLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            selectedItemLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            selectedItemLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func dismissItemName() {
        selectedItemLabel.isHidden = true
    }

    private func showItemName(for item: InventoryItemViewModel) {
        selectedItemLabel.text = item.name
        selectedItemLabel.isHidden = false
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension InventoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inventoryItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InventoryItemCell", for: indexPath) as? InventoryItemCell else {
            fatalError("Unable to dequeue InventoryItemCell")
        }

        let item = inventoryItems[indexPath.item]
        cell.configure(with: item)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = inventoryItems[indexPath.item]
        showItemName(for: item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension InventoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate cell size to fit the desired number of items per row
        let paddingSpace = sectionInsets.left + sectionInsets.right + (itemsPerRow - 1) * 10
        let availableWidth = collectionView.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

// MARK: - Custom Cell for Inventory Items
class InventoryItemCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let quantityLabel = UILabel()
    private let emptyView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        // Cell background
        backgroundColor = UIColor.systemGray6
        layer.cornerRadius = 8
        clipsToBounds = true

        // Image view
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        // Empty state background
        emptyView.backgroundColor = .systemGray4
        emptyView.isHidden = true
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emptyView)

        // Quantity label
        quantityLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        quantityLabel.textColor = .white
        quantityLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
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
