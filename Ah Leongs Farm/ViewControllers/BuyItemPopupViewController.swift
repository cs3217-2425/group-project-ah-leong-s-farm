//
//  BuyItemPopupViewController.swift
//  Ah Leongs Farm
//
//  Created by proglab on 2/4/25.
//

import UIKit

class BuyItemPopupViewController: UIViewController {

    weak var delegate: BuyPopupDelegate?

    private let item: BuyItemViewModel
    private var chosenQuantity: Int = 1
    private let currentCurrency: Int
    private var totalPrice: Int {
        Int(item.buyPrice) * chosenQuantity
    }

    private let titleLabel = UILabel()
    private let itemImageView = UIImageView()
    private let priceLabel = UILabel()
    private let chosenQuantityLabel = UILabel()
    private let plusButton = UIButton(type: .system)
    private let minusButton = UIButton(type: .system)
    private let buyButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .system)

    init(item: BuyItemViewModel, currentCurrency: Int) {
        self.item = item
        self.currentCurrency = currentCurrency
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        updateUI()
    }

    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)

        let popupView = createPopupView()
        view.addSubview(popupView)

        // Add and configure subviews inside popupView
        setupTitleLabel(in: popupView)
        setupCloseButton(in: popupView)
        setupItemImageView(in: popupView)
        setupPriceLabel(in: popupView)
        setupQuantityControls(in: popupView)
        setupBuyButton(in: popupView)

        NSLayoutConstraint.activate([
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popupView.widthAnchor.constraint(equalToConstant: 280),
            popupView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300),

            titleLabel.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),

            closeButton.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -10),

            itemImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            itemImageView.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 100),
            itemImageView.heightAnchor.constraint(equalToConstant: 100),

            priceLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 10),
            priceLabel.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),

            chosenQuantityLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            chosenQuantityLabel.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            chosenQuantityLabel.widthAnchor.constraint(equalToConstant: 40),
            chosenQuantityLabel.heightAnchor.constraint(equalToConstant: 40),

            minusButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            minusButton.trailingAnchor.constraint(equalTo: chosenQuantityLabel.leadingAnchor, constant: -10),
            minusButton.widthAnchor.constraint(equalToConstant: 40),
            minusButton.heightAnchor.constraint(equalToConstant: 40),
            minusButton.centerYAnchor.constraint(equalTo: chosenQuantityLabel.centerYAnchor),

            plusButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            plusButton.leadingAnchor.constraint(equalTo: chosenQuantityLabel.trailingAnchor, constant: 10),
            plusButton.widthAnchor.constraint(equalToConstant: 40),
            plusButton.heightAnchor.constraint(equalToConstant: 40),
            plusButton.centerYAnchor.constraint(equalTo: chosenQuantityLabel.centerYAnchor),

            buyButton.topAnchor.constraint(equalTo: minusButton.bottomAnchor, constant: 20),
            buyButton.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            buyButton.widthAnchor.constraint(equalToConstant: 140),
            buyButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func createPopupView() -> UIView {
        let popupView = UIView()
        popupView.backgroundColor = .white
        popupView.layer.cornerRadius = 10
        popupView.translatesAutoresizingMaskIntoConstraints = false
        return popupView
    }

    private func setupTitleLabel(in popupView: UIView) {
        titleLabel.text = "Buy \(item.name)"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(titleLabel)
    }

    private func setupCloseButton(in popupView: UIView) {
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.blue, for: .normal)
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closePopup), for: .touchUpInside)
        popupView.addSubview(closeButton)
    }

    private func setupItemImageView(in popupView: UIView) {
        itemImageView.image = UIImage(named: item.imageName)
        itemImageView.contentMode = .scaleAspectFit
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(itemImageView)
    }

    private func setupPriceLabel(in popupView: UIView) {
        let priceStackView = UIStackView()
        priceStackView.axis = .horizontal
        priceStackView.alignment = .center
        priceStackView.spacing = 5
        priceStackView.translatesAutoresizingMaskIntoConstraints = false

        let coinImageView = UIImageView()
        coinImageView.image = UIImage(imageLiteralResourceName: "coin")
        coinImageView.contentMode = .scaleAspectFit
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        coinImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        coinImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true

        priceLabel.text = "\(Int(item.buyPrice))"
        priceLabel.font = UIFont.systemFont(ofSize: 18)
        priceLabel.textAlignment = .left
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        priceStackView.addArrangedSubview(coinImageView)
        priceStackView.addArrangedSubview(priceLabel)

        popupView.addSubview(priceStackView)
    }

    private func setupQuantityControls(in popupView: UIView) {
        // Minus Button
        minusButton.setTitle("-", for: .normal)
        minusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
        popupView.addSubview(minusButton)

        // Quantity Label
        chosenQuantityLabel.text = "1"
        chosenQuantityLabel.textAlignment = .center
        chosenQuantityLabel.font = UIFont.systemFont(ofSize: 20)
        chosenQuantityLabel.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(chosenQuantityLabel)

        // Plus Button
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        popupView.addSubview(plusButton)
    }

    private func setupBuyButton(in popupView: UIView) {
        buyButton.setTitle("Buy", for: .normal)
        buyButton.backgroundColor = .systemGreen
        buyButton.setTitleColor(.white, for: .normal)
        buyButton.layer.cornerRadius = 5
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        buyButton.addTarget(self, action: #selector(confirmPurchase), for: .touchUpInside)
        popupView.addSubview(buyButton)
    }

    // MARK: - Button Actions

    @objc private func decreaseQuantity() {
        if chosenQuantity > 1 {
                chosenQuantity -= 1
        }
        updateUI()
    }

    @objc private func increaseQuantity() {
        if (chosenQuantity + 1) * Int(item.buyPrice) <= currentCurrency {
            chosenQuantity += 1
        }
        updateUI()
    }

    @objc private func confirmPurchase() {
        delegate?.didConfirmPurchase(item: item.itemType, quantity: chosenQuantity)
        dismiss(animated: true, completion: nil)
    }

    @objc private func closePopup() {
        dismiss(animated: true, completion: nil)
    }

    private func updateUI() {
        chosenQuantityLabel.text = "\(chosenQuantity)"
        priceLabel.text = "\(Int(item.buyPrice * Double(chosenQuantity)))"

        plusButton.isEnabled = (chosenQuantity + 1) * Int(item.buyPrice) <= currentCurrency
        plusButton.alpha = plusButton.isEnabled ? 1.0 : 0.5

        minusButton.isEnabled = chosenQuantity > 1
        minusButton.alpha = minusButton.isEnabled ? 1.0 : 0.5
    }
}

protocol BuyPopupDelegate: AnyObject {
    func didConfirmPurchase(item: ItemType, quantity: Int)
}
