//
//  GameControlsView.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 30/3/25.
//

import UIKit

class GameControlsView: UIView {
    private weak var delegate: GameControlsViewDelegate?

    init(delegate: GameControlsViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear
        createQuitButton()
        createNextButton()
        createMarketButton()
    }

    private func createNextButton() {
        let nextButton = UIButton(type: .system)

        nextButton.setTitle("Next Day", for: .normal)
        nextButton.backgroundColor = .systemBlue
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 10
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.titleLabel?.font = UIFont(name: "Press Start 2P", size: 12)

        addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: topAnchor),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -110),
            nextButton.widthAnchor.constraint(equalToConstant: 140),
            nextButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        nextButton.addTarget(self, action: #selector(nextDayButtonTapped), for: .touchUpInside)
    }

    private func createQuitButton() {
        let quitButton = UIButton(type: .system)

        quitButton.setTitle("Quit", for: .normal)
        quitButton.backgroundColor = .systemRed
        quitButton.setTitleColor(.white, for: .normal)
        quitButton.layer.cornerRadius = 10
        quitButton.translatesAutoresizingMaskIntoConstraints = false
        quitButton.titleLabel?.font = UIFont(name: "Press Start 2P", size: 12)

        addSubview(quitButton)
        NSLayoutConstraint.activate([
            quitButton.topAnchor.constraint(equalTo: topAnchor),
            quitButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            quitButton.widthAnchor.constraint(equalToConstant: 100),
            quitButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        quitButton.addTarget(self, action: #selector(quitButtonTapped), for: .touchUpInside)
    }

    private func createMarketButton() {
        let marketButton = UIButton(type: .system)

        marketButton.setTitle("Market", for: .normal)
        marketButton.backgroundColor = .systemGreen
        marketButton.setTitleColor(.white, for: .normal)
        marketButton.layer.cornerRadius = 10
        marketButton.translatesAutoresizingMaskIntoConstraints = false
        marketButton.titleLabel?.font = UIFont(name: "Press Start 2P", size: 12)

        addSubview(marketButton)
        NSLayoutConstraint.activate([
            marketButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            marketButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            marketButton.widthAnchor.constraint(equalToConstant: 100),
            marketButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        marketButton.addTarget(self, action: #selector(marketButtonTapped), for: .touchUpInside)
    }

    @objc private func nextDayButtonTapped() {
        delegate?.nextDayButtonTapped()
    }

    @objc private func quitButtonTapped() {
        delegate?.quitButtonTapped()
    }

    @objc private func marketButtonTapped() {
        delegate?.marketButtonTapped()
    }
}
