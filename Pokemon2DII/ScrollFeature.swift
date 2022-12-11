//
//  ScrollFeature.swift
//  Pokemon2DII
//
//  Created by Logan McMahon on 12/10/22.
//

import Foundation
import SpriteKit

enum Directions: String {
    case stop
    case left
    case right
}


class ScrollFeature: SKSpriteNode{
        
        func move(_ direction: Directions){
            
            switch direction{
            case .left:
                self.physicsBody?.velocity = CGVector(dx:-100, dy: 0)
            case .right:
                self.physicsBody?.velocity = CGVector(dx:100, dy: 0)
            case .stop:
                stop()
            }
        }
    
        func stop(){
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
    
    func setupConstrains(){
        let xRange = SKRange(lowerLimit: 0, upperLimit: 30200)
        let yRange = SKRange(lowerLimit: 0, upperLimit: 0)
        let constraint = SKConstraint.positionX(xRange, y: yRange)
        self.constraints = [constraint]
    }
    
}
