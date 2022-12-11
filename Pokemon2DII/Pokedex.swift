//
//  Pokedex.swift
//  Pokemon2DII
//
//  Created by Logan McMahon on 12/10/22.
//

import UIKit
import SpriteKit
import GameplayKit


class Pokedex: SKScene{
    
    var entities = [GKEntity]()
    var poken = ""
    let cam = SKCameraNode()
    var hud = SKNode()
    
    private var lastUpdateTime : TimeInterval = 0
    private var player: Player?
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    
    override func didMove(to view: SKView) {
        player = childNode(withName: "player") as? Player
        //player?.move(.stop)
        let xRange = SKRange(lowerLimit: -480, upperLimit: 10000)
        let yRange = SKRange(lowerLimit: -660, upperLimit: 680)
        let constraint = SKConstraint.positionX(xRange, y: yRange)
        player?.constraints = [constraint]
        
        self.camera = cam
        self.addChild(cam)
        hud = childNode(withName: "HUD")!
        hud.removeFromParent()
        cam.addChild(hud)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        print("touch down")
        let nodeAtPoint = atPoint(pos)
        if let touchedNode = nodeAtPoint as? SKSpriteNode{
            if touchedNode.name?.starts(with: "controller_") == true{
                let direction = touchedNode.name?.replacingOccurrences(of: "controller_", with: "")
                player?.move(Direction(rawValue: direction ?? "stop")!)
            }
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
        cam.position = player!.position
    }

}
