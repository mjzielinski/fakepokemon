//
//  MapViewController.swift
//  Fake Pokemon
//
//  Created by Michael Zielinski on 3/30/17.
//  Copyright © 2017 Worldengine. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    //* does the user's location need to be updated?
    var updateFlag = true
    
    
    //* manages user's location
    var manager = CLLocationManager()
    
    //* array to hold Pokemon objects
    var pokemons : [Pokemon] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //* update the user's location on view
        updateFlag = true
        
        //* populate array with all Pokemon objects from core data
        pokemons = getAllPokemon()
        print("@@@\(pokemons.count)")
        
        manager.delegate = self
        
        //* once authorized start updating user location
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            print("map authorization received")
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
            
            //* randomly spawn fake pokemon
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
                
                if let coord = self.manager.location?.coordinate {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coord
                    let randomLat = (Double(arc4random_uniform(200)) - 100.0) / 80000.0
                    let randomLong = (Double(arc4random_uniform(200)) - 100.0) / 80000.0
                    annotation.coordinate.latitude += randomLat
                    annotation.coordinate.longitude += randomLong
                    self.mapView.addAnnotation(annotation)
                    
                }
            })
            
            
        } else {
            manager.requestWhenInUseAuthorization()
            print("map authorization received in prompt")
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
        }
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //* when first open, get the region and set the map view
        if updateFlag {
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 200, 200)
            mapView.setRegion(region, animated: false)
            updateFlag = false
        } else {
            //* once these have been set, stop updating the location
            manager.stopUpdatingLocation()
        }
    }
    
    
    @IBAction func compassTapped(_ sender: Any) {
        
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
            mapView.setRegion(region, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! PokedexViewController
        
        nextVC.pokemons = pokemons
    }
    
    
}

