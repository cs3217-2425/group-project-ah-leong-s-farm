import UIKit

class PlotActionViewController: UIViewController {
    private weak var eventQueue: EventQueueable?
    private weak var plot: Plot?
    private weak var inventoryDataProvider: InventoryDataProvider?
    private var actionButtons: [UIButton] = []
    private var collectionView: UICollectionView?

    init(plotNode: PlotSpriteNode, eventQueue: EventQueueable, provider: InventoryDataProvider) {
        self.plot = plotNode.plot
        self.eventQueue = eventQueue
        self.inventoryDataProvider = provider

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
        print("🌾 Harvesting crop from plot")
        dismiss(animated: true)
    }

    private func shouldDismiss(location: CGPoint) -> Bool {
        guard let tappedView = view.hitTest(location, with: nil) else {
            return false
        }

        // Ignore taps on action buttons
        if actionButtons.contains(where: { $0 === tappedView }) {
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

        handleSeedPlanting(for: selectedSeed)

        dismiss(animated: true)
    }

    private func handleSeedPlanting(for seed: SeedItemViewModel) {
        guard let plot = plot else {
            return
        }

        let event = PlantCropEvent(cropType: seed.cropType, plot: plot)
        eventQueue?.queueEvent(event)
    }
}
