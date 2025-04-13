import UIKit

class PlotActionViewController: UIViewController {
    private let plotViewModel: PlotViewModel
    private weak var inventoryDataProvider: InventoryDataProvider?
    private weak var plotDataProvider: PlotDataProvider?
    private var actionButtons: [UIButton] = []
    private var collectionView: UICollectionView?

    init(plotViewModel: PlotViewModel, inventoryDataProvider: InventoryDataProvider,
         plotDataProvider: PlotDataProvider) {
        self.plotViewModel = plotViewModel
        self.inventoryDataProvider = inventoryDataProvider
        self.plotDataProvider = plotDataProvider

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
        setupCollectionView()
        addDismissTapGesture()
    }

    private func setupActionButtons() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        if let crop = plotViewModel.crop {
            setupHarvestCropButton(in: stackView)

            // show remove crop button only when crop is not ready to be harvested
            if !crop.canHarvest {
                setupRemoveCropButton(in: stackView)
            }
        } else {
            setupAddCropButton(in: stackView)
        }

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupHarvestCropButton(in stackView: UIStackView) {
        let button = UIButton(type: .system)
        button.setTitle("Harvest Crop", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(harvestCropTapped), for: .touchUpInside)
        stackView.addArrangedSubview(button)
        actionButtons.append(button)

        if let crop = plotViewModel.crop, !crop.canHarvest {
            button.isEnabled = false
            button.backgroundColor = .systemGray
        }
    }

    private func setupAddCropButton(in stackView: UIStackView) {
        let button = UIButton(type: .system)
        button.setTitle("Add Crop", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(addCropTapped), for: .touchUpInside)
        stackView.addArrangedSubview(button)
        actionButtons.append(button)
    }

    private func setupRemoveCropButton(in stackView: UIStackView) {
        let button = UIButton(type: .system)
        button.setTitle("Remove Crop", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(removeCropTapped), for: .touchUpInside)
        stackView.addArrangedSubview(button)
        actionButtons.append(button)
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 80) // Adjust size as needed
        layout.minimumLineSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(InventoryItemCell.self, forCellWithReuseIdentifier: "InventoryCell")

        view.addSubview(collectionView)

        // Constraints (adjust position as needed)
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor
                .constraint(equalTo: actionButtons.first?.topAnchor ?? view.bottomAnchor, constant: -10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 100)
        ])

        collectionView.isHidden = true // Hide initially

        self.collectionView = collectionView
    }

    private func addDismissTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func backgroundTapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)

        if shouldDismiss(location: location) {
            dismiss(animated: true)
        }
    }

    @objc private func addCropTapped() {
        collectionView?.isHidden.toggle()
    }

    @objc private func harvestCropTapped() {
        plotDataProvider?.harvestCrop(row: plotViewModel.row, column: plotViewModel.column)
        dismiss(animated: true)
    }

    @objc private func removeCropTapped() {
        plotDataProvider?.removeCrop(row: plotViewModel.row, column: plotViewModel.column)
        dismiss(animated: true)
    }

    private func shouldDismiss(location: CGPoint) -> Bool {
        // Ignore taps on action buttons
        for button in actionButtons {
            let locationInButton = view.convert(location, to: button)
            if button.point(inside: locationInButton, with: nil) {
                return false
            }
        }

        guard let tappedView = view.hitTest(location, with: nil) else {
            return false
        }

        // Ignore taps on collection view
        if tappedView === collectionView {
            return false
        }

        // Ignore taps on collection view cells
        if let collectionView = collectionView, tappedView.isDescendant(of: collectionView) {
            return false
        }

        return true
    }
}

extension PlotActionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private var seedItems: [SeedItemViewModel] {
        inventoryDataProvider?.getSeedItemViewModels() ?? []
    }

    // MARK: - UICollectionView DataSource & Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        seedItems.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InventoryCell", for: indexPath)

        if let cell = cell as? InventoryItemCell {
            cell.configure(with: seedItems[indexPath.item].toInventoryItemViewModel())
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSeed = seedItems[indexPath.item]

        plotDataProvider?.plantCrop(
            row: plotViewModel.row,
            column: plotViewModel.column,
            seedType: selectedSeed.seedType
        )

        dismiss(animated: true)
    }
}
