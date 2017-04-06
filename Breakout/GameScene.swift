//
//  GameScene.swift
//  Breakout
//
//  Created by Sage Hawk on 3/13/17.
//  Copyright © 2017 Sage Hawk. All rights reserved.
//

import SpriteKit
import GameplayKit

//let BallCategoryName = "ball"
//let PaddleCategoryName = "paddle"
//let BrickCategoryName = "brick"
//let BrickNodeCategoryName = "brickNode"

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ball = SKShapeNode()
    var ballIcon = SKShapeNode()
    var paddle = SKSpriteNode()
    var bricks = [SKSpriteNode]()
    
    var lblGameOver = SKLabelNode()
    var lblGameWon = SKLabelNode()
    var lblLives = SKLabelNode(fontNamed: "System")
    var lives:Int = 3
    var numberOfBricks = 0
    
    struct game {
        static var IsOver : Bool = false
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        createBackground()
        makeBall()
        makePaddle()
        multipleBricks()
        makeLoseZone()
        makeBallIcon()
        makeLabels()
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 3))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            paddle.position.x = location.x
            if game.IsOver == true {
                
                resetGame()
        }
    }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }
    
    /*func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node == brick ||
            contact.bodyB.node == brick {
            brick.removeFromParent()
            numberOfBricks -= 1
            print("\(numberOfBricks)")
            if numberOfBricks == 0 {
                print("You win!")
                game.IsOver = true
                ball.removeFromParent()
            }
            
        }
        
        if contact.bodyA.node?.name == "loseZone" ||
            contact.bodyB.node?.name == "lozeZone" {
            
            self.updateScoreWithValue (value: 1)
            ball.removeFromParent()
            makeBall()
            game.IsOver = false
            ball.physicsBody?.isDynamic = true
            ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 3))
            
            if lives == 0 {
                
                print("You lose!")
                ball.removeFromParent()
                game.IsOver = true
                
            }
            resetGame()
            
        }
    }*/
    
    func didBegin(_ contact: SKPhysicsContact) {
        for brick in bricks{
            if contact.bodyA.node == brick ||
                contact.bodyB.node == brick {
                brick.removeFromParent()
                numberOfBricks -= 1
                
                print("\(numberOfBricks)")
                if numberOfBricks == 0 {
                    print("You win!")
                    game.IsOver = true
                    ball.removeFromParent()
                    gameWon()
                }

                
                brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
                brick.physicsBody?.isDynamic = false
                
                
            }
        }
            if contact.bodyA.node?.name == "loseZone" ||
                contact.bodyB.node?.name == "loseZone" {
                
                self.updateScoreWithValue (value: 1)
                ball.removeFromParent()
                makeBall()
                ball.physicsBody?.isDynamic = true
                ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 3))
                game.IsOver = false
                ball.physicsBody?.isDynamic = true
                ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 3))
                
                if lives == 0 {
                    
                    print("You lose!")
                    ball.removeFromParent()
                    game.IsOver = true
                    
                }
                gameOver()
            }
        
        
    }
    
    func createBackground() {
        let stars = SKTexture(imageNamed: "stars")
        for i in 0...1 {
            let starsBackground = SKSpriteNode(texture: stars)
            starsBackground.zPosition = -1
            starsBackground.position = CGPoint(x: 0, y:
                starsBackground.size.height * CGFloat(i))
            addChild(starsBackground)
            let moveDown = SKAction.moveBy(x:0, y:
                -starsBackground.size.height, duration: 20)
            let moveReset = SKAction.moveBy(x: 0, y:
                starsBackground.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            starsBackground.run(moveForever)
        }
    }
    /* func createBackground() {
        let skyline = SKTexture(imageNamed: "skyline")
        for i in 0...1 {
            let nintendoBackground = SKSpriteNode(texture: skyline)
            nintendoBackground.zPosition = -1
            nintendoBackground.position = CGPoint(x: 0, y:
                nintendoBackground.size.height * CGFloat(i))
            addChild(nintendoBackground)
            let moveDown = SKAction.moveBy(x:0, y:
                -nintendoBackground.size.height + 50, duration: 20)
            let moveReset = SKAction.moveBy(x: 0, y:
                nintendoBackground.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            nintendoBackground.run(moveForever)
        }
    } */
    
    func makeBall() {
        ball = SKShapeNode(circleOfRadius: 10)
        ball.position = CGPoint(x:frame.midX, y: -150)
        ball.strokeColor = UIColor.black
        ball.fillColor = UIColor.white
        ball.name = "ball"
        
        // physics shape matches ball image
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 9)
        //ignores all forces and impulses
        ball.physicsBody?.isDynamic = false
        //use precise collision detection
        ball.physicsBody?.usesPreciseCollisionDetection = true
        // no loss of energy from friction
        ball.physicsBody?.friction = 0
        //gravity is not a factor
        ball.physicsBody?.affectedByGravity = false
        //bounces fully off of other objects
        ball.physicsBody?.restitution = 1
        //does not slow down over time
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)!
        addChild(ball) // add ball object to the view
    }
    
    func makePaddle() {
        paddle = SKSpriteNode (imageNamed: "paddle.png")//color: UIColor.white, size: CGSize(width: frame.width/4, height: frame.height/25))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 125)
        paddle.name = "paddle"
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        addChild(paddle)
    }
    
    func makeLoseZone() {
        let loseZone = SKSpriteNode(color: UIColor.white, size: CGSize(width: frame.width, height: 50))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        loseZone.name = "loseZone"
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false
        addChild(loseZone)
    }
    
    func makeBallIcon() {
        ballIcon = SKShapeNode(circleOfRadius: 10)
        ballIcon.position = CGPoint(x: -185, y: 355)
        ballIcon.strokeColor = UIColor.black
        ballIcon.fillColor = UIColor.white
        ballIcon.name = "BallIcon"
        addChild(ballIcon)
    }
    
    func makeLabels() {
        //The variable holding the score.
        lblLives = SKLabelNode()
        lblLives.text = "X \(lives)"
        lblLives.fontSize = 20
        lblLives.position = CGPoint(x: -153, y: 347)
        addChild(lblLives)
        
        lblGameOver = SKLabelNode()
        lblGameOver.text = "GAME OVER"
        lblGameOver.fontSize = 50
        lblGameOver.position = CGPoint(x: 0, y: 0)

        lblGameWon = SKLabelNode()
        lblGameWon.text = "GAME WON"
        lblGameWon.fontSize = 50
        lblGameWon.position = CGPoint(x: 0, y: 0)

        
    }
    
    func updateScoreWithValue (value: Int) {
        lives -= value
        lblLives.text = "X \(lives)"
    }

    func gameOver() {
        
        if game.IsOver == true
        {
            self.removeAllActions()
            self.removeAllChildren()
            addChild(lblGameOver)
            //add this to on tap gesture recognizer
            //game.IsOver = false
            //ball.physicsBody?.isDynamic = true
            //ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 3))
            
        }
    }
    
    func gameWon() {
        if game.IsOver == true
        {
            self.removeAllActions()
            self.removeAllChildren()
            addChild(lblGameWon)
        }
    }
    
    func multipleBricks() {
        let countB = Int(frame.width) / 100
        let height = Int(frame.maxY)
        let xOffset = (Int(frame.width) - (countB * 100)) / 10 + Int(frame.minX) + 50
        for x in 0..<countB{makeBrick(x: x * 100 + xOffset, y: height - 100) }
        for x in 0..<countB{makeBrick(x: x * 100 + xOffset, y: height - 250) }
        for x in 0..<countB{makeBrick(x: x * 100 + xOffset, y: height - 400) }
        
    }
    
    func makeBrick(x: Int, y: Int) {
        let brick = SKSpriteNode(imageNamed: "brick")
        
        brick.position = CGPoint(x: x, y: y)
        brick.name = "brick"
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
        brick.physicsBody?.isDynamic = false
        addChild(brick)
        numberOfBricks += 1
        bricks.append(brick)
    }
    func resetGame()
    {
        game.IsOver = false
        lives = 3
        numberOfBricks = 0
        self.removeAllActions()
        self.removeAllChildren()
        createBackground()
        makeBall()
        makePaddle()
        multipleBricks()
        makeLoseZone()
        makeBallIcon()
        makeLabels()
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 3))

    }
}
