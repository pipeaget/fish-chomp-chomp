//
//  CatCharacter.swift
//  FishCatcher
//
//  Created by F J Castaneda Ramos on 7/29/17.
//  Copyright © 2017 VincoOrbis. All rights reserved.
//

import SpriteKit

class CatCharacter: SKSpriteNode {
    let catMovePointsPerSec: CGFloat = 480
    let catRotateRadiansPerSec:CGFloat = 4.0 * π
    var invincible = false
    var velocity = CGPoint.zero
    
    
    
    
    internal var catAnimation:SKAction {
        var textures:[SKTexture] = []
        for i in 1...6{
            textures.append(SKTexture(imageNamed: "cat\(i)"))
        }
        textures.append(textures[4])
        textures.append(textures[3])
        textures.append(textures[2])
        return SKAction.animate(with: textures, timePerFrame: 0.2)
    }
    
    override func removeFromParent() {
        endCatAnimation()
    }
    
    
    func startCatAnimation(){
        if self.action(forKey: "swim") == nil{
            self.run(
                SKAction.repeatForever(catAnimation),
                withKey: "swim")
        }
    }
    
    func endCatAnimation(){
        self.removeAction(forKey: "swim")
    }
    
    func move(dt:TimeInterval, velocity: CGPoint) {
        self.velocity = velocity
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt),
                                   y: velocity.y * CGFloat(dt))
        self.position += amountToMove
    }
    
    func rotate(dt:TimeInterval, direction: CGPoint) {
        let shortest = shortestAngleBetween(angle1: self.zRotation, angle2: velocity.angle)
        let amountToRotate = min(catRotateRadiansPerSec * CGFloat(dt), abs(shortest))
        self.zRotation += shortest.sign() * amountToRotate
    }
    
    func catHit(enemy:RedFish){
        invincible = true
        let blinkTimes:TimeInterval = 10
        let duration:TimeInterval = 3
        let blinkAction = SKAction.customAction(withDuration: duration) { node, elapsedTime in
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime).truncatingRemainder(
                dividingBy: slice)
            node.isHidden = remainder > slice / 2
        }
        let setHidden = SKAction.run() { [weak self] in
            self?.isHidden = false
            self?.invincible = false
        }
        self.run(SKAction.sequence([blinkAction, setHidden]))
    }
}
