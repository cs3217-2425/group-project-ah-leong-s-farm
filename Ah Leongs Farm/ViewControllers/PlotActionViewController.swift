import UIKit
import SpriteKit

// TODO: Refactor this class as it's too bloated
class PlotActionViewController: UIViewController { // swiftlint:disable:this type_body_length
    private let plotViewModel: PlotViewModel
    private weak var spriteNode: SpriteNode?
    private weak var inventoryDataProvider: InventoryDataProvider?
    private weak var plotDataProvider: PlotDataProvider?
    private var actionButtons: [UIButton] = []
    private var collectionView: UICollectionView?
    private var growthProgressBar: ProgressBar?
    private var healthProgressBar: ProgressBar?
    private var soilQualityProgressBar: ProgressBar?

    private enum CollectionViewMode {
        case seeds, fertilisers
    }

    private func toggleCollectionView(mode: CollectionViewMode) {
        let shouldHide = !(collectionView?.isHidden ?? true) && collectionViewMode == mode
        collectionViewMode = mode
        collectionView?.isHidden = shouldHide

        if !shouldHide {
            collectionView?.reloadData()
        }
    }

    private var collectionViewMode: CollectionViewMode = .seeds

    private lazy var itemProviders: [CollectionViewMode: () -> [Any]] = [
        .seeds: { self.seedItems },
        .fertilisers: { self.fertiliserItems }
    ]

    private lazy var cellConfigurators: [CollectionViewMode: (InventoryItemCell, Int) -> Void] = [
        .seeds: { cell, index in
            cell.configure(with: self.seedItems[index].toInventoryItemViewModel())
        },
        .fertilisers: { cell, index in
            cell.configure(with: self.fertiliserItems[index].toInventoryItemViewModel())
        }
    ]

    private lazy var selectionHandlers: [CollectionViewMode: (Int) -> Void] = [
        .seeds: { [weak self] index in
            guard let self = self else {
                return
            }
            let selectedSeed = self.seedItems[index]
            self.plotDataProvider?.plantCrop(
                row: self.plotViewModel.row,
                column: self.plotViewModel.column,
                seedType: selectedSeed.type
            )
        },
        .fertilisers: { [weak self] index in
            guard let self = self else {
                return
            }
            let selectedFertiliser = self.fertiliserItems[index]
            self.plotDataProvider?.useFertiliser(
                row: self.plotViewModel.row,
                column: self.plotViewModel.column,
                fertiliserType: selectedFertiliser.type
            )
        }
    ]

    init(plotViewModel: PlotViewModel, spriteNode: SpriteNode,
         inventoryDataProvider: InventoryDataProvider, plotDataProvider: PlotDataProvider) {
        self.plotViewModel = plotViewModel
        self.spriteNode = spriteNode
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
        setupProgressBars()
    }

