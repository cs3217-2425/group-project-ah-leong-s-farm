//
//  MarketMainView.swift
//  Ah Leongs Farm
//
//  Created by proglab on 1/4/25.
//
import UIKit

class MarketView: UIView {

    // Header Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Market"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("X", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "Coins: 500"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Segmented Control
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Buy", "Sell"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    // Collection View
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 200)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    // Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // Setup subviews and layout
    private func setupView() {
        backgroundColor = .white

        addSubview(titleLabel)
        addSubview(closeButton)
        addSubview(currencyLabel)
        addSubview(segmentedControl)
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            // Header: Title at top-center
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            // Close button at top-right
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            // Currency label below title
            currencyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            currencyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            // Segmented control below currency label
            segmentedControl.topAnchor.constraint(equalTo: currencyLabel.bottomAnchor, constant: 20),
            segmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor),

            // Collection view below segmented control
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}
