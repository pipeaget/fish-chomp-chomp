//
//  GreenFish.swift
//  FishCatcher
//
//  Created by F J Castaneda Ramos on 7/29/17.
//  Copyright © 2017 VincoOrbis. All rights reserved.
//

import SpriteKit

class GreenFish: SKSpriteNode {
    let fishMovePointsPerSec: CGFloat = 300
    let fishRotateRadiansPerSec:CGFloat = 4.0 * π
    var velocity = CGPoint.zero
    
    internal var fishAnimation:SKAction {
        var textures:[SKTexture] = []
        for i in 1...6{
            textures.append(SKTexture(imageNamed: "green_fish\(i)"))
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
}
