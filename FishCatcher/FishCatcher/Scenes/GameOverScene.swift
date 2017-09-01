//
//  GameOverScene.swift
//  FishCatcher
//
//  Created by F J Castaneda Ramos on 7/31/17.
//  Copyright © 2017 VincoOrbis. All rights reserved.
//

import Foundation
import SpriteKit


class GameOverScene: SKScene{
    let lose:Bool
    lazy var btnReplay:AGSpriteButton = {
        let replay = #imageLiteral(resourceName: "replay").imageWithColor(color: UIColor.white)
        let texture = SKTexture(image: replay)
        let btn = AGSpriteButton(texture: texture, andSize: CGSize(width: 300, height: 300))
        return btn
    }()
    
    init(size:CGSize, lose:Bool) {
        self.lose = lose
        super.init(size:size)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.groupTableViewBackground
        let background = SKSpriteNode(imageNamed: "gameover_bg")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        addChild(background)
        btnReplay.setScale(0.4)
        btnReplay.position =  CGPoint(x: size.width/2, y: size.height/2  - 400)
        btnReplay.addTarget(self, selector: #selector(replayBtnPressed), with: nil, for: .touchUpInside)
        addChild(btnReplay)
    }
    
    func replayBtnPressed(){
        let mainScene = GameScene(size: size)
        mainScene.scaleMode = scaleMode
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(mainScene, transition: reveal)
    }
    
    
}
