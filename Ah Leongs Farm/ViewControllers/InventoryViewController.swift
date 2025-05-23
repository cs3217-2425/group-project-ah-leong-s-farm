//
//  InventoryViewController.swift
//  Ah Leongs Farm
//

import UIKit

class InventoryViewController: UIViewController {
    // MARK: - Properties
    private var inventoryItems: [InventoryItemViewModel]
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = sectionInsets

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = true
        collectionView.alwaysBounceVertical = true

        collectionView.register(InventoryItemCell.self, forCellWithReuseIdentifier: "InventoryItemCell")

        return collectionView
    }()

    private lazy var selectedItemLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let itemsPerRow: CGFloat = 10
    private let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

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

        // Add tap gesture to dismiss the item name label
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }

    // MARK: - UI Setup
    private func setupView() {
        // Semi-transparent background
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        setupContainerView()

        setupHeaderView()

        setupCollectionView()

        setupItemNameLabel()

    }

    private func setupContainerView() {
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
        ])
    }

    private func setupCollectionView() {
        containerView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 60),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -50)
        ])
    }

    private func setupItemNameLabel() {
        containerView.addSubview(selectedItemLabel)

        NSLayoutConstraint.activate([
            selectedItemLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            selectedItemLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            selectedItemLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            selectedItemLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupHeaderView() {
        // Title label
        let titleLabel = UILabel()
        titleLabel.text = "Inventory"
        titleLabel.font = UIFont(name: "Press Start 2P", size: 18) ?? UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = UIColor.black
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

    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let locationInView = gesture.location(in: view)

        if !containerView.frame.contains(locationInView) {
            dismiss(animated: true)
            return
        }

        if !selectedItemLabel.isHidden {
            selectedItemLabel.isHidden = true
        }
    }

    private func showItemName(for item: InventoryItemViewModel) {
        selectedItemLabel.text = item.name
        selectedItemLabel.isHidden = false
    }

    // Hide status bar
    override var prefersStatusBarHidden: Bool {
        true
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension InventoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        inventoryItems.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InventoryItemCell",
                                                            for: indexPath) as? InventoryItemCell else {
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

// MARK: - UIGestureRecognizerDelegate
extension InventoryViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        true
    }
}
