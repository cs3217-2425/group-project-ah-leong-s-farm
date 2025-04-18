//
//  ActionButtonDelegate.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 17/4/25.
//

import UIKit

protocol ActionButtonDelegate: AnyObject {
    func didTapWaterButton()
    func didTapFertiliserButton()
    func didTapAddCropButton()
    func didTapHarvestCropButton()
    func didTapRemoveCropButton()
}

/// Manages the action buttons for plot interactions
class ActionButtonManager {

    // MARK: - Properties
    private let containerView: UIStackView
    private weak var delegate: ActionButtonDelegate?
    private(set) var buttons: [UIButton] = []

    // MARK: - Initialization
    init(in view: UIView, delegate: ActionButtonDelegate) {
        self.delegate = delegate

        // Create stack view for buttons
        containerView = UIStackView()
        containerView.axis = .horizontal
        containerView.spacing = 16
        containerView.distribution = .fillEqually
        containerView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(containerView)

        // Setup constraints
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Button Setup Methods
    func setupButtons(for plotViewModel: PlotViewModel) {
        // Clear any existing buttons
        buttons.removeAll()
        for view in containerView.arrangedSubviews {
            containerView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        // Always add water button
        addWaterButton()

        // Always add fertiliser button
        addFertiliserButton()

        // Add crop-specific buttons
        if let crop = plotViewModel.crop {
            addHarvestButton(enabled: crop.canHarvest)

            if !crop.canHarvest {
                addRemoveCropButton()
            }
        } else {
            addAddCropButton()
        }
    }

    private func addWaterButton() {
        let button = createButton(
            title: "Water Plot",
            color: .systemBlue,
            action: #selector(waterButtonTapped)
        )
        containerView.addArrangedSubview(button)
        buttons.append(button)
    }

    private func addFertiliserButton() {
        let button = createButton(
            title: "Use Fertiliser",
            color: .systemOrange,
            action: #selector(fertiliserButtonTapped)
        )
        containerView.addArrangedSubview(button)
        buttons.append(button)
    }

    private func addAddCropButton() {
        let button = createButton(
            title: "Add Crop",
            color: .systemGreen,
            action: #selector(addCropButtonTapped)
        )
        containerView.addArrangedSubview(button)
        buttons.append(button)
    }

    private func addHarvestButton(enabled: Bool) {
        let button = createButton(
            title: "Harvest Crop",
            color: enabled ? .systemGreen : .systemGray,
            action: #selector(harvestButtonTapped)
        )
        button.isEnabled = enabled
        containerView.addArrangedSubview(button)
        buttons.append(button)
    }

    private func addRemoveCropButton() {
        let button = createButton(
            title: "Remove Crop",
            color: .systemRed,
            action: #selector(removeCropButtonTapped)
        )
        containerView.addArrangedSubview(button)
        buttons.append(button)
    }

    private func createButton(title: String, color: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    // MARK: - Button Actions
    @objc private func waterButtonTapped() {
        delegate?.didTapWaterButton()
    }

    @objc private func fertiliserButtonTapped() {
        delegate?.didTapFertiliserButton()
    }

    @objc private func addCropButtonTapped() {
        delegate?.didTapAddCropButton()
    }

    @objc private func harvestButtonTapped() {
        delegate?.didTapHarvestCropButton()
    }

    @objc private func removeCropButtonTapped() {
        delegate?.didTapRemoveCropButton()
    }
}
