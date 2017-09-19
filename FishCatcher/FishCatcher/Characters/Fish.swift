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
    
    
    func randomPosition(at scene:SKScene) -> CGPoint {
        let rect = scene.frame
        let x = CGFloat(arc4random()).truncatingRemainder(dividingBy: rect.size.width)
        let y = CGFloat(arc4random()).truncatingRemainder(dividingBy: rect.size.height)
        
        return CGPoint(x: x, y: y)
    }
    
    func move(on scene: SKScene){
        var actions: [SKAction] = []
        for _ in 0 ..< 50{
            let destination = randomPosition(at: scene)
            let action = SKAction.customAction(withDuration: 0.1, actionBlock: { (node, _) in
                let dx = destination.x - node.position.x
                node.xScale = (dx < 0) ? 1 : -1
            })
            let movement = SKAction.move(to: destination, duration: 1.5)
            let moves = SKAction.sequence([action,movement])
            actions.append(moves)
        }
        let sequence = SKAction.sequence(actions)
        let runForever = SKAction.repeatForever(sequence)
        run(runForever)
    }
}

extension SKNode {
    func rotateVersus(destPoint: CGPoint) {
        let v1 = CGVector(dx:0, dy:1)
        let v2 = CGVector(dx:destPoint.x - position.x, dy: destPoint.y - position.y)
        let angle = atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx)
        zRotation = angle
    }
}
