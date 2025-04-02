//
//  MarketMainView.swift
//  Ah Leongs Farm
//
//  Created by proglab on 1/4/25.
//
import UIKit

class MarketView: UIView {

    private var currency: Int

    // Initialization with currency value
    init(initialCurrency: Int) {
        self.currency = initialCurrency
        super.init(frame: .zero)
        setupView()
        updateCurrencyLabel(initialCurrency)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateCurrencyLabel(_ newAmount: Int) {
        currency = newAmount
        currencyLabel.text = "Coins: \(currency)"
    }

    // Header Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Market"
        label.font = UIFont(name: "Press Start 2P", size: 24)
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
    // Setup subviews and layout
    private func setupView() {
        backgroundColor = .white

        addSubview(titleLabel)
        addSubview(closeButton)
        addSubview(currencyLabel)
        addSubview(segmentedControl)
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            currencyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            currencyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            segmentedControl.topAnchor.constraint(equalTo: currencyLabel.bottomAnchor, constant: 20),
            segmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor),

            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}
