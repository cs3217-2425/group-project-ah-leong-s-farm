import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupUI()
    }

    private func setupBackground() {
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(imageLiteralResourceName: "background")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Ah Leong's Farm"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Press Start 2P", size: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let newGameButton = createButton(title: "New Game", color: .systemGreen, action: #selector(startButtonTapped))
        let loadGameButton = createButton(title: "Load Game", color: .systemBlue, action: #selector(loadButtonTapped))

        view.addSubview(titleLabel)
        view.addSubview(newGameButton)
        view.addSubview(loadGameButton)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: newGameButton.topAnchor, constant: -20),

            newGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newGameButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            newGameButton.widthAnchor.constraint(equalToConstant: 200),
            newGameButton.heightAnchor.constraint(equalToConstant: 50),

            loadGameButton.topAnchor.constraint(equalTo: newGameButton.bottomAnchor, constant: 20),
            loadGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadGameButton.widthAnchor.constraint(equalToConstant: 200),
            loadGameButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func createButton(title: String, color: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "Press Start 2P", size: 12)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
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
