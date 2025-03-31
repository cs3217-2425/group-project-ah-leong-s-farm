import UIKit

class MarketViewController: UIViewController {

    // Data Models
    let itemsForSale = [
        MarketItem(image: UIImage(named: "bokchoy")!, price: 50, stock: 10),
        MarketItem(image: UIImage(named: "bokchoy")!, price: 100, stock: 5),
        MarketItem(image: UIImage(named: "bokchoy")!, price: 150, stock: 3)
    ]

    let itemsForSell = [
        MarketItem(image: UIImage(named: "bokchoy")!, price: 30, stock: 7),
        MarketItem(image: UIImage(named: "bokchoy")!, price: 60, stock: 8),
        MarketItem(image: UIImage(named: "bokchoy")!, price: 90, stock: 4)
    ]

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

extension MarketViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        segmentedControl.selectedSegmentIndex == 0 ? itemsForSale.count : itemsForSell.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if segmentedControl.selectedSegmentIndex == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BuyItemCell", for: indexPath) as? BuyItemCell else {
                return UICollectionViewCell()
            }
            let item = itemsForSale[indexPath.row]
            cell.configure(with: item)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellItemCell", for: indexPath) as? SellItemCell else {
                return UICollectionViewCell()
            }
            let item = itemsForSell[indexPath.row]
            cell.configure(with: item)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            let item = itemsForSale[indexPath.row]
            print("Selected item for buy: \(item)")
        } else {
            let item = itemsForSell[indexPath.row]
            print("Selected item for sell: \(item)")
        }
    }
}

// MARK: - MarketItem Model -> i think later can change this to a view model or sth idk
struct MarketItem {
    let image: UIImage
    let price: Double
    let stock: Int
}

extension GameManager {
    static let marketItems: [MarketItem] = []
    
    
    
}
