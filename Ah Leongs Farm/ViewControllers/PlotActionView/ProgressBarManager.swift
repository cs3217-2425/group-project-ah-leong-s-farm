//
//  ProgressBarManager.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 17/4/25.
//

import UIKit

/// Manages the progress bars for plot data visualization
class ProgressBarManager {

    // MARK: - Properties
    private let containerView: UIView

    private var soilQualityProgressBar: ProgressBar?
    private var growthProgressBar: ProgressBar?
    private var healthProgressBar: ProgressBar?
    private var yieldProgressBar: ProgressBar?

    // Track all bottom constraints so we can manage them
    private var bottomConstraints: [NSLayoutConstraint] = []

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
        // Clear any existing views from container
        containerView.subviews.forEach { $0.removeFromSuperview() }
        bottomConstraints.forEach { $0.isActive = false }
        bottomConstraints.removeAll()

        // Setup soil quality bar (always visible)
        let soilBar = setupSoilQualityBar(quality: plotViewModel.soilQuality, maxQuality: plotViewModel.maxSoilQuality)
        var lastBar = soilBar

        // Add crop-specific bars if a crop exists
        if let crop = plotViewModel.occupant as? CropViewModel {
            // Setup growth bar
            let growthBar = setupGrowthBar(
                after: soilBar,
                current: crop.currentGrowthTurn,
                max: Float(crop.totalGrowthTurns)
            )
            lastBar = growthBar

            // Setup health bar
            let healthBar = setupHealthBar(
                after: growthBar,
                health: crop.currentHealth
            )
            lastBar = healthBar

            let yieldBar = setupYieldBar(
                after: healthBar,
                current: Float(crop.currentYield),
                max: Float(crop.maxYield)
            )
            lastBar = yieldBar
        }

        // Add bottom constraint only to the last bar
        let bottomConstraint = lastBar.bottomAnchor.constraint(
            equalTo: containerView.bottomAnchor, constant: -10)
        bottomConstraint.isActive = true
        bottomConstraints.append(bottomConstraint)
    }

    private func setupSoilQualityBar(quality: Float, maxQuality: Float) -> ProgressBar {
        let titleLabel = createTitleLabel(title: "Soil Quality:")
        containerView.addSubview(titleLabel)

        let progressBar = ProgressBar(frame: .zero)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.setProgress(
            current: quality,
            max: maxQuality,
            label: ""
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

        return progressBar
    }

    private func setupGrowthBar(after previousBar: ProgressBar, current: Float, max: Float) -> ProgressBar {
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
            titleLabel.topAnchor.constraint(equalTo: previousBar.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            progressBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            progressBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 30)
        ])

        return progressBar
    }

    private func setupHealthBar(after previousBar: ProgressBar, health: Double) -> ProgressBar {
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
            titleLabel.topAnchor.constraint(equalTo: previousBar.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            progressBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            progressBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 30)
        ])

        return progressBar
    }

    private func setupYieldBar(after previousBar: ProgressBar, current: Float, max: Float) -> ProgressBar {
        let titleLabel = createTitleLabel(title: "Yield:")
        containerView.addSubview(titleLabel)

        let progressBar = ProgressBar(frame: .zero)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.setProgress(
            current: current,
            max: max,
            label: ""
        )
        containerView.addSubview(progressBar)
        self.yieldProgressBar = progressBar

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: previousBar.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            progressBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            progressBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 30)
        ])

        return progressBar
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
