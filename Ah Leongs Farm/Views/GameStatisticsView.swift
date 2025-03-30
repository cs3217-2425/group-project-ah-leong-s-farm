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
            label.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.widthAnchor.constraint(equalToConstant: 250),
            label.heightAnchor.constraint(equalToConstant: 40)
        ])

        self.dayLabel = label
    }

    private func createCurrencyLabel() {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Press Start 2P", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.heightAnchor.constraint(equalToConstant: 40)
        ])

        self.currencyLabel = label
    }

    func updateDayLabel(currentTurn: Int, maxTurns: Int) {
        dayLabel?.text = "DAY \(currentTurn)/\(maxTurns)"
    }

    func updateCurrencyLabel(currency: Double) {
        currencyLabel?.text = "\(Int(currency)) coins"
    }
}
