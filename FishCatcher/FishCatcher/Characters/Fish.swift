//
//  Fish.swift
//  FishCatcher
//
//  Created by Javier Castañeda on 9/11/17.
//  Copyright © 2017 VincoOrbis. All rights reserved.
//

import SpriteKit

class Fish: SKSpriteNode {
    
    let fishMovePointsPerSec: CGFloat = 300
    let fishRotateRadiansPerSec:CGFloat = 4.0 * π
    var desiredPosition: CGPoint?
    var fishAnimation: SKAction?
    
    
    func createFishAnimationWithSprite(_ name:String) -> SKAction {
        var textures:[SKTexture] = []
        for i in 1...6{
            textures.append(SKTexture(imageNamed: name + "\(i)"))
        }
        textures.append(textures[4])
        textures.append(textures[3])
        textures.append(textures[2])
        return SKAction.animate(with: textures, timePerFrame: 0.1)
    }
    
    
    
    func startFishAnimation(){
        if self.action(forKey: "swim") == nil, let fishAnimation = fishAnimation{
            self.run(
                SKAction.repeatForever(fishAnimation),
                withKey: "swim")
        }
    }
    
    func endFishAnimation(){
        self.removeAction(forKey: "swim")
    }
    
    func changePositionAndShow(in playableRect:CGRect, at point:CGPoint, velocity:CGPoint, dt:TimeInterval){
        let offset = self.position - point
        let direction = offset.normalized()
        let fishvelocity = direction * 480 * 0.75
        move(dt: dt, velocity: fishvelocity)
    }
    
    func move(dt:TimeInterval, velocity: CGPoint) {
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt),
                                   y: velocity.y * CGFloat(dt))
        self.position -= amountToMove
    }
    
    func randomPosition(at scene:SKScene) -> CGPoint {
        let rect = scene.frame
        let x = CGFloat(arc4random()).truncatingRemainder(dividingBy: rect.size.width)
        let y = CGFloat(arc4random()).truncatingRemainder(dividingBy: rect.size.height)
        
        return CGPoint(x: x, y: y)
    }
    
    func move(on scene: SKScene){
        var actions: [SKAction] = []
        for _ in 0..<25{
            let destination = randomPosition(at: scene)
            let movement = SKAction.move(to: destination, duration: 1)
            actions.append(movement)
        }
        let sequence = SKAction.sequence(actions)
        let runForever = SKAction.repeatForever(sequence)
        run(runForever)
    }
}

