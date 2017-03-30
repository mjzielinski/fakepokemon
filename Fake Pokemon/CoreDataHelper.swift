//
//  CoreDataHelper.swift
//  Fake Pokemon
//
//  Created by Michael Zielinski on 3/30/17.
//  Copyright © 2017 Worldengine. All rights reserved.
//

import UIKit
import CoreData

//* adds all pokemon to core data
func addAllPokemon() {
    createPokemon(name: "BellSprout", image: "bellsprout")
    createPokemon(name: "Charmander", image: "charmander")
    createPokemon(name: "Dratini", image: "dratini")
    createPokemon(name: "Eevee", image: "eevee")
    createPokemon(name: "Pikachu", image: "pikachu")
    createPokemon(name: "Psyduck", image: "psyduck")
    createPokemon(name: "Snorlax", image: "snorlax")
    createPokemon(name: "Squirtle", image: "squirtle")
    createPokemon(name: "Weedle", image: "weedle")
    createPokemon(name: "Zubat", image: "zubat")
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}

//* create a pokemon
func createPokemon(name: String, image: String) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.image = image
}

//* returns an array of all Pokemon from core data
func getAllPokemon() -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    do {
        let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        
        if pokemons.count == 0 {
            addAllPokemon()
            return getAllPokemon()
        }
        
        return pokemons
    } catch {}
    
    return []
}


//* returns an array of all caught Pokemon
func getCaughtPokemon(allPokemon: [Pokemon]) -> [Pokemon] {
    
    var caughtPokemon : [Pokemon] = []
    
    for poke in allPokemon {
        if poke.caught {
            caughtPokemon.append(poke)
        }
    }
    return caughtPokemon
}


//* returns an array of all uncaught Pokemon
func getUncaughtPokemon(allPokemon: [Pokemon]) -> [Pokemon] {
    var uncaughtPokemon : [Pokemon] = []
    
    for poke in allPokemon {
        if !poke.caught {
            uncaughtPokemon.append(poke)
        }
    }
    
    return uncaughtPokemon
}
