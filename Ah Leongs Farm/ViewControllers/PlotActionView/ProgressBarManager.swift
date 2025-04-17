//
//  ProgressBarManager.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 17/4/25.
//

import UIKit

class ProgressBarManager {

    // MARK: - Properties
    private let containerView: UIView

    private var soilQualityProgressBar: ProgressBar?
    private var growthProgressBar: ProgressBar?
    private var healthProgressBar: ProgressBar?

    // MARK: - Initialization
    init(containerView: UIView) {
        self.containerView = containerView

        setupContainerConstraints()
    }

    private func setupContainerConstraints() {
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: containerView.superview!.widthAnchor, multiplier: 0.4)
        ])
    }

    // MARK: - Setup Methods
    func setupProgressBars(for plotViewModel: PlotViewModel) {
        // Setup soil quality bar (always visible)
        setupSoilQualityBar(quality: plotViewModel.soilQuality, maxQuality: plotViewModel.maxSoilQuality)

        // Add crop-specific bars if a crop exists
        if let crop = plotViewModel.crop {
            setupGrowthBar(current: crop.currentGrowthTurn, max: Float(crop.totalGrowthTurns))
            setupHealthBar(health: crop.currentHealth)
        }
    }

    private func setupSoilQualityBar(quality: Float, maxQuality: Float) {
        let titleLabel = createTitleLabel(title: "Soil Quality:")
        containerView.addSubview(titleLabel)

        let progressBar = ProgressBar(frame: .zero)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.setProgress(
            current: quality,
            max: maxQuality,
            label: "",
            showText: false
        )
        containerView.addSubview(progressBar)
        self.soilQualityProgressBar = progressBar

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            progressBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            progressBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 30)
        ])

        // If no crop bars will be added, set bottom constraint
        if growthProgressBar == nil && healthProgressBar == nil {
            progressBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
        }
    }

    private func setupGrowthBar(current: Float, max: Float) {
        guard let soilQualityBar = soilQualityProgressBar else { return }

        let titleLabel = createTitleLabel(title: "Growth Progress:")
        containerView.addSubview(titleLabel)

        let progressBar = ProgressBar(frame: .zero)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.setProgress(
            current: current,
            max: max,
            label: ""
        )
        containerView.addSubview(progressBar)
        self.growthProgressBar = progressBar

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: soilQualityBar.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            progressBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            progressBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func setupHealthBar(health: Double) {
        guard let growthBar = growthProgressBar else { return }

        let titleLabel = createTitleLabel(title: "Health:")
        containerView.addSubview(titleLabel)

        let progressBar = ProgressBar(frame: .zero)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.setProgress(
            current: Float(health),
            max: 1.0,
            label: "",
            showText: false
        )
        containerView.addSubview(progressBar)
        self.healthProgressBar = progressBar

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: growthBar.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            progressBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            progressBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 30),
            progressBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }

    private func createTitleLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
