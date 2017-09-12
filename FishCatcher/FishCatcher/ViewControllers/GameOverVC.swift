//
//  GameOverVC.swift
//  FishCatcher
//
//  Created by Javier Castañeda on 9/12/17.
//  Copyright © 2017 VincoOrbis. All rights reserved.
//

import UIKit

class GameOverVC: UIViewController {

    var delegate: GameOverDelegate?
    var points: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func retryPressed(_ sender: UIButton) {
        delegate?.retryPressed()
    }
    
    @IBAction func sharePuntuationPressed(_ sender:UIButton){
        guard let points = points else {
            return
        }
        let stringToShare = String(format: "¡Gané \(points) puntos en Fish chomp chomp!")
        let excludedActivities:[UIActivityType] = [.airDrop,.print,.assignToContact,.saveToCameraRoll,.addToReadingList,.postToFlickr,.postToVimeo]
        let activityController = UIActivityViewController(activityItems: [stringToShare], applicationActivities: nil)
        activityController.excludedActivityTypes = excludedActivities
        self.present(activityController, animated: true, completion: nil)
    }
}
