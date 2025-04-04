//
//  QuestViewController.swift
//  Ah Leongs Farm
//
//  Created by Ma Yuchen on 3/4/25.
//

import UIKit

class QuestViewController: UIViewController {
    // MARK: - Properties
    private var allQuests: [QuestViewModel] = []
    private var firstActiveQuestIndex: Int = 0
    private var initialScrollSet = false // Track whether initial scroll has been set

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        collectionView.register(QuestCollectionViewCell.self, forCellWithReuseIdentifier: "QuestCollectionViewCell")

        return collectionView
    }()

    // MARK: - Initialization
    init(activeQuests: [QuestViewModel],
         completedQuests: [QuestViewModel],
         inactiveQuests: [QuestViewModel]) {

        self.allQuests = completedQuests + activeQuests + inactiveQuests
        // Find the index of the first active quest
        self.firstActiveQuestIndex = completedQuests.count

        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve

        // Set this to prevent view from appearing before we're ready
        definesPresentationContext = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the view until we're ready to show it in the correct scroll position
        containerView.alpha = 0
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        collectionView.layoutIfNeeded()

        // Set initial scroll position only once
        if !initialScrollSet && !allQuests.isEmpty && firstActiveQuestIndex < allQuests.count {
            scrollToQuestCentered(at: firstActiveQuestIndex, animated: false)
            initialScrollSet = true

            UIView.animate(withDuration: 0.2) {
                self.containerView.alpha = 1
            }
        }
    }

    // MARK: - UI Setup
    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        setupContainerView()
        setupHeaderView()
        setupCollectionView()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }

    private func setupContainerView() {
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
        ])
    }

    private func setupHeaderView() {
        let titleLabel = UILabel()
        titleLabel.text = "Quests"
        titleLabel.font = UIFont(name: "Press Start 2P", size: 18) ?? UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)

        let closeButton = UIButton(type: .system)
        closeButton.setTitle("X", for: .normal)
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(closeButton)

        let separatorLine = UIView()
        separatorLine.backgroundColor = .lightGray
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLine)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 50),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -50),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),

            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40),

            separatorLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            separatorLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            separatorLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            separatorLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func setupCollectionView() {
        containerView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 60),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }

    // MARK: - Helper Methods
    private func scrollToQuestCentered(at index: Int, animated: Bool) {
        guard index < allQuests.count, !allQuests.isEmpty,
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        let cellWidth = calculateCellWidth()
        let cellSpacing = layout.minimumLineSpacing

        let collectionViewWidth = collectionView.bounds.width
        let contentOffset = CGPoint(
            x: (cellWidth + cellSpacing) * CGFloat(index) - collectionView.contentInset.left,
            y: 0
        )

        let safeOffset = CGPoint(
            x: max(0, min(contentOffset.x, collectionView.contentSize.width - collectionViewWidth)),
            y: 0
        )

        collectionView.setContentOffset(safeOffset, animated: animated)
    }

    private func calculateCellWidth() -> CGFloat {
        // Calculate cell width to show 3 cells
        let availableWidth = collectionView.bounds.width -
                             collectionView.contentInset.left -
                             collectionView.contentInset.right
        let cellWidth = (availableWidth - 20) / 3
        return cellWidth
    }

    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func backgroundTapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: containerView)
        if !containerView.bounds.contains(location) {
            dismiss(animated: true)
        }
    }

    override var prefersStatusBarHidden: Bool { true }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension QuestViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allQuests.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestCollectionViewCell",
                                                            for: indexPath) as? QuestCollectionViewCell else {
            return UICollectionViewCell()
        }

        let quest = allQuests[indexPath.item]
        cell.configure(with: quest)

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension QuestViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = calculateCellWidth()
        return CGSize(width: width, height: collectionView.bounds.height - 20)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension QuestViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: view)
        return !containerView.frame.contains(location)
    }
}
