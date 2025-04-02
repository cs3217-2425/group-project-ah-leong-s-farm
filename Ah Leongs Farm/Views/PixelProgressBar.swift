//
//  PixelProgressBar.swift
//  Ah Leongs Farm
//
//  Created by Lester Ong on 2/4/25.
//

import UIKit

class PixelProgressBar: UIView {
    private let progressView = UIView()
    private var progress: CGFloat = 0

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
    }

    func setProgress(_ value: CGFloat) {
        let clampedValue = min(max(value, 0), 1)
        progress = clampedValue

        let newWidth = bounds.width * clampedValue
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.progressView.frame = CGRect(x: 0, y: 0, width: newWidth, height: self.bounds.height)
        }, completion: nil)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setProgress(progress)
    }
}
