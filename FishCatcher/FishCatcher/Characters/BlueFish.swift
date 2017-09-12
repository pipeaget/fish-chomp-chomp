//
//  BlueFish.swift
//  FishCatcher
//
//  Created by F J Castaneda Ramos on 7/29/17.
//  Copyright © 2017 VincoOrbis. All rights reserved.
//

import SpriteKit

class BlueFish: Fish {
    func createAnimation(){
        fishAnimation = createFishAnimationWithSprite("blue_fish")
    }
    
    internal func setPhysicBody() {
        name = "goodFish"
        let size = CGSize(width: frame.size.width*0.75, height: frame.size.height*0.75)
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = PhysicsCategory.goodFish
        physicsBody?.collisionBitMask = PhysicsCategory.cat
        physicsBody?.contactTestBitMask = 0x00000001
    }
}
