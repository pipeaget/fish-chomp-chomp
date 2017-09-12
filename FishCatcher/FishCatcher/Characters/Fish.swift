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
        return CGPoint(x: CGFloat.random(min: 0, max: scene.size.width),
                       y: CGFloat.random(min: 0, max: scene.size.height))
    }
    
    func move(on scene: SKScene){
        if desiredPosition == nil{
            desiredPosition = randomPosition(at: scene)
        }
        var maxRangePos = desiredPosition!
        maxRangePos.x += 100
        maxRangePos.y += 100
        var minRangePos = desiredPosition!
        minRangePos.x -= 100
        minRangePos.y -= 100
        let rangeX = Range(uncheckedBounds: (lower: minRangePos.x, upper: maxRangePos.x))
        let rangeY = Range(uncheckedBounds: (lower: minRangePos.y, upper: maxRangePos.y))
        let isOnRange = rangeX.contains(position.x) && rangeY.contains(position.y)
        if !isOnRange, let point = desiredPosition{
            let duration = TimeInterval(CGFloat.random(min: 3, max: 4))
            let moveAction = SKAction.move(to: point, duration: duration)
            let sequence = SKAction.sequence([moveAction])
            self.run(sequence)
        }else if isOnRange{
            desiredPosition = randomPosition(at: scene)
            let duration = TimeInterval(CGFloat.random(min: 3, max: 4))
            let moveAction = SKAction.move(to: desiredPosition!, duration: duration)
            let sequence = SKAction.sequence([moveAction])
            self.run(sequence)
        }
    }
}

