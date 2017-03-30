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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
