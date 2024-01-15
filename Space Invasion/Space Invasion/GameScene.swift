//
//  GameScene.swift
//  Space Invasion
//
//  Created by Dharav Shah on 2022-05-28.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var touchLocation = CGPoint(x:0,y:0)
override func didMove(to view: SKView) {
        createBackground()
        createPlayer()
        timerForSlowAsteroids()
        timerForFastAsteroid()
        createScore()
        timerForScore()
        endGame()
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
}
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches{
        touchLocation = touch.location(in: self)

        let angle = atan2(touchLocation.y - player.position.y , touchLocation.x - player.position.x)
        player.zRotation = angle - CGFloat(Double.pi/2)
        
        let newShipLocation: CGPoint = CGPoint(x: touchLocation.x ,y: touchLocation.y)
        let moveShip = SKAction.move (to: newShipLocation, duration: 0.5)
        player.run(moveShip)
    }//Use SKAction for ship movement and use touchlocation
    
}
func createBackground(){
    let backgroundTexture = SKTexture(imageNamed: "jpegSpace" )
    let background = SKSpriteNode(texture: backgroundTexture)
    background.zPosition = -20
    background.position = CGPoint(x: frame.midX,y: frame.midY)
    
    addChild(background)
    }
var player: SKSpriteNode!
func createPlayer() {
    let playerTexture = SKTexture(imageNamed: "playerSmokeAcc180x180")
    player = SKSpriteNode(texture: playerTexture)
    player.zPosition = 10
    player.position = CGPoint(x: frame.midX, y: frame.midY)

    addChild(player)
    
    let frame2 = SKTexture(imageNamed: "Player smoke180x180")
    let frame3 = SKTexture(imageNamed: "player180x180")
    let frame4 = SKTexture(imageNamed: "PlayerBoostDark180x180")
    let animation = SKAction.animate(with: [frame4, frame2, frame4, playerTexture, frame3], timePerFrame: 0.05)
    let runForever = SKAction.repeatForever(animation)
    player.run(runForever)
    
    player.physicsBody = SKPhysicsBody(texture: playerTexture, size: playerTexture.size())
    player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
    player.physicsBody?.isDynamic = true
    player.physicsBody?.collisionBitMask = 0
    player.name = "Ship"
    }
var asteroid: SKSpriteNode!

    func createAsteroids(speed: Double) {
    var xCoord = 0
    var yCoord = 0
    var xCoord2 = 0
    var yCoord2 = 0
    let startPoint = [1,2,3,4].randomElement()
    if startPoint == 1{ //right
        xCoord = Int.random(in:950 ... 1150)
        yCoord = Int.random(in:-1304 ... 1304)
    }
    else if startPoint == 2{ //top
        xCoord = Int.random(in:-720 ... 720)
        yCoord = Int.random(in:1534 ... 1734)
    }
    else if startPoint == 3{ //left
        xCoord = Int.random(in:-1150 ...  -950)
        yCoord = Int.random(in:-1304 ... 1304)
    }
    else if startPoint == 4{ //bottom
        xCoord = Int.random(in:-720 ... 720)
        yCoord = Int.random(in:-1734 ...  -1534)
    }
    
    let startPoint2 = [1,2,3,4].randomElement()
    if startPoint2 == 1{ //right
        xCoord2 = Int.random(in:950 ... 1150)
        yCoord2 = Int.random(in:-1304 ... 1304)
    }
    else if startPoint2 == 2{ //top
        xCoord2 = Int.random(in:-720 ... 720)
        yCoord2 = Int.random(in:1534 ... 1734)
    }
    else if startPoint2 == 3{ //left
        xCoord2 = Int.random(in:-1150 ...  -950)
        yCoord2 = Int.random(in:-1304 ... 1304)
    }
    else if startPoint2 == 4{ //bottom
        xCoord2 = Int.random(in:-720 ... 720)
        yCoord2 = Int.random(in:-1734 ...  -1534)
    }
    let asteroidTexture = SKTexture(imageNamed: "AsteroidNew190x190")
    asteroid = SKSpriteNode(texture: asteroidTexture)
    asteroid.zPosition = 10
    asteroid.position = CGPoint(x: xCoord ,y: yCoord )
    addChild(asteroid)
    
    asteroid.physicsBody = SKPhysicsBody(circleOfRadius: asteroid.size.width / 2)
    asteroid.physicsBody!.contactTestBitMask = asteroid.physicsBody!.collisionBitMask
    asteroid.physicsBody?.isDynamic = true
    asteroid.physicsBody?.collisionBitMask = 0
    let newLocation: CGPoint = CGPoint(x: xCoord2 ,y: yCoord2)
    let move = SKAction.move (to: newLocation, duration: speed)
    //make a sequence that also removes the sprite to stop lag
    let moveSequence = SKAction.sequence([move,SKAction.removeFromParent()])
    asteroid.run(moveSequence)
    }
   
var timer1 = Timer()
var timer2 = Timer()
var timer3 = Timer()
    
func timerForSlowAsteroids(){
    self.timer1 = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { _ in
        self.createAsteroids(speed: 5.9)
    })
}
func timerForFastAsteroid(){
    self.timer2 = Timer.scheduledTimer(withTimeInterval: 0.45, repeats: true, block: { _ in
        self.createAsteroids(speed: 6.8)
    })
}
func timerForScore(){
    self.timer3 = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
        self.score += 1
    })
        
    }
var scoreLabel: SKLabelNode!
var endLabel: SKLabelNode!
var endLabel2: SKLabelNode!

var score = 0 {
    didSet {
        scoreLabel.text = "SCORE: \(score)"
        }
    }
func createScore() {
    scoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
    scoreLabel.fontSize = 24

    scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 100)
    scoreLabel.text = "SCORE: 0"
    scoreLabel.fontColor = UIColor.white

    addChild(scoreLabel)
    }

func endGame(){
    endLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
    endLabel.fontSize = 80
    endLabel.position = CGPoint(x: frame.midX, y: frame.midY)
    endLabel.text = "Game over"
    endLabel.fontColor = UIColor.white
    endLabel.alpha = 0
    addChild(endLabel)
    
    }
func endGame2(){
    endLabel2 = SKLabelNode(fontNamed: "Optima-ExtraBlack")
    endLabel2.fontSize = 45
    endLabel2.position = CGPoint(x: frame.midX, y: frame.midY - 100)
    endLabel2.text = "Score: \(score)"
    endLabel2.fontColor = UIColor.lightGray
    endLabel2.alpha = 1
    addChild(endLabel2)
    }
func didBegin(_ contact: SKPhysicsContact) {
    if contact.bodyA.node == player || contact.bodyB.node == player {
        contact.bodyB.node?.removeFromParent()
        contact.bodyA.node?.removeFromParent()
        endGame2()
        endLabel.alpha = 1
        speed = 0
        timer3.invalidate()
        
}
}

}
//override func update(_ currentTime: TimeInterval) {
//    Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true){timer in print("Timer is working")
//        self.createAsteroids() //the timer does not work
//
//    }
//        // Called before each frame is rendered
//    //choose random int 1-4 for right,top,left,bottom
//    //have coordinate range for x and y.
//    //spawn asteroid there and use SkAction to fall down at randomized ranged angle
//    //create timer in update and every 0.5 seconds spawn in a asteroid
//    }





//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
//

        
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
    
    
//

