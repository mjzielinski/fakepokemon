//
//  PokedexViewController.swift
//  Fake Pokemon
//
//  Created by Michael Zielinski on 3/30/17.
//  Copyright © 2017 Worldengine. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    //* holds all Pokemon objects passed from previous VC
    var pokemons : [Pokemon] = []
    
    //* will hold all Pokemon objects with status of caught
    var caughtPokemon : [Pokemon] = []
    
    //* will hold all Pokemon objecst with status of uncaught
    var uncaughtPokemon : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self


        caughtPokemon = getCaughtPokemon(allPokemon: pokemons)
        caughtPokemon.sort {
            $0.name! < $1.name!
        }
        uncaughtPokemon = getUncaughtPokemon(allPokemon: pokemons)
        uncaughtPokemon.sort {
            $0.name! < $1.name!
        }
        print("***\(uncaughtPokemon.count)")
        print("$$$\(caughtPokemon.count)")
        
       
    }
    
    //* specify number of rows for each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return caughtPokemon.count
        } else {
            return uncaughtPokemon.count
        }
    }

    //* fill in the content for each row at index path
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        var pokemon = Pokemon()
        
        if indexPath.section == 0 {
            pokemon = caughtPokemon[indexPath.row]
            cell.textLabel?.text = "\(pokemon.name!) (\(pokemon.number))"
        } else {
            pokemon = uncaughtPokemon[indexPath.row]
            cell.textLabel?.text = "\(pokemon.name!)"
        }

        
        cell.imageView?.image = UIImage(named: pokemon.image!)
        return cell
    }
    
    //* specify the number of sections in the tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //* specify the title for header of each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //* sections are numbers starting from zero
        if section == 0 {
            return "Caught"
        } else {
            return "Uncaught"
        }
    }
    
    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
