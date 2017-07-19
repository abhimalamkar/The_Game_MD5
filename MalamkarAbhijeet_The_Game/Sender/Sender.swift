//
//  Sender.swift
//  MalamkarAbhijeet_The_Game
//
//  Created by Abhijeet Malamkar on 7/13/17.
//  Copyright © 2017 abhijeetmalamkar. All rights reserved.
//

import UIKit
import SpriteKit

class Sender{
    
    var postions:[CGPoint]?
    var alpha:[Int]?
    
    init(postions:[CGPoint],alpha:[Int]) {
        self.alpha = alpha
        self.postions = postions
    }
    
    var message:String  {
        get {
            var msg = ""
            for (index,pos) in postions!.enumerated() {
                if(index==(postions?.count)!-1) {
                    msg.append(pos.x.description + "," + pos.y.description + ",")
                    msg.append(alpha![index].description + "/")
                } else {
                    msg.append(pos.x.description + "," + pos.y.description)
                }
            }
            return msg
        }
        set {
            let positionStrings = newValue.split(separator: "/")
            postions = [CGPoint]()
            alpha = [Int]()
            for pos in positionStrings {
                let points:[String] = pos.characters.split{$0 == ","}.map(String.init)
                 if let x = Double(points[0]), let y = Double(points[1]), let alpha_ = Int(points[2]){
                    postions?.append(CGPoint(x: x, y: y))
                    alpha?.append(alpha_)
                }
            }
        }
    }
    
}
