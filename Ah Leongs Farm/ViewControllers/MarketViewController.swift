import UIKit
import GameplayKit

class MarketViewController: UIViewController {

    private var gameManager: GameManager

    private let marketView: MarketView

    private var closeButton: UIButton { marketView.closeButton }
    private var currencyLabel: UILabel { marketView.currencyLabel }
    private var segmentedControl: UISegmentedControl { marketView.segmentedControl }
    private var collectionView: UICollectionView { marketView.collectionView }

    init(gameManager: GameManager) {
        self.gameManager = gameManager
        self.marketView = MarketView(initialCurrency: Int(gameManager.getAmountOfCurrency(.coin)))
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = marketView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupCollectionView()
        gameManager.addGameObserver(self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        gameManager.removeGameObserver(self)
    }

    private func setupActions() {
        closeButton.addTarget(self, action: #selector(closeMarket), for: .touchUpInside)
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
    }

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
        if segmentedControl.selectedSegmentIndex == 0 {
            return gameManager.getBuyItemViewModels().count
        } else {
            return gameManager.getSellItemViewModels().count
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if segmentedControl.selectedSegmentIndex == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BuyItemCell",
                                                                for: indexPath) as? BuyItemCell else {
                return UICollectionViewCell()
            }
            let viewModels = gameManager.getBuyItemViewModels()
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel, currentCurrency: Int(gameManager.getAmountOfCurrency(.coin)))
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellItemCell",
                                                                for: indexPath) as? SellItemCell else {
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

            let popupVC = BuyItemPopupViewController(item: viewModel,
                                                     currentCurrency: Int(gameManager.getAmountOfCurrency(.coin)))
            popupVC.delegate = self
            present(popupVC, animated: true, completion: nil)
        } else {
            let viewModels = gameManager.getSellItemViewModels()
            let viewModel = viewModels[indexPath.row]
            let popupVC = SellItemPopupViewController(item: viewModel)
            popupVC.delegate = self
            present(popupVC, animated: true, completion: nil)

        }
    }
}

extension MarketViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 5
        let padding: CGFloat = 20
        let totalSpacing = (itemsPerRow - 1) * padding
        let availableWidth = collectionView.frame.width - totalSpacing
        let cellWidth = availableWidth / itemsPerRow

        return CGSize(width: cellWidth, height: cellWidth)
    }

    private func handlePurchase(of item: BuyItemViewModel, quantity: Int) {

    }
}

extension MarketViewController: BuyPopupDelegate {
    func didConfirmPurchase(item: ItemType, quantity: Int) {
        gameManager.buyItem(itemType: item, quantity: quantity)
        collectionView.reloadData()
        print("Confirm purchase: \(item), \(quantity)")
    }
}

extension MarketViewController: SellPopupDelegate {
    func didConfirmSale(item: ItemType, quantity: Int) {
        gameManager.sellItem(itemType: item, quantity: quantity)
        collectionView.reloadData()
        print("Confirm selling: \(item), \(quantity)")
    }
}

extension MarketViewController: IGameObserver {
    func observe(entities: Set<GKEntity>) {
        updateCurrencyLabel()
    }

    private func updateCurrencyLabel() {
        let coins = gameManager.getAmountOfCurrency(.coin)
        currencyLabel.text = "\(Int(coins))"
    }
}
