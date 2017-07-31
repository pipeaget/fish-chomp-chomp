//
//  GameScene.swift
//  FishCatcher
//
//  Created by F J Castaneda Ramos on 7/29/17.
//  Copyright © 2017 VincoOrbis. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    let playableRect: CGRect
    var lastTouchLocation: CGPoint?
    let catAnimation:SKAction
    let cat = CatCharacter(imageNamed: "cat1")
    var velocity = CGPoint.zero
    
    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin,
                              width: size.width,
                              height: playableHeight)
        var textures:[SKTexture] = []
        for i in 1...4{
            textures.append(SKTexture(imageNamed: "cat\(i)"))
        }
        textures.append(textures[2])
        textures.append(textures[1])
        catAnimation = SKAction.animate(with: textures, timePerFrame: 0.1)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.white
        cat.position = CGPoint(x: 400, y: 400)
        cat.xScale = cat.xScale * -1
        addChild(cat)
        cat.startCatAnimation()
        run(SKAction.repeatForever(
            SKAction.sequence([SKAction.run() { [weak self] in
                //                self?.spawnEnemy()
                //                self?.spawnFishes()
                },SKAction.wait(forDuration: 2.0)])))
        debugDrawPlayableArea()
    }
    override func update(_ currentTime: TimeInterval) {
        dt = lastUpdateTime > 0 ? currentTime - lastUpdateTime : 0
        lastUpdateTime = currentTime
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
    func sceneTouched(touchLocation:CGPoint) {
        lastTouchLocation = touchLocation
        moveCatToward(location: touchLocation)
    }
    func moveCatToward(location: CGPoint) {
        let offset = location - cat.position
        let direction = offset.normalized()
        velocity = direction * cat.catMovePointsPerSec
    }
    
    
    private func debugDrawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(playableRect)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
    private func spawnEnemy() {
        let enemy = RedFish(imageNamed: "red_fish1")
        enemy.name = "enemy"
        enemy.position = CGPoint(
            x: size.width + enemy.size.width/2,
            y: CGFloat.random(
                min: playableRect.minY + enemy.size.height/2,
                max: playableRect.maxY - enemy.size.height/2))
        addChild(enemy)
        enemy.startFishAnimation()
        let actionMove =
            SKAction.moveTo(x: -enemy.size.width/2, duration: 3)
        let actionRemove = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([actionMove, actionRemove]))
    }
    
    private func addGreenFish(){
        let greenFish = GreenFish(imageNamed: "green_fish1")
        greenFish.name = "green_fish"
        greenFish.position = CGPoint(x: CGFloat.random(min: playableRect.minX, max: playableRect.maxX),
                                     y: CGFloat.random(min: playableRect.minY, max: playableRect.maxY))
        greenFish.setScale(0)
        addChild(greenFish)
        greenFish.startFishAnimation()
        let appear = SKAction.scale(to: 1.0, duration: 0.5)
        greenFish.zRotation = -π / 16
        let leftWiggle = SKAction.rotate(byAngle: π/8, duration: 0.5)
        let rightWiggle = leftWiggle.reversed()
        let fullWiggle = SKAction.sequence([leftWiggle,rightWiggle])
        let scaleUp = SKAction.scale(by: 1.0, duration: 0.25)
        let scaleDown = scaleUp.reversed()
        let fullScale = SKAction.sequence([scaleUp,scaleDown,scaleUp,scaleDown])
        let group = SKAction.group([fullScale,fullWiggle])
        let groupWait = SKAction.repeat(group, count: 10)
        let disappear = SKAction.scale(to: 0, duration: 0.5)
        let removeFromParent = SKAction.removeFromParent()
        let actions = [appear,groupWait,disappear,removeFromParent]
        greenFish.run(SKAction.sequence(actions))
        
    }
    
    private func addBlueFish(){
        let blueFish = BlueFish(imageNamed: "blue_fish1")
        blueFish.name = "blue_fish"
        blueFish.position = CGPoint(x: CGFloat.random(min: playableRect.minX, max: playableRect.maxX),
                                    y: CGFloat.random(min: playableRect.minY, max: playableRect.maxY))
        blueFish.setScale(0)
        addChild(blueFish)
        blueFish.startFishAnimation()
        let appear = SKAction.scale(to: 1.0, duration: 0.5)
        blueFish.zRotation = -π / 32
        let leftWiggle = SKAction.rotate(byAngle: π/8, duration: 0.5)
        let rightWiggle = leftWiggle.reversed()
        let fullWiggle = SKAction.sequence([leftWiggle,rightWiggle])
        let scaleUp = SKAction.scale(by: 1.0, duration: 0.25)
        let scaleDown = scaleUp.reversed()
        let fullScale = SKAction.sequence([scaleUp,scaleDown,scaleUp,scaleDown])
        let group = SKAction.group([fullScale,fullWiggle])
        let groupWait = SKAction.repeat(group, count: 10)
        let disappear = SKAction.scale(to: 0, duration: 0.5)
        let removeFromParent = SKAction.removeFromParent()
        let actions = [appear,groupWait,disappear,removeFromParent]
        blueFish.run(SKAction.sequence(actions))
        
    }
    
    private func spawnFishes(){
        addGreenFish()
        addBlueFish()
    }
    
}
