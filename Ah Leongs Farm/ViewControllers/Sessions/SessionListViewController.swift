//
//  SessionListViewController.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 15/4/25.
//

import UIKit

class SessionListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var sessions: [SessionData] = []
    private var collectionView: UICollectionView!

    private weak var loadSessionDelegate: LoadSessionDelegate?

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(loadSessionDelegate: LoadSessionDelegate) {
        self.loadSessionDelegate = loadSessionDelegate
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)

        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        cardView.layer.cornerRadius = 16
        view.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.widthAnchor.constraint(equalToConstant: 260),
            cardView.heightAnchor.constraint(equalToConstant: 360)
        ])

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        tapRecognizer.delegate = self
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 40)
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SessionViewCell.self, forCellWithReuseIdentifier: SessionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        cardView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20)
        ])

        fetchSessions()
    }

    private func fetchSessions() {
        guard let query = CoreDataSessionQuery() else {
            return
        }
        sessions = query.fetch()
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sessions.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SessionViewCell.reuseIdentifier, for: indexPath) as? SessionViewCell else {
            let newCell = SessionViewCell()
            newCell.configure(with: sessions[indexPath.item])
            return newCell
        }
        cell.configure(with: sessions[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sessionId = sessions[indexPath.item].id
        dismiss(animated: true, completion: nil)
        loadSessionDelegate?.loadSession(sessionId: sessionId)
    }

    @objc private func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
}

extension SessionListViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Don't dismiss if tap is inside collectionView
        !collectionView.frame.contains(touch.location(in: view))
    }
}
