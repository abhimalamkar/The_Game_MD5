//
//  GameScene.swift
//  MalamkarAbhijeet_The_Game
//
//  Created by Abhijeet Malamkar on 7/11/17.
//  Copyright © 2017 abhijeetmalamkar. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene ,getPosition{
    
    private var node : SKShapeNode!
    var nodes:[SKShapeNode]?
    public var connection:Connection?
    var sender:Sender?
    var widthOffset:Double!
    var heightOffset:Double!
    var viewWidth:Double!
    var viewHeight:Double!
    
    override func didMove(to view: SKView) {
        drawCharacter()
        
        //self.node = self.childNode(withName: "node")
        widthOffset = 300//Double(node.frame.width/2)
        heightOffset = 400//Double(node.frame.height/2)
        viewWidth = Double(view.frame.width)
        viewHeight  = Double(view.frame.height)
        
        print(widthOffset)
        print(heightOffset)
        
        connection?.delegate = self
        sender = Sender(postions: [CGPoint](), alpha: [Int]())
        if let num = connection?.numDevices() {
            for _ in 0...num {
                sender?.alpha?.append(0)
                sender?.postions?.append(CGPoint(x: 0, y: 0))
            }
        }
    }
    
    func drawCharacter(){
        nodes = [SKShapeNode]()
        
        node = SKShapeNode()
        self.addChild(node)
        
        var torsoPoints = [CGPoint(x:0,y:0),
                           CGPoint(x:0,y:50),
                           CGPoint(x:0,y:100)]
        var torso = SKShapeNode(splinePoints: &torsoPoints,
                                          count: torsoPoints.count)
        torso.lineWidth = 10
        
        
        let head = SKShapeNode()
        head.path = UIBezierPath(ovalIn: CGRect(x:0, y:0, width:100, height:100)).cgPath
        head.position = CGPoint(x: (torso.path?.currentPoint.x)! - 50, y: (torso.path?.currentPoint.y)!)//CGPoint(x:(view?.scene!.frame.midX)!-50, y:(view?.scene!.frame.midY)!-50)
        head.fillColor = UIColor.clear
        head.strokeColor = UIColor.white
        head.lineWidth = 20
        
        var leftLegPoints = [CGPoint(x:0,y:0),
                             CGPoint(x:-10,y:-100),
                             CGPoint(x:-10,y:-200)]
        var leftLeg = SKShapeNode(splinePoints: &leftLegPoints,
                                count: leftLegPoints.count)
        leftLeg.lineWidth = 10
        
        var rightLegPoints = [CGPoint(x:0,y:0),
                             CGPoint(x:10,y:-100),
                             CGPoint(x:10,y:-200)]
        var rightLeg = SKShapeNode(splinePoints: &rightLegPoints,
                                  count: rightLegPoints.count)
        rightLeg.lineWidth = 10
        
        var leftArmPoints = [CGPoint(x:0,y:70),
                             CGPoint(x:-75,y:70),
                             CGPoint(x:-75,y:-5)]
        var leftArm = SKShapeNode(splinePoints: &leftArmPoints,
                                  count: leftArmPoints.count)
        leftArm.lineWidth = 10
        
        var rightArmPoints = [CGPoint(x:0,y:70),
                              CGPoint(x:75,y:70),
                              CGPoint(x:150,y:70)]
        var rightArm = SKShapeNode(splinePoints: &rightArmPoints,
                                   count: rightArmPoints.count)
        rightArm.lineWidth = 10
        
        node.addChild(torso)
        node.addChild(head)
        node.addChild(leftLeg)
        node.addChild(rightLeg)
        node.addChild(leftArm)
        node.addChild(rightArm)
        
        nodes?.append(head)
        nodes?.append(torso)
        nodes?.append(leftArm)
        nodes?.append(rightArm)
        nodes?.append(leftLeg)
        nodes?.append(rightArm)
        
//        let oneRevolution = SKAction.rotate(byAngle: 360, duration: 1000)
//        let something = SKAction.repeatForever(oneRevolution)
//        node.run(something)
        
        
    }
    
    func getPosition(message:String) {
        sender?.message = message
        node?.position = (sender?.postions?[0])!
        node.alpha = CGFloat((sender?.alpha?[0])!)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        //node?.position = pos
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        //node?.position = pos
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let pos = touches.first?.location(in: self)
        node.position.x = (pos?.x)!
        node.position.y = (pos?.y)!
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let pos = touches.first?.location(in: self)
        node.position.x = (pos?.x)!
        node.position.y = (pos?.y)!
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        //node?.position.y = (node?.position.y)! + 1
        //node?.position.x = (node?.position.x)! + 1
        
        handleSend()
        
    }
    
    func handleSend(){
        let x:Double = Double(node.position.x)
        let y:Double = Double(node.position.y)
        
        if(x + widthOffset > viewWidth) {
            sender?.postions?[0] = CGPoint(x:-(viewWidth-x),y:y)
            sender?.alpha?[0] = 1
            connection?.send(_message:  (sender?.message)!)
        } else if(x - widthOffset < 0) {
            sender?.postions?[0] = CGPoint(x: viewWidth+x,y:y)
            sender?.alpha?[0] = 1
            connection?.send(_message:  (sender?.message)!)
        }
            
            //        else if(-y + widthOffset > viewWidth) {
            //            sender?.postions?[0] = CGPoint(x:x,y: y+viewWidth)
            //            sender?.alpha?[0] = 1
            //            connection?.send(_message:  (sender?.message)!)
            //        } else if(y + widthOffset < 0) {
            //            sender?.postions?[0] = CGPoint(x: x,y:viewWidth-y)
            //            sender?.alpha?[0] = 1
            //            connection?.send(_message:  (sender?.message)!)
            //        }
            
        else if (self.contains(CGPoint(x: (x > (viewWidth)/2 ? x - widthOffset : x + widthOffset), y: y))) {
            sender?.alpha?[0] = 0
            sender?.postions?[0] = CGPoint(x: x, y: y)
            connection?.send(_message:  (sender?.message)!)
        }
    }
}
