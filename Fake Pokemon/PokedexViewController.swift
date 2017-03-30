//
//  PokedexViewController.swift
//  Fake Pokemon
//
//  Created by Michael Zielinski on 3/30/17.
//  Copyright © 2017 Worldengine. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //* holds all Pokemon objects passed from previous VC
    var pokemons : [Pokemon] = []
    
    //* will hold all Pokemon objects with status of caught
    var caughtPokemon : [Pokemon] = []
    
    //* will hold all Pokemon objecst with status of uncaught
    var uncaughtPokemon : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        caughtPokemon = getCaughtPokemon(allPokemon: pokemons)
        uncaughtPokemon = getUncaughtPokemon(allPokemon: pokemons)
        print("***\(uncaughtPokemon.count)")
        print("$$$\(caughtPokemon.count)")
    }

    
    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
