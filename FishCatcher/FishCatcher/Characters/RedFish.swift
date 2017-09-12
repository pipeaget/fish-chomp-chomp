//
//  RedFish.swift
//  FishCatcher
//
//  Created by F J Castaneda Ramos on 7/29/17.
//  Copyright © 2017 VincoOrbis. All rights reserved.
//

import SpriteKit

class RedFish: Fish {

    func createAnimation(){
        fishAnimation = createFishAnimationWithSprite("red_fish")
    }

    internal func setPhysicBody() {
        name = "Enemy"
        let size = CGSize(width: frame.size.width*0.75, height: frame.size.height*0.75)
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = PhysicsCategory.enemy
        
    }
}
