//
//  GameScene.swift
//  FishCatcher
//
//  Created by F J Castaneda Ramos on 7/29/17.
//  Copyright © 2017 VincoOrbis. All rights reserved.
//

import SpriteKit

typealias ShouldPlayAction = (Bool) -> Void

class GameScene: SKScene {
    
    //Control
    var lastUpdate: TimeInterval = 0
    var dt: TimeInterval = 0
    var velocity: CGPoint = .zero
    weak var logic: Logic?
    var lastTouchLocation: CGPoint?
    lazy var playableRect: CGRect = self.createPlayableRect()
    var gameChagedDelegate: GameChanged?
    var shouldPlay: ShouldPlayAction?
    //Characters
    let cat: CatCharacter = CatCharacter(imageNamed: "cat1")
    
    
    //MARK: - Scene lifecycle
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "scenario_bg")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -100
        addChild(background)
        //Setting the cat
        cat.position = CGPoint(x: 400, y: 400)
        cat.name = "cat"
        cat.xScale = cat.xScale * -1
        cat.physicsBody = createCatPhysicBody()
        cat.setPhysicBody()
        addChild(cat)
        cat.startCatAnimation()
        //Create the enemy
        addEnemy()
        addGreenFish()
        addBlueFish()
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
    }
    
    override func update(_ currentTime: TimeInterval) {
        dt = lastUpdate > 0 ? currentTime - lastUpdate : 0
        lastUpdate = currentTime
        guard let lastTouchLocation =  lastTouchLocation else{
            boundsCheckCat()
            return
        }
        let diff = lastTouchLocation - cat.position
        if diff.length() <= cat.catMovePointsPerSec * CGFloat(dt) {
            cat.position = lastTouchLocation
            velocity = CGPoint.zero
        }else{
            cat.move(dt: dt, velocity: velocity)
            cat.rotate(dt: dt, direction: velocity)
        }
        boundsCheckCat()
        
    }
    
    //MARK: - All touch handlers
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
    
    func sceneTouched(touchLocation:CGPoint) {
        lastTouchLocation = touchLocation
        moveCatToward(location: touchLocation)
    }
    
    func moveCatToward(location: CGPoint) {
        let offset = location - cat.position
        let direction = offset.normalized()
        velocity = direction * cat.catMovePointsPerSec * 2
    }
    
    //MARK:- All control variables 
    
    /// Method that shows says if the cat is on the rect bounds
    func boundsCheckCat() {
        let bottomLeft = CGPoint(x: 0, y: playableRect.minY)
        let topRight = CGPoint(x: size.width, y: playableRect.maxY)
        
        if cat.position.x <= bottomLeft.x {
            cat.position.x = bottomLeft.x
            cat.velocity.x = -cat.velocity.x
        }
        if cat.position.x >= topRight.x {
            cat.position.x = topRight.x
            cat.velocity.x = -cat.velocity.x
        }
        if cat.position.y <= bottomLeft.y {
            cat.position.y = bottomLeft.y
            cat.velocity.y = -cat.velocity.y
        }
        if cat.position.y >= topRight.y {
            cat.position.y = topRight.y
            cat.velocity.y = -cat.velocity.y
        }
    }
    
    //MARK:- Private methods
    private func createPlayableRect() -> CGRect {
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        return CGRect(x: 0, y: playableMargin,
                      width: size.width,
                      height: playableHeight)
    }
    
    private func createCatPhysicBody() -> SKPhysicsBody{
        guard let catTexture = cat.texture else {
            return  SKPhysicsBody(rectangleOf: cat.frame.size)
        }
        return SKPhysicsBody(texture: catTexture, size: cat.size)
    }
    
    fileprivate func addEnemy(){
        let enemy = RedFish(imageNamed: "red_fish1")
        enemy.name = "enemy"
        let size =  CGSize(width: enemy.frame.size.width*0.8, height: enemy.frame.size.height*0.8)
        enemy.physicsBody = SKPhysicsBody(rectangleOf: size)
        enemy.setScale(0)
        enemy.fishAnimation = enemy.createFishAnimationWithSprite("red_fish")
        enemy.position = CGPoint(x: CGFloat.random(min: playableRect.minX, max: playableRect.maxX),
                                 y: CGFloat.random(min: playableRect.minY, max: playableRect.maxY))
        addChild(enemy)
        enemy.startFishAnimation()
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        enemy.physicsBody?.usesPreciseCollisionDetection = false
        let appear = SKAction.scale(to: 1.0, duration: 0.5)
        enemy.run(appear)
        enemy.move(on: self)
    }
    
    fileprivate func catHitEnemy(_ fish:RedFish){
        logic?.touchRedFish({ (gameover) in
            if gameover {
                self.gameChagedDelegate?.gameover()
                return
            }
            self.gameChagedDelegate?.loseLife()
        })
        fish.removeFromParent()
        addEnemy()
    }
    
    fileprivate func addGreenFish() {
        let greenFish = GreenFish(imageNamed:"green_fish1")
        greenFish.name = "goodFish"
        let size =  CGSize(width: greenFish.frame.size.width*0.8, height: greenFish.frame.size.height*0.8)
        greenFish.physicsBody = SKPhysicsBody(rectangleOf: size)
        greenFish.setScale(0)
        greenFish.fishAnimation = greenFish.createFishAnimationWithSprite("green_fish")
        greenFish.position = CGPoint(x: CGFloat.random(min: playableRect.minX, max: playableRect.maxX-100),
                                 y: CGFloat.random(min: playableRect.minY, max: playableRect.maxY-100))
        addChild(greenFish)
        greenFish.startFishAnimation()
        greenFish.physicsBody?.categoryBitMask = PhysicsCategory.goodFish
        greenFish.physicsBody?.usesPreciseCollisionDetection = false
        let appear = SKAction.scale(to: 1.0, duration: 0.5)
        greenFish.run(appear)
        greenFish.move(on: self)
    }
    fileprivate func addBlueFish(){
        let blueFish = BlueFish(imageNamed: "blue_fish1")
        blueFish.name = "goodFish"
        let size =  CGSize(width: blueFish.frame.size.width*0.8, height: blueFish.frame.size.height*0.8)
        blueFish.physicsBody = SKPhysicsBody(rectangleOf: size)
        blueFish.setScale(0)
        blueFish.fishAnimation = blueFish.createFishAnimationWithSprite("blue_fish")
        blueFish.position = CGPoint(x: CGFloat.random(min: playableRect.minX, max: playableRect.maxX),
                                     y: CGFloat.random(min: playableRect.minY, max: playableRect.maxY))
        addChild(blueFish)
        blueFish.startFishAnimation()
        blueFish.physicsBody?.categoryBitMask = PhysicsCategory.goodFish
        blueFish.physicsBody?.usesPreciseCollisionDetection = false
        let appear = SKAction.scale(to: 1.0, duration: 0.5)
        blueFish.run(appear)
        blueFish.move(on: self)
    }
    
    fileprivate func catHitGoodFish(_ fish: Fish) {
        var enemies:[RedFish] = []
        enumerateChildNodes(withName: "enemy") { node, _ in
            let redFish = node as! RedFish
            enemies.append(redFish)
        }
        if let redFishes = logic?.redFishes, redFishes != enemies.count && enemies.count < redFishes{
            let diff = redFishes - enemies.count
            for _ in 0..<diff{
                addEnemy()
            }
        }
        logic?.touchBlueOrGreenFish()
        if let score = logic?.score{
            gameChagedDelegate?.setScore(score: score)
        }
        
        if let toCatch = logic?.catchesToNextLife{
            gameChagedDelegate?.fishCatch(toCatch)
        }
        fish.removeFromParent()
        if fish is GreenFish{
            addGreenFish()
        }else if fish is BlueFish {
            addBlueFish()
        }
    }
    
}

// MARK: - SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = (contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask)
        switch collision {
        case (PhysicsCategory.cat, PhysicsCategory.enemy) :
            if let enemy = contact.bodyB.node as? RedFish {
                enemy.removeFromParent()
                catHitEnemy(enemy)
            }
            break
        case (PhysicsCategory.cat,PhysicsCategory.goodFish) :
            if let fish = contact.bodyB.node as? Fish {
                catHitGoodFish(fish)
            }
            break
        default:
            break
        }
    }
}
