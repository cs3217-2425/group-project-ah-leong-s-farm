//
//  ProgressBar.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 2/4/25.
//

import UIKit

class ProgressBar: UIView {
    private let progressView = UIView()
    private let progressLabel = UILabel()
    private var currentProgress: CGFloat = 0
    private var maxProgress: CGFloat = 1
    private var label: String = ""
    private var shouldShowText: Bool = true
    private var formatter: ProgressFormatter = IntegerProgressFormatter()

    private protocol ProgressFormatter {
        func format(_ value: CGFloat) -> String
    }

    private struct IntegerProgressFormatter: ProgressFormatter {
        func format(_ value: CGFloat) -> String {
            "\(Int(value))"
        }
    }

    private struct FloatProgressFormatter: ProgressFormatter {
        func format(_ value: CGFloat) -> String {
            String(format: "%.2f", value)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        layer.borderWidth = 4
        layer.borderColor = UIColor.black.cgColor
        backgroundColor = UIColor.darkGray

        progressView.backgroundColor = UIColor.systemGreen
        progressView.layer.borderWidth = 2
        progressView.layer.borderColor = UIColor.black.cgColor
        addSubview(progressView)

        progressLabel.textColor = .white
        progressLabel.font = UIFont(name: "Press Start 2P", size: 12)
        progressLabel.textAlignment = .center
        addSubview(progressLabel)
    }

    // Method for integer types (Int, Int32, etc.)
    func setProgress<T: BinaryInteger>(current: T, max: T, label: String, showText: Bool = true) {
        formatter = IntegerProgressFormatter()
        let currentCG = CGFloat(Int(current))
        let maxCG = CGFloat(Int(max))
        setProgressInternal(currentProgress: currentCG, maxProgress: maxCG, label: label, showText: showText)
    }

    // Method for floating point types (Float, Double, CGFloat)
    func setProgress<T: BinaryFloatingPoint>(current: T, max: T, label: String, showText: Bool = true) {
        formatter = FloatProgressFormatter()
        let currentCG = CGFloat(Double(current))
        let maxCG = CGFloat(Double(max))
        setProgressInternal(currentProgress: currentCG, maxProgress: maxCG, label: label, showText: showText)
    }

    // Internal implementation shared by all public methods
    private func setProgressInternal(currentProgress: CGFloat, maxProgress: CGFloat, label: String, showText: Bool) {
        guard maxProgress > 0 else {
            return
        }

        self.currentProgress = currentProgress
        self.maxProgress = maxProgress
        self.label = label
        self.shouldShowText = showText

        let value = self.currentProgress / self.maxProgress
        let clampedValue = min(max(value, 0), 1)
        let newWidth = bounds.width * clampedValue

        if showText {
            let currentFormatted = formatter.format(currentProgress)
            let maxFormatted = formatter.format(maxProgress)

            if label.isEmpty {
                progressLabel.text = "\(currentFormatted)/\(maxFormatted)"
            } else {
                progressLabel.text = "\(currentFormatted)/\(maxFormatted) \(label)"
            }
            progressLabel.isHidden = false
        } else {
            progressLabel.text = ""
            progressLabel.isHidden = true
        }

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.progressView.frame = CGRect(x: 0, y: 0, width: newWidth, height: self.bounds.height)
        }, completion: nil)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setProgressInternal(
            currentProgress: currentProgress,
            maxProgress: maxProgress,
            label: label,
            showText: shouldShowText
        )
        progressLabel.frame = bounds
    }
}
