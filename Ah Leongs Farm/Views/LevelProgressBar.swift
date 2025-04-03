//
//  LevelProgressBar.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 2/4/25.
//

import UIKit

class LevelProgressBar: UIView {
    private let progressView = UIView()
    private let progressLabel = UILabel()
    private var currentProgress: CGFloat = 0
    private var maxProgress: CGFloat = 1

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

    func setProgress(currentProgress: CGFloat, maxProgress: CGFloat) {
        guard maxProgress > 0 else {
            return
        }

        self.currentProgress = currentProgress
        self.maxProgress = maxProgress
        let value = self.currentProgress / self.maxProgress
        let clampedValue = min(max(value, 0), 1)

        let newWidth = bounds.width * clampedValue
        progressLabel.text = "\(currentProgress)/\(maxProgress) XP"

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.progressView.frame = CGRect(x: 0, y: 0, width: newWidth, height: self.bounds.height)
        }, completion: nil)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setProgress(currentProgress: currentProgress, maxProgress: maxProgress)
        progressLabel.frame = bounds
    }
}
