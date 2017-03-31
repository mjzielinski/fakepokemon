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
    
    createPokemon(name: "Abra", image: "abra", rare: false)
    createPokemon(name: "BellSprout", image: "bellsprout", rare: false)
    createPokemon(name: "Bullbasaur", image: "bullbasaur", rare: false)
    createPokemon(name: "Caterpie", image: "caterpie", rare: false)
    createPokemon(name: "Charmander", image: "charmander", rare: false)
    createPokemon(name: "Dratini", image: "dratini", rare: false)
    createPokemon(name: "Eevee", image: "eevee", rare: false)
    createPokemon(name: "Jigglypuff", image: "jigglypuff", rare: false)
    createPokemon(name: "Mankey", image: "mankey", rare: false)
    createPokemon(name: "Meowth", image: "meowth", rare: false)
    createPokemon(name: "Mew", image: "mew", rare: true)
    createPokemon(name: "Pidgey", image: "pidgey", rare: true)
    createPokemon(name: "Pikachu", image: "pikachu", rare: true)
    createPokemon(name: "Psyduck", image: "psyduck", rare: false)
    createPokemon(name: "Ratta", image: "ratta", rare: false)
    createPokemon(name: "Snorlax", image: "snorlax", rare: true)
    createPokemon(name: "Squirtle", image: "squirtle", rare: false)
    createPokemon(name: "Squirtle", image: "squirtle", rare: false)
    createPokemon(name: "Weedle", image: "weedle", rare: false)
    createPokemon(name: "Zubat", image: "zubat", rare: false)
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}

//* create a pokemon
func createPokemon(name: String, image: String, rare: Bool) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.image = image
    pokemon.rare = rare
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

//* returns an array of all common Pokemon
func getCommonPokemon(allPokemon: [Pokemon]) -> [Pokemon] {
    var commonPokemon : [Pokemon] = []
    
    for poke in allPokemon {
        if !poke.rare {
            commonPokemon.append(poke)
        }
    }
    return commonPokemon
}

//* returns an array of all rare Pokemon
func getRarePokemon(allPokemon: [Pokemon]) -> [Pokemon] {
    var rarePokemon : [Pokemon] = []
    
    for poke in allPokemon {
        if poke.rare {
            rarePokemon.append(poke)
        }
    }
    return rarePokemon
}
