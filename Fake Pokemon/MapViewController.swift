//
//  MapViewController.swift
//  Fake Pokemon
//
//  Created by Michael Zielinski on 3/30/17.
//  Copyright © 2017 Worldengine. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    //* does the user's location need to be updated?
    var updateFlag = true
    
    
    //* manages user's location
    var manager = CLLocationManager()
    
    //* array to hold Pokemon objects
    var pokemons : [Pokemon] = []
    var rarePokemons : [Pokemon] = []
    var commonPokemons : [Pokemon] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //* update the user's location on view
        updateFlag = true
        
        //* populate array with all Pokemon objects from core data
        pokemons = getAllPokemon()
        print("@@@\(pokemons.count)")
        
        //* make arrays of rare and common pokemons
        rarePokemons = getRarePokemon(allPokemon: pokemons)
        commonPokemons = getCommonPokemon(allPokemon: pokemons)
        
        manager.delegate = self
        
        //* once authorized start updating user location
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            print("map authorization received previously")
            mapView.delegate = self
            
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
            
            
        } else {
            manager.requestWhenInUseAuthorization()
            print("map authorization received in prompt")
            mapView.delegate = self
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
        }
        
      
        //* randomly spawn fake pokemon

        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: { (timer) in
            
            if let coord = self.manager.location?.coordinate {
                
                //* randomly select rare or common pokemon
                var pokemon : Pokemon
                let rareOrCommon = arc4random_uniform(10)
                if rareOrCommon < 8 {
                    //* choose common pokemon
                    pokemon = self.commonPokemons[Int(arc4random_uniform(UInt32(self.commonPokemons.count)))]
                } else {
                    //* choose rare pokemon
                    pokemon = self.rarePokemons[Int(arc4random_uniform(UInt32(self.rarePokemons.count)))]
                }
                
                
                let annotation = PokeAnnotation(coord: coord, pokemon: pokemon)
                let randomLat = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                let randomLong = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                annotation.coordinate.latitude += randomLat
                annotation.coordinate.longitude += randomLong
                self.mapView.addAnnotation(annotation)
                
            }
        })
        
        
    }
    
    
    
    //* allow different image to appear instead of pin for annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //* specify image for User Location Annotation
        if annotation is MKUserLocation {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annotationView.image = UIImage(named: "player")
            var frame = annotationView.frame
            frame.size.height = 50
            frame.size.width = 50
            annotationView.frame = frame
            return annotationView
        }
        
        //* specify image for other Annotations as pokemon
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        let pokemon = (annotation as! PokeAnnotation).pokemon
        
        annotationView.image = UIImage(named: pokemon.image!)
        
        //* frame to set size for annotation view
        var frame = annotationView.frame
        frame.size.height = 50
        frame.size.width = 50
        annotationView.frame = frame
        
        return annotationView
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
    
    //* action for tapping on an annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        mapView.deselectAnnotation(view.annotation!, animated: true)
        
        if view.annotation is MKUserLocation {
            return
        }
        
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if let coord = self.manager.location?.coordinate {
                
                let pokemon = (view.annotation as! PokeAnnotation).pokemon
                
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
                    print("able to catch")
                    pokemon.caught = true
                    pokemon.number += 1
                    
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    mapView.removeAnnotation(view.annotation!)
                    
                    
                    let alertVC = UIAlertController(title: "Caught!", message: "\(pokemon.name!) has been caught!", preferredStyle: .alert)
                    let pokedexAction = UIAlertAction(title: "Pokedex", style: .default, handler: { (action) in
                        self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                    })
                    
                    let OKaction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        //recenter view
                        if let coord = self.manager.location?.coordinate {
                            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
                            mapView.setRegion(region, animated: true)
                        }
                    })
                    alertVC.addAction(pokedexAction)
                    alertVC.addAction(OKaction)
                    
                    self.present(alertVC, animated: true, completion: nil)
                    
                    
                    
                    
                    
                } else {
                    
                    let alertVC = UIAlertController(title: "Too Far Away", message: "\(pokemon.name!) is too far away to catch!", preferredStyle: .alert)
                    let OKaction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        //recenter view
                        if let coord = self.manager.location?.coordinate {
                            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
                            mapView.setRegion(region, animated: true)
                        }
                    })
                    alertVC.addAction(OKaction)
                    self.present(alertVC, animated: true, completion: nil)
                    
                    print("too far away")
                }
            }
            
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
