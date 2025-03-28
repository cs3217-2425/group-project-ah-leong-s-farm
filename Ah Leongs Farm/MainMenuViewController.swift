//
//  MainMenuViewController.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/3/25.
//

import UIKit
import SpriteKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction private func startPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "gameView", sender: self)
    }

    // Override prepare method to set full screen presentation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameView" {
            // Set the destination view controller to full screen
            segue.destination.modalPresentationStyle = .fullScreen
        }
    }
}
