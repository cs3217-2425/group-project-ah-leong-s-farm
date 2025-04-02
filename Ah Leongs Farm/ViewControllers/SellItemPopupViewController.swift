//
//  SellItemPopupViewController.swift
//  Ah Leongs Farm
//
//  Created by proglab on 2/4/25.
//

import UIKit

class SellItemPopupViewController: UIViewController {

    weak var delegate: SellPopupDelegate?

    private var item: SellItemViewModel
    private var itemQuantity: Int
    private var quantity: Int = 1
    private var totalValue: Int {
        Int(item.sellPrice) * quantity
    }

    private let titleLabel = UILabel()
    private let itemImageView = UIImageView()
    private let priceLabel = UILabel()
    private let quantityLabel = UILabel()
    private let plusButton = UIButton(type: .system)
    private let minusButton = UIButton(type: .system)
    private let sellButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .system)

    init(item: SellItemViewModel) {
        self.item = item
        self.itemQuantity = item.quantity
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
    }

    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)

        let popupView = createPopupView()
        view.addSubview(popupView)

        setupTitleLabel(in: popupView)
        setupCloseButton(in: popupView)
        setupItemImageView(in: popupView)
        setupPriceLabel(in: popupView)
        setupQuantityControls(in: popupView)
        setupSellButton(in: popupView)

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

            quantityLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            quantityLabel.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            quantityLabel.widthAnchor.constraint(equalToConstant: 40),
            quantityLabel.heightAnchor.constraint(equalToConstant: 40),

            minusButton.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor),
            minusButton.trailingAnchor.constraint(equalTo: quantityLabel.leadingAnchor, constant: -10),
            minusButton.widthAnchor.constraint(equalToConstant: 40),
            minusButton.heightAnchor.constraint(equalToConstant: 40),

            plusButton.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor),
            plusButton.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 10),
            plusButton.widthAnchor.constraint(equalToConstant: 40),
            plusButton.heightAnchor.constraint(equalToConstant: 40),

            sellButton.topAnchor.constraint(equalTo: quantityLabel.bottomAnchor, constant: 20),
            sellButton.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            sellButton.widthAnchor.constraint(equalToConstant: 140),
            sellButton.heightAnchor.constraint(equalToConstant: 40)
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
        titleLabel.text = "Sell \(item.name)"
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

        priceLabel.text = "\(item.sellPrice)"
        priceLabel.font = UIFont.systemFont(ofSize: 18)
        priceLabel.textAlignment = .left
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        priceStackView.addArrangedSubview(coinImageView)
        priceStackView.addArrangedSubview(priceLabel)
        popupView.addSubview(priceStackView)
    }

    private func setupQuantityControls(in popupView: UIView) {
        minusButton.setTitle("-", for: .normal)
        minusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
        popupView.addSubview(minusButton)

        quantityLabel.text = "1"
        quantityLabel.textAlignment = .center
        quantityLabel.font = UIFont.systemFont(ofSize: 20)
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(quantityLabel)

        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        popupView.addSubview(plusButton)
    }

    private func setupSellButton(in popupView: UIView) {
        sellButton.setTitle("Sell", for: .normal)
        sellButton.backgroundColor = .systemGreen
        sellButton.setTitleColor(.white, for: .normal)
        sellButton.layer.cornerRadius = 5
        sellButton.translatesAutoresizingMaskIntoConstraints = false
        sellButton.addTarget(self, action: #selector(confirmSale), for: .touchUpInside)
        popupView.addSubview(sellButton)
    }

    // MARK: - Button Actions

    @objc private func decreaseQuantity() {
        if quantity > 1 {
            quantity -= 1
            updateUI()
        }
    }

    @objc private func increaseQuantity() {
        if quantity + 1 <= itemQuantity {
            quantity += 1
            updateUI()
        }
    }

    @objc private func confirmSale() {
        delegate?.didConfirmSale(item: item.itemType, quantity: quantity)
        itemQuantity -= quantity
        dismiss(animated: true, completion: nil)
    }

    @objc private func closePopup() {
        dismiss(animated: true, completion: nil)
    }

    private func updateUI() {
        quantityLabel.text = "\(quantity)"
        priceLabel.text = "\(item.sellPrice * Double(quantity))"
    }
}

protocol SellPopupDelegate: AnyObject {
    func didConfirmSale(item: ItemType, quantity: Int)
}
