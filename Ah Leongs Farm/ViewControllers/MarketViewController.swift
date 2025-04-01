import UIKit

class MarketViewController: UIViewController {

    private var gameManager: GameManager

    // Main view that contains header, segmented control, and collection view
    private let marketView: MarketView

    // Convenience accessors
    private var closeButton: UIButton { marketView.closeButton }
    private var currencyLabel: UILabel { marketView.currencyLabel }
    private var segmentedControl: UISegmentedControl { marketView.segmentedControl }
    private var collectionView: UICollectionView { marketView.collectionView }

    // Initializer
    init(gameManager: GameManager) {
        self.gameManager = gameManager
        self.marketView = MarketView(initialCurrency: Int(gameManager.getAmountOfCurrency(.coin)))
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Lifecycle
    override func loadView() {
        // Set the main view to be our custom view
        view = marketView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupCollectionView()
    }

    // Setup targets and actions
    private func setupActions() {
        closeButton.addTarget(self, action: #selector(closeMarket), for: .touchUpInside)
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
    }

    // Setup collection view data source, delegate, and register cells
    private func setupCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 20
            layout.minimumLineSpacing = 20
        }
        collectionView.register(BuyItemCell.self, forCellWithReuseIdentifier: "BuyItemCell")
        collectionView.register(SellItemCell.self, forCellWithReuseIdentifier: "SellItemCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    // MARK: - Actions

    @objc private func closeMarket() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func segmentedControlChanged() {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionView DataSource & Delegate

extension MarketViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return gameManager.getBuyItemViewModels().count
        } else {
            return gameManager.getSellItemViewModels().count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if segmentedControl.selectedSegmentIndex == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BuyItemCell", for: indexPath) as? BuyItemCell else {
                return UICollectionViewCell()
            }
            let viewModels = gameManager.getBuyItemViewModels()
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellItemCell", for: indexPath) as? SellItemCell else {
                return UICollectionViewCell()
            }
            let viewModels = gameManager.getSellItemViewModels()
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            let viewModels = gameManager.getBuyItemViewModels()
            let viewModel = viewModels[indexPath.row]
            print("Selected item for buy: \(viewModel.name)")
        } else {
            let viewModels = gameManager.getSellItemViewModels()
            let viewModel = viewModels[indexPath.row]
            print("Selected item for sell: \(viewModel.name)")
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 5
        let padding: CGFloat = 20
        let totalSpacing = (itemsPerRow - 1) * padding
        let availableWidth = collectionView.frame.width - totalSpacing
        let cellWidth = availableWidth / itemsPerRow

        print("Cell width: \(cellWidth), CollectionView width: \(collectionView.frame.width)")
        return CGSize(width: cellWidth, height: cellWidth) // Ensure square shape
    }

}
