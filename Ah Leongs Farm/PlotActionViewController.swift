import UIKit

class PlotActionViewController: UIViewController {
    private let plotNode: PlotSpriteNode
    private var actionButtons: [UIButton] = []

    init(plotNode: PlotSpriteNode) {
        self.plotNode = plotNode
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        setupActionButtons()
        addDismissTapGesture()
    }

    private func setupActionButtons() {
        let actions = [
            ("🌱 Add Crop", #selector(addCropTapped)),
            ("🌾 Harvest Crop", #selector(harvestCropTapped))
        ]

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        for (title, action) in actions {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            button.backgroundColor = .systemGreen
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 10
            button.addTarget(self, action: action, for: .touchUpInside)
            stackView.addArrangedSubview(button)
            actionButtons.append(button)
        }

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func addDismissTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func backgroundTapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !actionButtons.contains(where: { $0.frame.contains(location) }) {
            dismiss(animated: true)
        }
    }

    @objc private func addCropTapped() {
        print("🌱 Adding crop to plot")
        dismiss(animated: true)
    }

    @objc private func harvestCropTapped() {
        print("🌾 Harvesting crop from plot")
        dismiss(animated: true)
    }
}
