//
//  GameScene.swift
//  MalamkarAbhijeet_The_Game
//
//  Created by Abhijeet Malamkar on 7/11/17.
//  Copyright © 2017 abhijeetmalamkar. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreGraphics

class GameScene: SKScene ,getPosition{
    
    private var node : SKShapeNode!
    public var connection:Connection?
    var sender:Sender?
    var widthOffset:Double!
    var heightOffset:Double!
    var viewWidth:Double!
    var viewHeight:Double!
    
    var lowerTorso: SKNode!
    var upperTorso: SKNode!
    var upperArmFront: SKNode!
    var lowerArmFront: SKNode!
    var fistFront: SKNode!
    let upperArmAngleDeg: CGFloat = -10
    let lowerArmAngleDeg: CGFloat = 130
    var upperArmBack: SKNode!
    var lowerArmBack: SKNode!
    var fistBack: SKNode!
    var rightPunch = true
    var head: SKNode!
    let targetNode = SKNode()
    var firstTouch = false
    var lastSpawnTimeInterval: TimeInterval = 0
    var lastUpdateTimeInterval: TimeInterval = 0
    var upperLeg: SKNode!
    var lowerLeg: SKNode!
    var foot: SKNode!
    let upperLegAngleDeg: CGFloat = 22
    let lowerLegAngleDeg: CGFloat = -30
    var score: Int = 0
    var life: Int = 3
    
    
    override func didMove(to view: SKView) {
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
        
        
        
        lowerTorso = childNode(withName: "torso_lower")
        lowerTorso.position = CGPoint(x: frame.midX, y: frame.midY - 30)
        
        
        upperTorso = lowerTorso.childNode(withName: "torso_upper")
        upperArmFront = upperTorso.childNode(withName: "arm_upper_front")
        lowerArmFront = upperArmFront.childNode(withName: "arm_lower_front")
        
        fistFront = lowerArmFront.childNode(withName: "fist_front")
        
        let rotationConstraintArm = SKReachConstraints(lowerAngleLimit: CGFloat(0), upperAngleLimit: CGFloat(160))
        lowerArmFront.reachConstraints = rotationConstraintArm
        
        upperArmBack = upperTorso.childNode(withName: "arm_upper_back")
        lowerArmBack = upperArmBack.childNode(withName: "arm_lower_back")
        fistBack = lowerArmBack.childNode(withName: "fist_back")
        
        lowerArmBack.reachConstraints = rotationConstraintArm
        head = upperTorso.childNode(withName: "head")
        
        
        let orientToNodeConstraint = SKConstraint.orient(to: targetNode, offset: SKRange(constantValue: 0.0))
        
        let range = SKRange(lowerLimit: degreesToRadians(degrees: 50),
                            upperLimit: degreesToRadians(degrees: 80))
        
        let rotationConstraint = SKConstraint.zRotation(range)
        
        rotationConstraint.enabled = false
        orientToNodeConstraint.enabled = false
        
        head.constraints = [orientToNodeConstraint, rotationConstraint]
        
        upperLeg = lowerTorso.childNode(withName: "leg_upper_back")
        lowerLeg = upperLeg.childNode(withName: "leg_lower_back")
        foot = lowerLeg.childNode(withName: "foot_back")
        
        lowerLeg.reachConstraints = SKReachConstraints(lowerAngleLimit: degreesToRadians(degrees: -45), upperAngleLimit: 0)
        upperLeg.reachConstraints = SKReachConstraints(lowerAngleLimit: degreesToRadians(degrees: -45), upperAngleLimit: degreesToRadians(degrees: 160))
        
    }
    
    
    func getPosition(message:String) {
        sender?.message = message
        lowerTorso?.position = (sender?.postions?[0])!
        lowerTorso.alpha = CGFloat((sender?.alpha?[0])!)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !firstTouch {
            for c in head.constraints! {
                let constraint = c
                constraint.enabled = true
            }
            firstTouch = true
        }
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            lowerTorso.xScale =
                location.x < frame.midX ? abs(lowerTorso.xScale) * -1 : abs(lowerTorso.xScale)
            
            let lower = location.y < lowerTorso.position.y + 10
            if lower {
                kickAt(location)
            }
            else {
                punchAt(location)
            }
            targetNode.position = location
        }
    }
    
    func intersectionCheckAction(for effectorNode: SKNode) -> SKAction {
        let checkIntersection = SKAction.run {
            
            for object: AnyObject in self.children {
                if let node = object as? SKSpriteNode {
                }
            }
        }
        return checkIntersection
    }
    
    func kickAt(_ location: CGPoint) {
        let kick = SKAction.reach(to: location, rootNode: upperLeg, duration: 0.1)
        
        let restore = SKAction.run {
            self.upperLeg.run(SKAction.rotate(toAngle:  self.degreesToRadians(degrees: self.upperLegAngleDeg), duration: 0.1))
            self.lowerLeg.run(SKAction.rotate(toAngle: self.degreesToRadians(degrees:self.lowerLegAngleDeg), duration: 0.1))
        }
        
        let checkIntersection = intersectionCheckAction(for: foot)
        
        foot.run(SKAction.sequence([kick, checkIntersection, restore]))
    }
    
    
    func updateWithTimeSinceLastUpdate(timeSinceLast: CFTimeInterval) {
        lastSpawnTimeInterval = timeSinceLast + lastSpawnTimeInterval
        if lastSpawnTimeInterval > 0.75 {
            lastSpawnTimeInterval = 0
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        //lowerTorso?.position.y = (lowerTorso?.position.y)! + 1
        lowerTorso?.position.x = (lowerTorso?.position.x)! + 1
        
        handleSend()
        
        var timeSinceLast = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        if timeSinceLast > 1.0 {
            timeSinceLast = 1.0 / 60.0
            lastUpdateTimeInterval = currentTime
        }
        updateWithTimeSinceLastUpdate(timeSinceLast: timeSinceLast)
        
    }
    
    func handleSend(){
        let x:Double = Double(lowerTorso.position.x)
        let y:Double = Double(lowerTorso.position.y)
        
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
    
    func punchAt(_ location: CGPoint, upperArmNode: SKNode, lowerArmNode: SKNode, fistNode: SKNode) {
        let punch = SKAction.reach(to: location, rootNode: upperArmNode, duration: 0.1)
        let restore = SKAction.run {
            upperArmNode.run(SKAction.rotate(toAngle: self.degreesToRadians(degrees: self.upperArmAngleDeg), duration: 0.1))
            lowerArmNode.run(SKAction.rotate(toAngle: self.degreesToRadians(degrees: self.lowerArmAngleDeg), duration: 0.1))
        }
        let checkIntersection = intersectionCheckAction(for: fistNode)
        fistNode.run(SKAction.sequence([punch, checkIntersection, restore]))
    }
    
    func punchAt(_ location: CGPoint) {
        
        if rightPunch {
            punchAt(location, upperArmNode: upperArmFront, lowerArmNode: lowerArmFront, fistNode: fistFront)
        }
        else {
            punchAt(location, upperArmNode: upperArmBack, lowerArmNode: lowerArmBack, fistNode: fistBack)
        }
        rightPunch = !rightPunch
    }
    
    
    
    func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat(M_PI) / 180
    }
    
    func radiansToDegress(radians: CGFloat) -> CGFloat {
        return radians * 180 / CGFloat(M_PI)
    }
}


