import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let titleLabel = UILabel()
        titleLabel.text = "Ah Leong's Farm"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Press Start 2P", size: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let newGameButton = UIButton(type: .system)
        newGameButton.setTitle("New Game", for: .normal)
        newGameButton.backgroundColor = .systemGreen
        newGameButton.setTitleColor(.white, for: .normal)
        newGameButton.layer.cornerRadius = 10
        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        newGameButton.titleLabel?.font = UIFont(name: "Press Start 2P", size: 12)

        view.addSubview(titleLabel)
        view.addSubview(newGameButton)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: newGameButton.topAnchor, constant: -20),
            newGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newGameButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            newGameButton.widthAnchor.constraint(equalToConstant: 200),
            newGameButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        newGameButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)

        let loadGameButton = UIButton(type: .system)
        loadGameButton.setTitle("Load Game", for: .normal)
        loadGameButton.backgroundColor = .systemBlue
        loadGameButton.setTitleColor(.white, for: .normal)
        loadGameButton.layer.cornerRadius = 10
        loadGameButton.translatesAutoresizingMaskIntoConstraints = false
        loadGameButton.titleLabel?.font = UIFont(name: "Press Start 2P", size: 12)
        view.addSubview(loadGameButton)

        NSLayoutConstraint.activate([
            loadGameButton.topAnchor.constraint(equalTo: newGameButton.bottomAnchor, constant: 20),
            loadGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadGameButton.widthAnchor.constraint(equalToConstant: 200),
            loadGameButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        loadGameButton.addTarget(self, action: #selector(loadButtonTapped), for: .touchUpInside)
    }

    @objc func startButtonTapped() {
        let gameViewController = ViewController()
        present(gameViewController, animated: true)
    }

    @objc func loadButtonTapped() {
        let sessionVC = SessionListViewController(loadSessionDelegate: self)
        sessionVC.modalPresentationStyle = .overFullScreen
        present(sessionVC, animated: true)
    }

    override var prefersStatusBarHidden: Bool {
        true
    }
}

extension MainMenuViewController: LoadSessionDelegate {
    func loadSession(sessionId: UUID) {
        let gameViewController = ViewController(sessionId: sessionId)
        present(gameViewController, animated: true)
    }
}
