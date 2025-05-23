//
//  ItemSelectionManager.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 17/4/25.
//

import UIKit

/// Manages the collection view for selecting inventory items
class ItemSelectionManager: NSObject {

    enum SelectionMode {
        case seeds, fertilisers, solarPanels
    }

    // MARK: - Properties
    let collectionView: UICollectionView
    private let seedItems: [PlotDisplayItemViewModel]
    private let fertiliserItems: [PlotDisplayItemViewModel]
    private let solarPanelItems: [PlotDisplayItemViewModel]
    private var currentMode: SelectionMode = .seeds
    private var onSeedSelected: ((EntityType) -> Void)?
    private var onFertiliserSelected: ((EntityType) -> Void)?
    private var onSolarPanelSelected: ((EntityType) -> Void)?

    private lazy var itemProviders: [SelectionMode: () -> [PlotDisplayItemViewModel]] = [
        .seeds: { self.seedItems },
        .fertilisers: { self.fertiliserItems },
        .solarPanels: { self.solarPanelItems }
    ]

    private lazy var selectionHandlers: [SelectionMode: (Int) -> Void] = [
        .seeds: { [weak self] index in
            guard let self = self, index < self.seedItems.count else {
                return
            }
            self.onSeedSelected?(self.seedItems[index].type)
        },
        .fertilisers: { [weak self] index in
            guard let self = self, index < self.fertiliserItems.count else {
                return
            }
            self.onFertiliserSelected?(self.fertiliserItems[index].type)
        },
        .solarPanels: { [weak self] index in
            guard let self = self, index < self.solarPanelItems.count else {
                return
            }
            self.onSolarPanelSelected?(self.solarPanelItems[index].type)
        }
    ]

    // MARK: - Initialization
    init(collectionView: UICollectionView,
         seedItems: [PlotDisplayItemViewModel],
         fertiliserItems: [PlotDisplayItemViewModel],
         solarPanelItems: [PlotDisplayItemViewModel],
         onSeedSelected: @escaping (EntityType) -> Void,
         onFertiliserSelected: @escaping (EntityType) -> Void,
         onSolarPanelSelected: @escaping (EntityType) -> Void) {

        self.collectionView = collectionView
        self.seedItems = seedItems
        self.fertiliserItems = fertiliserItems
        self.solarPanelItems = solarPanelItems
        self.onSeedSelected = onSeedSelected
        self.onFertiliserSelected = onFertiliserSelected
        self.onSolarPanelSelected = onSolarPanelSelected
        super.init()

        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(InventoryItemCell.self, forCellWithReuseIdentifier: "InventoryCell")
        collectionView.isHidden = true
    }

    // MARK: - Public Methods
    func toggleMode(_ mode: SelectionMode) {
        let shouldHide = !collectionView.isHidden && currentMode == mode
        currentMode = mode
        collectionView.isHidden = shouldHide

        if !shouldHide {
            collectionView.reloadData()
        }
    }

    // MARK: - Helper Methods
    private func getCurrentItems() -> [PlotDisplayItemViewModel] {
        itemProviders[currentMode]?() ?? []
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ItemSelectionManager: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        getCurrentItems().count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "InventoryCell",
            for: indexPath) as? InventoryItemCell else {
            return UICollectionViewCell()
        }

        let items = getCurrentItems()
        if indexPath.item < items.count {
            cell.configure(with: items[indexPath.item].toInventoryItemViewModel())
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectionHandlers[currentMode]?(indexPath.item)
    }
}
