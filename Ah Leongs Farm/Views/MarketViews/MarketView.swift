//
//  MarketMainView.swift
//  Ah Leongs Farm
//
//  Created by proglab on 1/4/25.
//
import UIKit

class MarketView: UIView {

    private var currency: Int

    init(initialCurrency: Int) {
        self.currency = initialCurrency
        super.init(frame: .zero)
        setupView()
        setCurrencyLabel(initialCurrency)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setCurrencyLabel(_ newAmount: Int) {
        currency = newAmount
        currencyLabel.text = "\(currency)"
    }

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

    let coinImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(imageLiteralResourceName: "coin")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 18).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 18).isActive = true
        return iv
    }()

    let separatorLine: UIView = {
        let separatorLine = UIView()
        separatorLine.backgroundColor = .lightGray
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        return separatorLine
    }()

    let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var currencyStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [coinImageView, currencyLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Buy", "Sell"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

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

    private func setupView() {
        backgroundColor = .white

        addSubview(titleLabel)
        addSubview(closeButton)
        addSubview(separatorLine)
        addSubview(currencyStackView)
        addSubview(segmentedControl)
        addSubview(collectionView)

        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            separatorLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),

            segmentedControl.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 20),
            segmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor),

            currencyStackView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 20),
            currencyStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}
