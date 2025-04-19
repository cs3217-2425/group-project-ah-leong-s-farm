import UIKit
import SpriteKit

class PlotActionViewController: UIViewController {
    // MARK: - Properties
    private let plotViewModel: PlotViewModel
    private weak var inventoryDataProvider: InventoryDataProvider?
    private weak var plotDataProvider: PlotDataProvider?

    // Component managers
    private var itemSelectionManager: ItemSelectionManager?
    private var progressBarManager: ProgressBarManager?
    private var actionButtonManager: ActionButtonManager?
    private var animationManager: AnimationManager?

    // MARK: - Initialization
    init(plotViewModel: PlotViewModel,
         spriteNode: SpriteNode,
         inventoryDataProvider: InventoryDataProvider,
         plotDataProvider: PlotDataProvider) {

        self.plotViewModel = plotViewModel
        self.inventoryDataProvider = inventoryDataProvider
        self.plotDataProvider = plotDataProvider

        super.init(nibName: nil, bundle: nil)

        // Initialize animation manager with sprite node
        self.animationManager = AnimationManager(spriteNode: spriteNode)

        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)

        setupComponents()
        addDismissTapGesture()
    }

    // MARK: - Setup Methods
    private func setupComponents() {
        // Create progress bar container
        let progressContainer = createProgressBarContainer()
        progressBarManager = ProgressBarManager(containerView: progressContainer)
        progressBarManager?.setupProgressBars(for: plotViewModel)

        actionButtonManager = ActionButtonManager(in: view, delegate: self)
        actionButtonManager?.setupButtons(for: plotViewModel)

        let collectionView = createCollectionView()
        itemSelectionManager = ItemSelectionManager(
            collectionView: collectionView,
            seedItems: inventoryDataProvider?.getSeedItemViewModels() ?? [],
            fertiliserItems: inventoryDataProvider?.getFertiliserItemViewModels() ?? [],
            onSeedSelected: { [weak self] seedType in
                guard let self = self else {
                    return
                }
                self.plotDataProvider?.plantCrop(
                    row: self.plotViewModel.row,
                    column: self.plotViewModel.column,
                    seedType: seedType
                )
                self.dismiss(animated: true)
            },
            onFertiliserSelected: { [weak self] fertiliserType in
                guard let self = self else {
                    return
                }
                self.plotDataProvider?.useFertiliser(
                    row: self.plotViewModel.row,
                    column: self.plotViewModel.column,
                    fertiliserType: fertiliserType
                )
                self.dismiss(animated: true)
            }
        )
    }

    private func createProgressBarContainer() -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        return containerView
    }

    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumLineSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        // Position collection view above action buttons
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 100)
        ])

        return collectionView
    }

    private func addDismissTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    // MARK: - Action Handlers
    @objc private func backgroundTapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)

        if shouldDismiss(at: location) {
            dismiss(animated: true)
        }
    }

    private func shouldDismiss(at location: CGPoint) -> Bool {
        // Check if tap is on any action button
        for button in actionButtonManager?.buttons ?? [] {
            let locationInButton = view.convert(location, to: button)
            if button.point(inside: locationInButton, with: nil) {
                return false
            }
        }

        // Check if tap is on collection view
        if let collectionView = itemSelectionManager?.collectionView,
           !collectionView.isHidden {

            let locationInCollectionView = view.convert(location, to: collectionView)
            if collectionView.bounds.contains(locationInCollectionView) {
                return false
            }

            // Also check if tap is on any collection view cell
            for cell in collectionView.visibleCells {
                let locationInCell = view.convert(location, to: cell)
                if cell.bounds.contains(locationInCell) {
                    return false
                }
            }
        }

        return true
    }
}

// MARK: - ActionButtonDelegate
extension PlotActionViewController: ActionButtonDelegate {
    func didTapWaterButton() {
        plotDataProvider?.waterPlot(row: plotViewModel.row, column: plotViewModel.column)
        animationManager?.runWaterAnimation()
    }

    func didTapFertiliserButton() {
        itemSelectionManager?.toggleMode(.fertilisers)
    }

    func didTapAddCropButton() {
        itemSelectionManager?.toggleMode(.seeds)
    }

    func didTapHarvestCropButton() {
        plotDataProvider?.harvestCrop(row: plotViewModel.row, column: plotViewModel.column)
        dismiss(animated: true)
    }

    func didTapRemoveCropButton() {
        plotDataProvider?.removeCrop(row: plotViewModel.row, column: plotViewModel.column)
        dismiss(animated: true)
    }
}
