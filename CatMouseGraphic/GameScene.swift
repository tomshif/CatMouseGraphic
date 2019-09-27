//
//  GameScene.swift
//  CatMouseGraphic
//
//  Created by Tom Shiflet on 9/27/19.
//  Copyright © 2019 Tom Shiflet. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // Constants
    let mouseScale:CGFloat = 0.1
    let catScale:CGFloat = 0.2
    var SPEED:CGFloat = 1.0
    
    // SKNodes
    var bg=SKSpriteNode(imageNamed: "roomBG")
    var mouse=SKSpriteNode(imageNamed: "mouse")
    var mouseHole=SKSpriteNode(imageNamed: "mouse_hole")
    var cat=SKSpriteNode(imageNamed: "cat")
    var cheese=SKSpriteNode(imageNamed: "cheese")
    let scoreLabel=SKLabelNode(fontNamed: "Chalkduster")
    let gameOverLabel=SKLabelNode(fontNamed: "Chalkduster")
    var mouseHole2=SKSpriteNode(imageNamed: "mouse_hole")
    
    // Bools
    var leftPressed:Bool=false
    var rightPressed:Bool=false
    var mouseLeft:Bool=true
    var catLeft:Bool=true
    var catChasing:Bool=false
    var hasCheese:Bool=false
    var inHouse:Bool=false
    var gameOver:Bool=false
    
    // Ints
    var score:Int=0
    
    
    
    override func didMove(to view: SKView) {
        bg.setScale(1.2)
        bg.position.y = -size.height*0.1
        backgroundColor=NSColor.black
        addChild(bg)

        // init mouse
        mouse.position.y = -size.height*0.415
        mouse.position.x = size.width*0.4
        mouse.zPosition = 10
        mouse.setScale(mouseScale)
        addChild(mouse)
        
        // init mouse hole
        mouseHole.position.y = -size.height*0.415
        mouseHole.position.x = size.width*0.46
        mouseHole.zPosition=20
        mouseHole.setScale(0.22)
        addChild(mouseHole)
        
        // init mouse hole2
        mouseHole2.position.y = -size.height*0.415
        mouseHole2.position.x = -size.width*0.46
        mouseHole2.zPosition=20
        mouseHole2.setScale(0.22)
        addChild(mouseHole2)
        
        
        // init cat
        cat.position.y = -size.height*0.415
        cat.position.x = -size.width*0.3
        cat.zPosition=15
        cat.setScale(catScale)
        addChild(cat)
        
        // cheese
        cheese.position.y = -size.height*0.415
        cheese.position.x = 0
        cheese.zPosition=5
        cheese.setScale(0.15)
        addChild(cheese)
        
        // init score
        scoreLabel.position.y=size.height*0.4
        scoreLabel.fontSize=30
        scoreLabel.fontColor=NSColor.white
        addChild(scoreLabel)
        
        // gameover
        gameOverLabel.fontSize=60
        gameOverLabel.fontColor=NSColor.red
        gameOverLabel.text="Game Over."
        gameOverLabel.isHidden=true
        gameOverLabel.zPosition=500
        addChild(gameOverLabel)
        
    } // func didMove
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {
 
    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0:
            leftPressed=true
            
        case 2:
            rightPressed=true
            
        case 49:
            if gameOver
            {
                score=0
                cat.position.x = -size.width*0.3
                cheese.position.x = 0
                mouse.position.x = size.width*0.4
                gameOver=false
                hasCheese=false
                catChasing=false
                catLeft=true
                mouseLeft=false
                SPEED=1.0
                
            } // if restarting game
            
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    } // func keyDown
    
    override func keyUp(with event: NSEvent) {
        switch event.keyCode {
        case 0:
            leftPressed=false
            
        case 2:
            rightPressed=false


        default:
            break
        }
    } // func keyup
    
    func checkKeys()
    {
        if leftPressed
        {
            mouse.position.x -= 2 * SPEED
            mouseLeft=true
        }
        if rightPressed
        {
            mouse.position.x += 2 * SPEED
            mouseLeft=false
        }
        
        if mouse.position.x > size.width/2
        {
            mouse.position.x = -size.width/2
        }
        if mouse.position.x < -size.width/2
        {
            mouse.position.x = size.width/2
        }
    } // func checkKeys
    
    func updateFacing()
    {
        if mouseLeft
        {
            mouse.xScale = mouseScale
        }
        else
        {
            mouse.xScale = -mouseScale
        }
        
        if catLeft
        {
            cat.xScale = -catScale
        }
        else
        {
            cat.xScale = catScale
        }
    } // update facing
    
    func getMouseDist() -> CGFloat
    {
        let dist=CGFloat(abs(cat.position.x-mouse.position.x))
        return dist
        
    }
    
    func updateCat()
    {
        
        // small chance to reverse direction
        let chance=random(min:0, max: 1.0)
        
        
        if chance > 0.99
        {
            catLeft.toggle()
        }
        
        if !catLeft && cat.position.x < -size.width*0.45
        {
            catLeft=true
        }
        
        if catLeft && !catChasing
        {
            cat.position.x += 1 * SPEED
        }
        else if !catLeft && !catChasing
        {
            cat.position.x -= 1 * SPEED
        }
        else if catChasing
        {
            if mouse.position.x > cat.position.x
            {
                catLeft=true
                cat.position.x += 2.5 * SPEED
            }
            else
            {
                catLeft=false
                cat.position.x -= 2.5 * SPEED
            }
        } // else if cat is chasing
        
        catChasing=false
        if !inHouse && cat.position.x > -size.width*0.25 && cat.position.x < size.width*0.25
        {
            if !catLeft && mouse.position.x > cat.position.x
            {
                if getMouseDist() < 150
                {
                    catChasing=true
                }
            } // if mouse is behind cat
            else if !catLeft && mouse.position.x < cat.position.x
            {
                if getMouseDist() < 300
                {
                    catChasing=true
                }
            } // else
            else if catLeft && mouse.position.x < cat.position.x
            {
                if getMouseDist() < 150
                {
                    catChasing=true
                }
            }
            else if catLeft && mouse.position.x > cat.position.x
            {
                if getMouseDist() < 300
                {
                    catChasing = true
                }
            }
            
        }
        
        
        if cat.position.x > size.width*0.35
        {
            catChasing=false
            catLeft=false
        }
        if cat.position.x < -size.width*0.35
        {
            catChasing=false
            catLeft=true
        }
    } // func updateCat
    
    func updateCheese()
    {
        if hasCheese
        {
            cheese.position.x = mouse.position.x + (-mouse.xScale*250)
            
            if mouseHole.contains(mouse.position) || mouseHole2.contains(mouse.position)
            {
                score += 10
                print("Score")
                cheese.position.x = 0
                hasCheese=false
                SPEED += 0.25
                
            }
        } // if the mouse has the cheese
        else
        {
            if cheese.contains(mouse.position)
            {
                hasCheese=true
                
            }
            
        } // else if mouse has no cheddar
        
        if mouseHole.contains(mouse.position) || mouseHole2.contains(mouse.position)
        {
            inHouse=true
        }
        else
        {
            inHouse=false
        }
        
    } // func updateCheese
    
    func checkKill()
    {
        if cat.contains(mouse.position)
        {
            gameOver=true
        }
    } // func checkKill
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
       if !gameOver
       {
            gameOverLabel.isHidden=true
            scoreLabel.text=String(format: "%05d",score)
            updateCheese()
            updateCat()
            updateFacing()
            checkKeys()
            checkKill()
        } // if not game over
        else
        {
            gameOverLabel.isHidden=false
        
        }
    
    } // func update
} // class GameScene