    private func setupProgressBars() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4)
        ])

        // ===== Soil Quality - Always show this =====
        let soilTitleLabel = UILabel()
        soilTitleLabel.text = "Soil Quality:"
        soilTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        soilTitleLabel.textColor = .white
        soilTitleLabel.textAlignment = .center
        soilTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(soilTitleLabel)

        let soilQualityProgressBar = ProgressBar(frame: .zero)
        soilQualityProgressBar.translatesAutoresizingMaskIntoConstraints = false
        soilQualityProgressBar.setProgress(
            current: CGFloat(plotViewModel.soilQuality),
            max: CGFloat(plotViewModel.maxSoilQuality),
            label: ""
        )
        containerView.addSubview(soilQualityProgressBar)
        self.soilQualityProgressBar = soilQualityProgressBar

        NSLayoutConstraint.activate([
            soilTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            soilTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            soilTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            soilQualityProgressBar.topAnchor.constraint(equalTo: soilTitleLabel.bottomAnchor, constant: 5),
            soilQualityProgressBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            soilQualityProgressBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            soilQualityProgressBar.heightAnchor.constraint(equalToConstant: 30)
        ])

        guard let crop = plotViewModel.crop else {
            // Add bottom constraint to the soil quality bar
            soilQualityProgressBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
            return
        }

        // ===== Growth Progress - Only show if crop exists =====
        let growthTitleLabel = UILabel()
        growthTitleLabel.text = "Growth Progress:"
        growthTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        growthTitleLabel.textColor = .white
        growthTitleLabel.textAlignment = .center
        growthTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(growthTitleLabel)

        let growthProgressBar = ProgressBar(frame: .zero)
        growthProgressBar.translatesAutoresizingMaskIntoConstraints = false
        growthProgressBar.setProgress(
            current: CGFloat(crop.currentGrowthTurn),
            max: CGFloat(crop.totalGrowthTurns),
            label: ""
        )
        containerView.addSubview(growthProgressBar)
        self.growthProgressBar = growthProgressBar

        // ===== Health Progress - Only show if crop exists =====
        let healthTitleLabel = UILabel()
        healthTitleLabel.text = "Health:"
        healthTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        healthTitleLabel.textColor = .white
        healthTitleLabel.textAlignment = .center
        healthTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(healthTitleLabel)

        let healthProgressBar = ProgressBar(frame: .zero)
        healthProgressBar.translatesAutoresizingMaskIntoConstraints = false
        healthProgressBar.setProgress(
            current: CGFloat(crop.currentHealth),
            max: 1.0,
            label: "",
            showText: false
        )
        containerView.addSubview(healthProgressBar)
        self.healthProgressBar = healthProgressBar

        NSLayoutConstraint.activate([
            growthTitleLabel.topAnchor.constraint(equalTo: soilQualityProgressBar.bottomAnchor, constant: 15),
            growthTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            growthTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            growthProgressBar.topAnchor.constraint(equalTo: growthTitleLabel.bottomAnchor, constant: 5),
            growthProgressBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            growthProgressBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            growthProgressBar.heightAnchor.constraint(equalToConstant: 30),

            healthTitleLabel.topAnchor.constraint(equalTo: growthProgressBar.bottomAnchor, constant: 15),
            healthTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            healthTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            healthProgressBar.topAnchor.constraint(equalTo: healthTitleLabel.bottomAnchor, constant: 5),
            healthProgressBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            healthProgressBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            healthProgressBar.heightAnchor.constraint(equalToConstant: 30),
            healthProgressBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }

    private func setupActionButtons() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        setupWaterButton(in: stackView)

        setupFertiliserButton(in: stackView)

        if let crop = plotViewModel.crop {
            setupHarvestCropButton(in: stackView)
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

    private func setupFertiliserButton(in stackView: UIStackView) {
        let button = UIButton(type: .system)
        button.setTitle("Use Fertiliser", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemOrange // Distinct color for fertiliser
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(useFertiliserTapped), for: .touchUpInside)
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

    private func setupWaterButton(in stackView: UIStackView) {
        let button = UIButton(type: .system)
        button.setTitle("Water Plot", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(waterPlotTapped), for: .touchUpInside)
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

    @objc private func waterPlotTapped() {
        guard let plotDataProvider = plotDataProvider else {
            return
        }

        plotDataProvider.waterPlot(row: plotViewModel.row, column: plotViewModel.column)
        runWaterAnimation()
    }

    @objc private func useFertiliserTapped() {
        toggleCollectionView(mode: .fertilisers)
    }

    @objc private func addCropTapped() {
        toggleCollectionView(mode: .seeds)
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

    private func runWaterAnimation() {
        guard let spriteNode = spriteNode else {
            return
        }

        let referenceSize = spriteNode.size

        let wateringCanSize = CGSize(width: referenceSize.width,
                                     height: referenceSize.height)
        let dropletsSize = CGSize(width: referenceSize.width,
                                  height: referenceSize.height)

        // Watering can
        let wateringCan = SKSpriteNode(imageNamed: "water_can")
        wateringCan.size = wateringCanSize
        wateringCan.position = CGPoint(x: referenceSize.width * 0.5, y: referenceSize.height * 1.25)
        wateringCan.zPosition = spriteNode.zPosition + 1
        wateringCan.alpha = 0
        spriteNode.addChild(wateringCan)

        // Droplets
        let droplets = SKSpriteNode(imageNamed: "water_droplets")
        droplets.size = dropletsSize
        droplets.position = .zero
        droplets.zPosition = wateringCan.zPosition - 1
        droplets.alpha = 0.8
        spriteNode.addChild(droplets)

        // Can animation
        let canSequence = SKAction.sequence([
            .fadeIn(withDuration: 0.2),
            .moveBy(x: 0, y: -referenceSize.height * 0.2, duration: 0.3),
            .wait(forDuration: 0.4),
            .moveBy(x: 0, y: referenceSize.height * 0.2, duration: 0.3),
            .fadeOut(withDuration: 0.2),
            .removeFromParent()
        ])
        wateringCan.run(canSequence)

        // Droplets animation
        let drip = SKAction.sequence([
            .wait(forDuration: 0.2 + 0.3), // match fadeIn + moveDown timing
            .fadeOut(withDuration: 0.5),
            .removeFromParent()
        ])
        droplets.run(drip)
    }
}

extension PlotActionViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    private var seedItems: [PlotDisplayItemViewModel] {
        inventoryDataProvider?.getSeedItemViewModels() ?? []
    }

    private var fertiliserItems: [PlotDisplayItemViewModel] {
        inventoryDataProvider?.getFertiliserItemViewModels() ?? []
    }

    // MARK: - UICollectionView DataSource & Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items = itemProviders[collectionViewMode]?() as? [Any]
        return items?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InventoryCell", for: indexPath)

        if let cell = cell as? InventoryItemCell {
            cellConfigurators[collectionViewMode]?(cell, indexPath.item)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectionHandlers[collectionViewMode]?(indexPath.item)
        dismiss(animated: true)
    }
}
