//
//  PokeAnnotation.swift
//  Fake Pokemon
//
//  Created by Michael Zielinski on 3/31/17.
//  Copyright © 2017 Worldengine. All rights reserved.
//

import UIKit
import MapKit


//* custom subclass for MKAnnotation with Pokemon object
class PokeAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon : Pokemon
    init(coord : CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coord
        self.pokemon = pokemon
    }
}
