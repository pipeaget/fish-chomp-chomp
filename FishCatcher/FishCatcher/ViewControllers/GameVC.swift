//
//  GameVC.swift
//  FishCatcher
//
//  Created by F J Castaneda Ramos on 7/29/17.
//  Copyright © 2017 VincoOrbis. All rights reserved.
//

import UIKit
import SpriteKit

class GameVC: UIViewController {
    
    @IBOutlet weak var pvFishesToNextLife: UIProgressView?
    @IBOutlet weak var lblNumberOfLifes: UILabel?
    @IBOutlet weak var lblScore: UILabel?
    @IBOutlet weak var btnSound: UIButton?
    
    var scene: GameScene?
    var audioPlayer: AudioPlayer?
    lazy var logic = Logic()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        audioPlayer = AudioPlayer()
        createGameScene()
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
        audioPlayer?.playBackgroundMusic()
        setNumberOfLifes(logic.lifes)
        setNumberOfFishesToNextLife(logic.catchesToNextLife)
        setMyScore(logic.score)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameover = segue.destination as? GameOverVC {
            gameover.delegate = self
            gameover.points = logic.score
        }
    }
    
    fileprivate func setNumberOfLifes(_ lifes: Int) {
        let paw = #imageLiteral(resourceName: "paw").imageWithColor(color: .white)
        let attributedText = VOCoreText.textWithAttachment(text: "x\(logic.lifes)", font: UIFont.glimstick(size: 20), textColor: UIColor.white, attachment: paw, position: .left)
        lblNumberOfLifes?.attributedText = attributedText
    }
    fileprivate func setNumberOfFishesToNextLife(_ fishesToCatch:Int){
        let value = 1 - (Float(fishesToCatch)/10)
        pvFishesToNextLife?.progress = value
        if value == 0{
            setNumberOfLifes(logic.lifes)
        }
    }
    fileprivate func setMyScore(_ score:Int) {
         lblScore?.text = "\(score) pts."
    }
    
    fileprivate func createGameScene(){
        scene = GameScene(size:CGSize(width: 2048, height: 1536))
        scene?.logic = logic
        scene?.gameChagedDelegate = self
        scene?.scaleMode = .aspectFill

    }
    
    @IBAction func soundBtnPressed(_ sender: UIButton) {
        let image = sender.imageView?.image == #imageLiteral(resourceName: "unmute") ? #imageLiteral(resourceName: "mute") : #imageLiteral(resourceName: "unmute")
        sender.setImage(image, for: .normal)
        if audioPlayer?.isPlaying == true {
            audioPlayer?.stopBackgroundMusic()
        }else{
            audioPlayer?.playBackgroundMusic()
        }
    }
}

extension GameVC: GameChanged{
    
    func setScore(score: Int) {
       setMyScore(score)
    }

    func loseLife() {
        setNumberOfLifes(logic.lifes)
    }
    func getLife() {
        setNumberOfLifes(logic.lifes)
    }
    func fishCatch(_ fishesToCatch: Int) {
        setNumberOfFishesToNextLife(fishesToCatch)
    }
    
    func gameover() {
        audioPlayer?.stopBackgroundMusic()
        scene = nil
        self.performSegue(withIdentifier: "gameover", sender: self)
    }
}

extension GameVC: GameOverDelegate{
    func retryPressed() {
        audioPlayer?.playBackgroundMusic()
        logic.resetLogic()
        setNumberOfLifes(logic.lifes)
        setNumberOfFishesToNextLife(logic.catchesToNextLife)
        setMyScore(logic.score)
        btnSound?.setImage(#imageLiteral(resourceName: "unmute"), for: .normal)
        createGameScene()
        let skView = self.view as! SKView
        skView.presentScene(scene)
        dismiss(animated: true, completion: nil)
    }
}
