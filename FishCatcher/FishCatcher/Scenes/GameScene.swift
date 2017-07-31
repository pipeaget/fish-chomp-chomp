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
    let logic = Logic()
    var greenFish:GreenFish!
    var blueFish:BlueFish!
    lazy var btnMute:AGSpriteButton = {
        let btn = AGSpriteButton(imageNamed: "mute")
        return btn
    }()
    var musicPlayer:AudioPLayer!
    var livesLabel:SKLabelNode!
    let cameraNode = SKCameraNode()
    
    override init(size: CGSize) {
        musicPlayer = AudioPLayer()
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin,
                              width: size.width,
                              height: playableHeight)
        var textures:[SKTexture] = []
        for i in 1...6{
            textures.append(SKTexture(imageNamed: "cat\(i)"))
        }
        textures.append(textures[4])
        textures.append(textures[3])
        textures.append(textures[2])
        catAnimation = SKAction.animate(with: textures, timePerFrame: 0.1)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.white
        musicPlayer.playBackgroundMusic()
        cat.position = CGPoint(x: 400, y: 400)
        cat.xScale = cat.xScale * -1
        addChild(cat)
        cat.startCatAnimation()
        spawnFishes()
        spawnEnemy()
        debugDrawPlayableArea()
        btnMute.position = CGPoint(x: 1980, y: 1271)
        btnMute.setScale(0.4)
        btnMute.addTarget(self, selector: #selector(self.stopMusic), with: nil, for: .touchUpInside)
        addChild(btnMute)
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)
        addLivesLabel()
        
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
        livesLabel.text = "Vidas:\(logic.lifes)"
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
    
    override func didEvaluateActions() {
        checkCollisions()
    }
    
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
    func sceneTouched(touchLocation:CGPoint) {
        lastTouchLocation = touchLocation
        moveCatToward(location: touchLocation)
    }
    func moveCatToward(location: CGPoint) {
        let offset = location - cat.position
        let direction = offset.normalized()
        velocity = direction * cat.catMovePointsPerSec
    }
    
    func stopMusic(){
        let name = musicPlayer.backgroundPlayer.isPlaying ?  "mute":"unmute"
        btnMute.removeFromParent()
        btnMute = AGSpriteButton(imageNamed: name)
        btnMute.position = CGPoint(x: 1980, y: 1271)
        btnMute.setScale(0.4)
        btnMute.addTarget(self, selector: #selector(self.stopMusic), with: nil, for: .touchUpInside)
        addChild(btnMute)
        musicPlayer.backgroundPlayer.isPlaying ? musicPlayer.pauseBackgroundMusic():musicPlayer.playBackgroundMusic()
        
    }
    
    /// Method that draws the playable area
    private func debugDrawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(playableRect)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
    private func addLivesLabel(){
        livesLabel = SKLabelNode(fontNamed: "Glimstick")
        livesLabel.text = "Vidas: \(logic.lifes)"
        livesLabel.fontColor = UIColor.black
        livesLabel.fontSize = 100
        livesLabel.zPosition = 150
        livesLabel.horizontalAlignmentMode = .left
        livesLabel.verticalAlignmentMode = .bottom
        livesLabel.position = CGPoint(x: -playableRect.size.width/2 + CGFloat(20),
                                      y: -playableRect.size.height/2 + CGFloat(20))
        
        cameraNode.addChild(livesLabel)
    }
    
    /// Method that creates an enemy
    private func spawnEnemy() {
       let enemy = RedFish(imageNamed: "red_fish1")
        enemy.name = "enemy"
        enemy.position = CGPoint(x: CGFloat.random(min: playableRect.minX, max: playableRect.maxX),
                                 y: CGFloat.random(min: playableRect.minY, max: playableRect.maxY))
        enemy.setScale(0)
        addChild(enemy)
        enemy.startFishAnimation()
        let appear = SKAction.scale(to: 1.0, duration: 0.5)
        enemy.run(appear)
    }
    
    
    /// Method that creates the green fish
    private func addGreenFish(){
        greenFish = GreenFish(imageNamed: "green_fish1")
        greenFish.name = "green_fish"
        greenFish.position = CGPoint(x: CGFloat.random(min: playableRect.minX, max: playableRect.maxX),
                                     y: CGFloat.random(min: playableRect.minY, max: playableRect.maxY))
        greenFish.setScale(0)
        addChild(greenFish)
        greenFish.startFishAnimation()
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
        greenFish.run(SKAction.sequence(actions))
        
    }
    
    
    /// Method that creates the blue fish
    private func addBlueFish(){
        blueFish = BlueFish(imageNamed: "blue_fish1")
        blueFish.name = "blue_fish"
        blueFish.position = CGPoint(x: CGFloat.random(min: playableRect.minX, max: playableRect.maxX),
                                    y: CGFloat.random(min: playableRect.minY, max: playableRect.maxY))
        blueFish.setScale(0)
        addChild(blueFish)
        blueFish.startFishAnimation()
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
        blueFish.run(SKAction.sequence(actions))
        
    }
    
    
    /// Method that creates both green and blue fishes
    private func spawnFishes(){
        addGreenFish()
        addBlueFish()
    }
    
    
    /// Method that check all the collisions
    private func checkCollisions(){
        var hitedGreenFishes:[GreenFish] = []
        enumerateChildNodes(withName: "green_fish") { node, _ in
            let fish = node as! GreenFish
            if fish.frame.intersects(self.cat.frame){
                hitedGreenFishes.append(fish)
            }
        }
        removeFishesCollided(fishes: hitedGreenFishes)
        var hittedBlueFish:[BlueFish] = []
        enumerateChildNodes(withName: "blue_fish") { node, _ in
            let fish = node as! BlueFish
            if fish.frame.intersects(self.cat.frame){
                hittedBlueFish.append(fish)
            }
        }
        removeFishesCollided(fishes: hittedBlueFish)
        //The cat is temporary invincible 
        if cat.invincible {
            return
        }
        var hitedEnemies:[RedFish] = []
        enumerateChildNodes(withName: "enemy") { node, _ in
            let redFish = node as! RedFish
            if redFish.frame.intersects(self.cat.frame){
                hitedEnemies.append(redFish)
            }
        }
        removeEnemyCollided(fishes: hitedEnemies)
        
    }
    
    
    /// Method that remove from screen to the collided fishes
    ///
    /// - Parameter fishes: Array of fishes collided
    private func removeFishesCollided(fishes:[SKSpriteNode]){
        for fish in fishes{
            let redFishes = logic.redFishes
            logic.touchBlueOrGreenFish()
            if redFishes != logic.redFishes{
                spawnEnemy()
            }
            fish.removeAllActions()
            fish.isHidden = true
            if let fish = fish as? GreenFish{
                fish.changePositionAndShow(in: playableRect)
            }else if let fish = fish as? BlueFish {
                fish.changePositionAndShow(in: playableRect)
            }
        }
    }
    
    /// Method that remove from screen to the collided enemies
    ///
    /// - Parameter fishes: Array of enemies collided
    private func removeEnemyCollided(fishes:[RedFish]){
        for redFish in fishes{
            redFish.removeAllActions()
            redFish.isHidden = true
            cat.catHit(enemy: redFish)
            logic.touchRedFish{ gameover in
                if gameover{
                    self.musicPlayer.stopBackgroundMusic()
                    let gameOverScene = GameOverScene(size: self.size, lose: true)
                    gameOverScene.scaleMode = self.scaleMode
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    self.view?.presentScene(gameOverScene, transition: reveal)
                   return
                }
                redFish.changePositionAndShow(in: self.playableRect)
            }
        }
    }
}
