//
//  GameScene.swift
//  Pokemon2DII
//
//  Created by SI CHEN on 11/9/22.
//
import SwiftUI
import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    let cam = SKCameraNode()
    var hud = SKNode()
    public static var names = [String]()
    public static var pics = [String]()
    
    
    private var lastUpdateTime : TimeInterval = 0
    private var player: Player?
    
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        player = childNode(withName: "player") as? Player
        //player?.move(.stop)
        player?.setupConstrains()
        spawnMultiplePoke()
        self.camera = cam
        self.addChild(cam)
        hud = childNode(withName: "HUD")!
        hud.removeFromParent()
        cam.addChild(hud)
    }
    
    func collected(){
        let removeFromParent = SKAction.removeFromParent()
        self.run(removeFromParent)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
                let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
                
                if collision == PhysicsCategory.player | PhysicsCategory.pokemon{
                    let body = contact.bodyA.categoryBitMask == PhysicsCategory.pokemon ? contact.bodyA.node : contact.bodyB.node
                    
                    if let sprite = body as? CollectiblePokemon{
                        sprite.collected()
                    }
                }
            }
    
    func loadPokedex(){
        let scene = SKScene(fileNamed: "Pokedex")
        scene?.scaleMode = .aspectFill

        var apiData:APIData = APIData(PokemonID: 1)
        apiData.fetchNew(PokemonID: 151)
        sleep(1)
        
        print(apiData.pokemonName)
        print(apiData.base_exp)
        print(apiData.capture_rate)
        
       // let name = apiData.pokemonName
      /*  let name = GameScene.names
        let pokemonName = SKLabelNode(fontNamed: "Chalkduster")
        let nameArray = GameScene.names.joined(separator: "    ")
        pokemonName.text = nameArray
        pokemonName.fontSize = 65
        pokemonName.fontColor = SKColor.red
        pokemonName.position = CGPoint(x: frame.midX, y: frame.midY)
        scene?.addChild(pokemonName)*/
        
        for (i, pic) in (GameScene.pics).enumerated() {
            let node = SKSpriteNode(imageNamed: pic)
            let num = i * 200
            let nameNode = SKLabelNode(fontNamed: "Chalkduster")
    
            node.position = CGPoint(x: frame.minX + CGFloat(num) + CGFloat(50), y: frame.midY)
            scene?.addChild(node)
            nameNode.text = GameScene.names[i]
            scene?.addChild(nameNode)
            nameNode.position = CGPoint(x: frame.minX + CGFloat(num) + CGFloat(50), y: frame.midY - CGFloat(150))
        }

        
        
        self.view?.presentScene(scene)
        
       /* let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOver = Pokedex(size: self.size)
        let skview = self.view!
        skview.presentScene(gameOver, transition: transition) */

    }
    
    func spawnPokemon(){
       // let collectible = Collectible(collectibleType: CollectibleType.fruit)
        let poke = CollectiblePokemon()
        // set random position
        spawnPokemonEntity(node: poke)
    }
    
    func calculateArea() -> CGRect{
        let nuuu = self.childNode(withName: "background")
        let accumulatedFrame = nuuu?.calculateAccumulatedFrame()
        return CGRect(x: accumulatedFrame?.origin.x ?? 0, y: accumulatedFrame?.origin.y ?? 0, width: accumulatedFrame?.width ?? 0, height: accumulatedFrame?.height ?? 0)
    }
    
    
    func spawnPokemonEntity(node: SKSpriteNode) {
        let area = calculateArea()
        let margin = 20.0
        //CGRect(x: -1000, y: -1400, width: 1000, height: 1400)
        let randomX = CGFloat.random(in: area.minX+margin...area.maxX-margin)
        let randomY = CGFloat.random(in: area.minY+margin...area.maxY-margin)
        node.position = CGPoint(x: randomX, y: randomY)
        addChild(node)
        print()
    }
    
    func spawnMultiplePoke(){
        // set up repeating action
        let wait = SKAction.wait(forDuration: TimeInterval(3.0))
        let spawn = SKAction.run {
            self.spawnPokemon()
        }
        let sequence = SKAction.sequence([wait, spawn])
        let repeatAction = SKAction.repeatForever(sequence)
        run(repeatAction, withKey: "pokemon")
    }
    
    func touchDown(atPoint pos : CGPoint) {
        print("touch down")
        let nodeAtPoint = atPoint(pos)
        if let touchedNode = nodeAtPoint as? SKSpriteNode{
            if touchedNode.name?.starts(with: "controller_") == true{
                let direction = touchedNode.name?.replacingOccurrences(of: "controller_", with: "")
                player?.move(Direction(rawValue: direction ?? "stop")!)
            }
            else if touchedNode.name?.starts(with: "menu") == true{
                print("You touched the menu button!")
                loadPokedex()
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
