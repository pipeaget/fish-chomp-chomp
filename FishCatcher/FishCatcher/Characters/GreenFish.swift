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
    let fishRotateRadiansPerSec: CGFloat = 4.0 * π
    var desiredPosition: CGPoint?
    
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
    
    func changePositionAndShow(in playableRect:CGRect){
        self.position = CGPoint(x: CGFloat.random(min: playableRect.minX, max: playableRect.maxX),
                                     y: CGFloat.random(min: playableRect.minY, max: playableRect.maxY))
        isHidden = false
        startFishAnimation()
        setScale(0)
        zRotation = 0
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
    
    private func randomPosition(at scene:SKScene) -> CGPoint {
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
            let actionDidMove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([moveAction,actionDidMove])
            self.run(sequence)
        }else if isOnRange{
            desiredPosition = randomPosition(at: scene)
            let duration = TimeInterval(CGFloat.random(min: 3, max: 4))
            let moveAction = SKAction.move(to: desiredPosition!, duration: duration)
            let actionDidMove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([moveAction,actionDidMove])
            self.run(sequence)
        }
        
    }
}
