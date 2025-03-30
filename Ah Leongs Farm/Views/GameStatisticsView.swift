//
//  GameStatisticsView.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 30/3/25.
//

import UIKit

class GameStatisticsView: UIView {
    private var dayLabel: UILabel?
    private var currencyLabel: UILabel?

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear
        createDayLabel()
        createCurrencyLabel()
    }

    private func createDayLabel() {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(name: "Press Start 2P", size: 26)
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])

        self.dayLabel = label
    }

    private func createCurrencyLabel() {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Press Start 2P", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false

        let imageName = "coin"
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])

        let stackView = UIStackView(arrangedSubviews: [label, imageView])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])

        self.currencyLabel = label
    }

    func updateDayLabel(currentTurn: Int, maxTurns: Int) {
        dayLabel?.text = "DAY \(currentTurn)/\(maxTurns)"
    }

    func updateCurrencyLabel(currency: Double) {
        currencyLabel?.text = "\(Int(currency))"
    }
}
