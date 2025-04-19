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
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func playBackgroundMusic(named filename: String, fileExtension: String = "mp3") {
        guard !isMuted else {
            return
        }

        stopBackgroundMusic()

        guard let url = Bundle.main.url(forResource: filename, withExtension: fileExtension) else {
            print("Could not find background music file: \(filename)")
            return
        }
        
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1
            backgroundMusicPlayer?.volume = 0.5
            backgroundMusicPlayer?.play()
        } catch {
            print("Failed to play background music: \(error)")
        }
    }
    
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer = nil
    }
    
    func playSoundEffect(named filename: String, fileExtension: String = "mp3") {
        guard !isMuted else {
            return
        }

        guard let url = Bundle.main.url(forResource: filename, withExtension: fileExtension) else {
            print("Could not find sound effect file: \(filename)")
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
            print("Failed to play sound effect: \(error)")
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
        return isMuted
    }
} 
