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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Scroll to center the first active quest if available
        if !allQuests.isEmpty && firstActiveQuestIndex < allQuests.count {
            scrollToQuestCentered(at: firstActiveQuestIndex, animated: false)
        }
    }

    // MARK: - UI Setup
    private func setupView() {
        // Semi-transparent background
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        setupContainerView()
        setupHeaderView()
        setupCollectionView()

        // Add tap gesture to dismiss
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
        // Title label
        let titleLabel = UILabel()
        titleLabel.text = "Quests"
        titleLabel.font = UIFont(name: "Press Start 2P", size: 18) ?? UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)

        // Close button
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("X", for: .normal)
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(closeButton)

        // Separator line
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

        // Calculate position that will center the target cell
        let collectionViewWidth = collectionView.bounds.width
        let contentOffset = CGPoint(
            x: (cellWidth + cellSpacing) * CGFloat(index) - (collectionViewWidth - cellWidth) / 2,
            y: 0
        )

        // Ensure offset is within content bounds
        let safeOffset = CGPoint(
            x: max(0, min(contentOffset.x, collectionView.contentSize.width - collectionViewWidth)),
            y: 0
        )

        collectionView.setContentOffset(safeOffset, animated: animated)
    }

    private func calculateCellWidth() -> CGFloat {
        // Calculate cell width to show 3 cells
        let availableWidth = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right
        let cellWidth = (availableWidth - 20) / 3 // 3 cells with spacing
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

    // Hide status bar
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
        // Don't dismiss if touch is inside the container
        let location = touch.location(in: view)
        return !containerView.frame.contains(location)
    }
}

// MARK: - QuestCollectionViewCell
class QuestCollectionViewCell: UICollectionViewCell {
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private let titleLabel = UILabel()
    private let statusBadge = UILabel()
    private var objectiveViews: [ObjectiveView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .clear

        // Add a card-like background
        let cardView = UIView()
        cardView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
        cardView.layer.cornerRadius = 12
        cardView.layer.borderWidth = 2
        cardView.layer.borderColor = UIColor.darkGray.cgColor
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        // Setup scroll view for vertical scrolling of objectives
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        cardView.addSubview(scrollView)

        // Status badge
        statusBadge.font = UIFont.boldSystemFont(ofSize: 12)
        statusBadge.textColor = .white
        statusBadge.layer.cornerRadius = 8
        statusBadge.clipsToBounds = true
        statusBadge.textAlignment = .center
        statusBadge.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(statusBadge)

        // Title label setup
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(titleLabel)

        // Content stack view for objectives
        contentStackView.axis = .vertical
        contentStackView.spacing = 10
        contentStackView.distribution = .fillProportionally
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            statusBadge.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            statusBadge.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            statusBadge.widthAnchor.constraint(equalToConstant: 70),
            statusBadge.heightAnchor.constraint(equalToConstant: 20),

            scrollView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            scrollView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8),

            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24), // Below status badge
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8),

            contentStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -12),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -16)
        ])
    }

    func configure(with quest: QuestViewModel) {
        titleLabel.text = quest.title
        let statusToUI: [QuestStatus: (text: String, color: UIColor)] = [
            .active: (text: "Active", color: UIColor.systemBlue),
            .inactive: (text: "Inactive", color: UIColor.lightGray),
            .completed: (text: "Completed", color: UIColor.systemGreen)
        ]
        statusBadge.text = statusToUI[quest.status]?.text
        statusBadge.backgroundColor = statusToUI[quest.status]?.color

        // Clear existing objective views
        objectiveViews.forEach { $0.removeFromSuperview() }
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        objectiveViews.removeAll()

        // Add objectives
        for objective in quest.objectives {
            let objectiveView = ObjectiveView()
            objectiveView.configure(with: objective)
            contentStackView.addArrangedSubview(objectiveView)
            objectiveViews.append(objectiveView)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        statusBadge.text = nil
        objectiveViews.forEach { $0.removeFromSuperview() }
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        objectiveViews.removeAll()
    }
}

// MARK: - ObjectiveView for displaying quest objectives with progress
class ObjectiveView: UIView {
    private let descriptionLabel = UILabel()
    private let progressBar = ProgressBar()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        // Description label
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionLabel)

        // Progress bar
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressBar)

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            progressBar.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 24),
            progressBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }

    func configure(with objective: QuestObjectiveViewModel) {
        descriptionLabel.text = objective.description

        // Calculate current and max progress values
        let currentProgress = CGFloat(objective.progress)
        let maxProgress = CGFloat(objective.target)

        progressBar.setProgress(currentProgress: currentProgress,
                                maxProgress: maxProgress,
                                label: "")
    }
}
