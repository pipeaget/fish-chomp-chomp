//
//  BlueFish.swift
//  FishCatcher
//
//  Created by F J Castaneda Ramos on 7/29/17.
//  Copyright © 2017 VincoOrbis. All rights reserved.
//

import SpriteKit

class BlueFish:SKSpriteNode {
    let fishMovePointsPerSec: CGFloat = 300
    let fishRotateRadiansPerSec:CGFloat = 4.0 * π
    var velocity = CGPoint.zero
    
    internal var fishAnimation:SKAction {
        var textures:[SKTexture] = []
        for i in 1...6{
            textures.append(SKTexture(imageNamed: "blue_fish\(i)"))
        }
        textures.append(textures[4])
        textures.append(textures[3])
        textures.append(textures[2])
        return SKAction.animate(with: textures, timePerFrame: 0.1)
    }
    
    
    override func removeFromParent() {
        endFishAnimation()
    }
    
    
    func startFishAnimation(){
        if self.action(forKey: "swim") == nil{
            self.run(
                SKAction.repeatForever(fishAnimation),
                withKey: "swim")
        }
    }
    
    func endFishAnimation(){
        self.removeAction(forKey: "swim")
    }

    func changePositionAndShow(in playableRect:CGRect){
        self.position = CGPoint(x: CGFloat.random(min: playableRect.minX, max: playableRect.maxX),
                                y: CGFloat.random(min: playableRect.minY, max: playableRect.maxY))
        self.isHidden = false
        self.startFishAnimation()
        self.setScale(0)
        self.zRotation = 0
        let appear = SKAction.scale(to: 1.0, duration: 0.5)
        let leftWiggle = SKAction.rotate(byAngle: π/8, duration: 0.5)
        let rightWiggle = leftWiggle.reversed()
        let fullWiggle = SKAction.sequence([leftWiggle,rightWiggle])
        let scaleUp = SKAction.scale(by: 1.0, duration: 0.25)
        let scaleDown = scaleUp.reversed()
        let fullScale = SKAction.sequence([scaleUp,scaleDown,scaleUp,scaleDown])
        let group = SKAction.group([fullScale,fullWiggle])
        let groupWait = SKAction.repeatForever(group)
        let actions = [appear,groupWait]
        self.run(SKAction.sequence(actions))
        
    }
}
