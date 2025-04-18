import UIKit

class GridActionViewController: UIViewController {
    private let gridViewModel: GridViewModel
    private weak var gameRenderer: GameRenderer?
    private weak var gridDataProvider: GridDataProvider?
    private var actionButtons: [UIButton] = []

    init(gridViewModel: GridViewModel, renderer: GameRenderer, gridDataProvider: GridDataProvider) {
        self.gridViewModel = gridViewModel
        self.gameRenderer = renderer
        self.gridDataProvider = gridDataProvider
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
        setupSelectedPlotLabel()
        addDismissTapGesture()
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        gameRenderer?.unlightAllTiles()
    }

    private func setupActionButtons() {
        let doesPlotExist = gridViewModel.doesPlotExist

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        if doesPlotExist {
            let razeButton = UIButton(type: .system)
            razeButton.setTitle("Raze Plot", for: .normal)
            razeButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            razeButton.backgroundColor = .systemRed
            razeButton.setTitleColor(.white, for: .normal)
            razeButton.layer.cornerRadius = 10
            razeButton.addTarget(self, action: #selector(razePlotTapped), for: .touchUpInside)
            stackView.addArrangedSubview(razeButton)
            actionButtons.append(razeButton)
        } else {
            let addButton = UIButton(type: .system)
            addButton.setTitle("Add Plot", for: .normal)
            addButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            addButton.backgroundColor = .systemGreen
            addButton.setTitleColor(.white, for: .normal)
            addButton.layer.cornerRadius = 10
            addButton.addTarget(self, action: #selector(addPlotTapped), for: .touchUpInside)
            stackView.addArrangedSubview(addButton)
            actionButtons.append(addButton)
        }

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupSelectedPlotLabel() {
        let selectedPlotLabel = UILabel()
        selectedPlotLabel.text = "Selected: Row \(gridViewModel.row), Column \(gridViewModel.column)"
        selectedPlotLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        selectedPlotLabel.textAlignment = .center
        selectedPlotLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedPlotLabel.textColor = .white

        view.addSubview(selectedPlotLabel)

        NSLayoutConstraint.activate([
            selectedPlotLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            selectedPlotLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            selectedPlotLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
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

    @objc private func addPlotTapped() {
        gridDataProvider?.addPlot(row: gridViewModel.row, column: gridViewModel.column)
        dismiss(animated: true)
    }

    @objc private func razePlotTapped() {
        gridDataProvider?.razePlot(row: gridViewModel.row, column: gridViewModel.column)
        dismiss(animated: true)
    }
}
