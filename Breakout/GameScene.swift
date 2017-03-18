//
//  GameScene.swift
//  Breakout
//
//  Created by Sage Hawk on 3/13/17.
//  Copyright © 2017 Sage Hawk. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ball = SKShapeNode()
    var ballIcon = SKShapeNode()
    var paddle = SKSpriteNode()
    var brick = SKSpriteNode()
    
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
        makeBrick()
        //createSprite()
        multiplyBrick()
        makeLoseZone()
        makeBallIcon()
        makeLivesLabel()
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 3))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "brick" ||
            contact.bodyB.node?.name == "brick" {
            brick.removeFromParent()
            print("\(numberOfBricks)")
            if numberOfBricks == 0 {
            print("You win!")
            game.IsOver = true
            }
            
            //ball.removeFromParent()
            
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
            
        if game.IsOver == true
        {
            //makeBall()
            game.IsOver = false
            ball.physicsBody?.isDynamic = true
            ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 3))

            }
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
    
    func makeBall() {
        ball = SKShapeNode(circleOfRadius: 10)
        ball.position = CGPoint(x:frame.midX, y: -150)
        ball.strokeColor = UIColor.black
        ball.fillColor = UIColor.yellow
        ball.name = "ball"
        
        // physics shape matches ball image
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 10)
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
        paddle = SKSpriteNode (color: UIColor.white, size: CGSize(width: frame.width/4, height: frame.height/25))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 125)
        paddle.name = "paddle"
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        addChild(paddle)
    }
    
    func makeBrick() {
        brick = SKSpriteNode(color: UIColor.blue, size: CGSize(width: frame.width/5, height: frame.height/25))
        brick.position = CGPoint(x: frame.midX, y: frame.maxY - 30)
        brick.name = "brick"
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
        brick.physicsBody?.isDynamic = false
        addChild(brick)
        numberOfBricks += 1
        
    }
    
    func makeLoseZone() {
        let loseZone = SKSpriteNode(color: UIColor.red, size: CGSize(width: frame.width, height: 50))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        loseZone.name = "loseZone"
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false
        addChild(loseZone)
    }
    
    /*func createSprite()->SKSpriteNode{
        brick = SKSpriteNode(color: UIColor.blue, size: CGSize(width: frame.width/5, height: frame.height/25))
        brick.position = CGPoint(x: frame.midX, y: frame.maxY - 30)
        brick.name = "brick"
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
        brick.physicsBody?.isDynamic = false
        addChild(brick)//Use the init function in the SKSpriteNode class
        //Add some code to define the sprite's property
        return brick
        let spriteOne = makeBrick()
        let spriteTwo = createSprite()
        let moveUp = SKAction.moveBy(x: 0,
                                     y: -100,//switched to negative will move down
                                     duration: 1.0)
        brick.run(moveUp)
    }*/
    func multiplyBrick() {
        makeBrick()
        let moveRight = SKAction.moveBy(x: 100,
                                     y: 0,
                                     duration: 0.0)
        let moveLeft = SKAction.moveBy(x: -100,
                                        y: 0,
                                        duration: 0.0)
        let moveDown = SKAction.moveBy(x: 0, y: -100, duration: 0.0)
        brick.run(moveRight)
        makeBrick()
        brick.run(moveLeft)
        makeBrick()
        brick.run(moveDown)
        makeBrick()
        brick.run(moveRight)
        brick.run(moveDown)
    }
    func makeBallIcon() {
        ballIcon = SKShapeNode(circleOfRadius: 10)
        ballIcon.position = CGPoint(x: -185, y: 355)
        ballIcon.strokeColor = UIColor.black
        ballIcon.fillColor = UIColor.yellow
        ballIcon.name = "BallIcon"
        addChild(ballIcon)
    }
    
    func makeLivesLabel() {
         //The variable holding the score.
        
        lblLives = SKLabelNode()
        lblLives.text = "\(lives)"
        lblLives.fontSize = 20
        lblLives.position = CGPoint(x: -153, y: 347)
        
        addChild(lblLives)
    }
    func updateScoreWithValue (value: Int) {
        lives -= value
        lblLives.text = "\(lives)"
    }
}
