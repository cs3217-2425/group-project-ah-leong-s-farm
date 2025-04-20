import AVFoundation

class SoundSystem: ISystem {
    unowned var manager: EntityManager?

    private var backgroundMusicPlayer: AVAudioPlayer?
    private var soundEffectPlayers: [String: AVAudioPlayer] = [:]
    private var isMuted: Bool = false

    required init(for manager: EntityManager) {
        self.manager = manager
        setupAudioSession()
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
        }
    }

    func playBackgroundMusic(named filename: String = "background", fileExtension: String = "wav") {
        guard !isMuted else {
            return
        }

        stopBackgroundMusic()

        guard let url = Bundle.main.url(forResource: filename, withExtension: fileExtension) else {
            return
        }

        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1
            backgroundMusicPlayer?.volume = 0.5
            backgroundMusicPlayer?.play()
        } catch {
        }
    }

    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer = nil
    }

    func prepareToPlay() {
        guard let url = Bundle.main.url(forResource: "add-plot", withExtension: "wav") else {
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
        } catch {
        }
    }

    func playSoundEffect(named filename: String, fileExtension: String = "wav") {
        guard !isMuted else {
            return
        }

        guard let url = Bundle.main.url(forResource: filename, withExtension: fileExtension) else {
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = 0.7
            player.play()

            soundEffectPlayers[filename] = player

            // Remove the player after it finishes
            DispatchQueue.main.asyncAfter(deadline: .now() + player.duration) { [weak self] in
                self?.soundEffectPlayers.removeValue(forKey: filename)
            }
        } catch {
        }
    }

    func stopAllSoundEffects() {
        soundEffectPlayers.values.forEach { $0.stop() }
        soundEffectPlayers.removeAll()
    }

    func setMuted(_ muted: Bool) {
        isMuted = muted
        if muted {
            stopBackgroundMusic()
            stopAllSoundEffects()
        }
    }

    func isSoundMuted() -> Bool {
        isMuted
    }
}
