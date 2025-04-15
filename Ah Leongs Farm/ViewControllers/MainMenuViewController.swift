import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let titleLabel = UILabel()
        titleLabel.text = "Ah Leong's Farm"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Press Start 2P", size: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let startButton = UIButton(type: .system)
        startButton.setTitle("Start Game", for: .normal)
        startButton.backgroundColor = .systemBlue
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 10
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.titleLabel?.font = UIFont(name: "Press Start 2P", size: 12)

        view.addSubview(titleLabel)
        view.addSubview(startButton)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -20),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            startButton.widthAnchor.constraint(equalToConstant: 200),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)

        let loadButton = UIButton(type: .system)
        loadButton.setTitle("Load Session", for: .normal)
        loadButton.backgroundColor = .systemGreen
        loadButton.setTitleColor(.white, for: .normal)
        loadButton.layer.cornerRadius = 10
        loadButton.translatesAutoresizingMaskIntoConstraints = false
        loadButton.titleLabel?.font = UIFont(name: "Press Start 2P", size: 12)
        view.addSubview(loadButton)

        NSLayoutConstraint.activate([
            loadButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20),
            loadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadButton.widthAnchor.constraint(equalToConstant: 200),
            loadButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        loadButton.addTarget(self, action: #selector(loadButtonTapped), for: .touchUpInside)
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