//func drawCharacter(){
//    nodes = [SKShapeNode]()
//
//    node = SKShapeNode()
//    self.addChild(node)
//
//    var torsoPoints = [CGPoint(x:0,y:0),
//                       CGPoint(x:0,y:50),
//                       CGPoint(x:0,y:100)]
//    var torso = SKShapeNode(splinePoints: &torsoPoints,
//                            count: torsoPoints.count)
//    torso.lineWidth = 10
//
//
//    let head = SKShapeNode()
//    head.path = UIBezierPath(ovalIn: CGRect(x:0, y:0, width:100, height:100)).cgPath
//    head.position = CGPoint(x: (torso.path?.currentPoint.x)! - 50, y: (torso.path?.currentPoint.y)!)//CGPoint(x:(view?.scene!.frame.midX)!-50, y:(view?.scene!.frame.midY)!-50)
//    head.fillColor = UIColor.clear
//    head.strokeColor = UIColor.white
//    head.lineWidth = 20
//
//    var leftLegPoints = [CGPoint(x:0,y:0),
//                         CGPoint(x:-10,y:-100),
//                         CGPoint(x:-10,y:-200)]
//    var leftLeg = SKShapeNode(splinePoints: &leftLegPoints,
//                              count: leftLegPoints.count)
//    leftLeg.lineWidth = 10
//
//    var rightLegPoints = [CGPoint(x:0,y:0),
//                          CGPoint(x:10,y:-100),
//                          CGPoint(x:10,y:-200)]
//    var rightLeg = SKShapeNode(splinePoints: &rightLegPoints,
//                               count: rightLegPoints.count)
//    rightLeg.lineWidth = 10
//
//    var leftArmPoints = [CGPoint(x:0,y:70),
//                         CGPoint(x:-75,y:70),
//                         CGPoint(x:-75,y:-5)]
//    var leftArm = SKShapeNode(splinePoints: &leftArmPoints,
//                              count: leftArmPoints.count)
//    leftArm.lineWidth = 10
//
//    var rightArmPoints = [CGPoint(x:0,y:70),
//                          CGPoint(x:75,y:70),
//                          CGPoint(x:150,y:70)]
//    var rightArm = SKShapeNode(splinePoints: &rightArmPoints,
//                               count: rightArmPoints.count)
//    rightArm.lineWidth = 10
//
//    node.addChild(torso)
//    node.addChild(head)
//    node.addChild(leftLeg)
//    node.addChild(rightLeg)
//    node.addChild(leftArm)
//    node.addChild(rightArm)
//
//    nodes?.append(head)
//    nodes?.append(torso)
//    nodes?.append(leftArm)
//    nodes?.append(rightArm)
//    nodes?.append(leftLeg)
//    nodes?.append(rightArm)
//
//    //        let oneRevolution = SKAction.rotate(byAngle: 360, duration: 1000)
//    //        let something = SKAction.repeatForever(oneRevolution)
//    //        node.run(something)
//
//
//}

