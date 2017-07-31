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
        let btn = AGSpriteButton(imageNamed: "replay")
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
//        let background = SKSpriteNode(imageNamed: "you_lose")
//        background.position = CGPoint(x: size.width/2, y: size.height/2)
//        addChild(background)
        btnReplay.position =  CGPoint(x: size.width/2, y: size.height/2  + 60)
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
