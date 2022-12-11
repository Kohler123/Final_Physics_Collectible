//
//  CollectiblePokemon.swift
//  Pokemon2DII
//
//  Created by Logan McMahon on 12/8/22.
//

import Foundation
import SpriteKit

class CollectiblePokemon:SKSpriteNode{
   var pokeID = 0
    var start = 0
    var picture = ""
    
    
    init(){
        // set default texture
        let randomInt = Int.random(in: 1..<151)
        self.pokeID = randomInt
        if (randomInt < 100 && randomInt > 9) {
            picture = "0" + String(randomInt)
        }
        else if (randomInt < 10) {
            picture = "00" + String(randomInt)
        }
        else {
            picture = String(randomInt)
        }
        
        let texture = SKTexture(imageNamed: picture)
        
        // call to super.init
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.name = "pokemon"
        self.setScale(0.5)
        self.anchorPoint = CGPoint(x: 0.5, y:0.5)
        self.zPosition = Layer.pokemon.rawValue
        
        // add physics body
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size, center: CGPoint(x: 0.0, y: -self.size.height / 2))
        self.physicsBody?.affectedByGravity = false
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.pokemon
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        
    }
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    func collected(){
        let removeFromParent = SKAction.removeFromParent()
        self.run(removeFromParent)
        var apiData:APIData = APIData(PokemonID: pokeID)
        apiData.fetchNew(PokemonID: pokeID)
        sleep(1)
        
        print(apiData.pokemonName)
        GameScene.names.append(apiData.pokemonName)
        start += 1
        
        GameScene.pics.append(picture)
    }
}
