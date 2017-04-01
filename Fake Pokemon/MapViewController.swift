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
    
    //* outlet to map view
    @IBOutlet weak var mapView: MKMapView!
    
    //* does the user's location need to be updated?
    var updateFlag = true
    
    //* manages user's location
    var manager = CLLocationManager()
    
    
    //* array to hold Pokemon objects
    var pokemons : [Pokemon] = []
    
    //* array to hold rare Pokemon objects
    var rarePokemons : [Pokemon] = []
    
    //* array to hold common Pokemon objects
    var commonPokemons : [Pokemon] = []
    
    //* timer for pokemon spawning
    var pokeTimer = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        
        //* update the user's location on view
        updateFlag = true
        
        //* populate array with all Pokemon objects from core data
        pokemons = getAllPokemon()
        
        //* make arrays of rare and common pokemons
        rarePokemons = getRarePokemon(allPokemon: pokemons)
        commonPokemons = getCommonPokemon(allPokemon: pokemons)
        
        //* once authorized start updating user location
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.delegate = self
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
        } else {
            manager.requestWhenInUseAuthorization()
            mapView.delegate = self
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
        }
        
        
        //* run random spawn timer every ten seconds
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: { (timer) in
            //* generate random number for second timer
            self.pokeTimer = Double(arc4random_uniform(50) + 1)
            //* random spawn timer
            Timer.scheduledTimer(withTimeInterval: self.pokeTimer, repeats: false, block: { (timer) in
                if let coord = self.manager.location?.coordinate {
                    var pokemon : Pokemon
                    
                    //* randomly select rare or common pokemon
                    let rareOrCommon = arc4random_uniform(10)
                    if rareOrCommon < 8 {
                        //* choose common pokemon
                        pokemon = self.commonPokemons[Int(arc4random_uniform(UInt32(self.commonPokemons.count)))]
                    } else {
                        //* choose rare pokemon
                        pokemon = self.rarePokemons[Int(arc4random_uniform(UInt32(self.rarePokemons.count)))]
                    }
                    
                    //* create the pokemon at random spot near the user
                    let annotation = PokeAnnotation(coord: coord, pokemon: pokemon)
                    let randomLat = (Double(arc4random_uniform(200)) - 100.0) / 60000.0
                    let randomLong = (Double(arc4random_uniform(200)) - 100.0) / 60000.0
                    annotation.coordinate.latitude += randomLat
                    annotation.coordinate.longitude += randomLong
                    self.mapView.addAnnotation(annotation)
                    
                    //* remove the pokemon after 5 seconds
                    Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { (timer) in
                        self.mapView.removeAnnotation(annotation)
                    })
                }
            })
        })
    }
    
    //* allows different image to appear instead of pin for annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //* specify image for User Location Annotation
        if annotation is MKUserLocation {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annotationView.image = UIImage(named: "player")
            //* frame to set size for annotation view
            var frame = annotationView.frame
            frame.size.height = 50
            frame.size.width = 50
            annotationView.frame = frame
            return annotationView
        }
        
        //* otherwise specify image for other Annotations as pokemon
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
    
    //* runs update for location manager
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
        //* if user icon is tapped, do nothing
        if view.annotation is MKUserLocation {
            return
        }
        
        //* re-center map on pokemon tapped
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
        mapView.setRegion(region, animated: true)
        
        //* used timer to account for lag in re-centering view on pokemon
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if let coord = self.manager.location?.coordinate {
                
                let pokemon = (view.annotation as! PokeAnnotation).pokemon
                //* if user in the same view as pokemon, successful catch
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
                    //* update this pokemon status in core data and remove annotation
                    pokemon.caught = true
                    pokemon.number += 1
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    mapView.removeAnnotation(view.annotation!)
                    
                    //* send an alert to tell user they caught the pokemon
                    let alertVC = UIAlertController(title: "Caught!", message: "\(pokemon.name!) has been caught!", preferredStyle: .alert)
                    //* action for Pokedex action in Alert
                    let pokedexAction = UIAlertAction(title: "Pokedex", style: .default, handler: { (action) in
                        self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                    })
                    //* action for OK action in Alert
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
                    //* otherwise send an alert to tell user the pokemon is too far away
                    let alertVC = UIAlertController(title: "Too Far Away", message: "\(pokemon.name!) is too far away to catch!", preferredStyle: .alert)
                    //* action for OK action in alert
                    let OKaction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        //recenter view
                        if let coord = self.manager.location?.coordinate {
                            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
                            mapView.setRegion(region, animated: true)
                        }
                    })
                    alertVC.addAction(OKaction)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    //* action for compass tapped
    @IBAction func compassTapped(_ sender: Any) {
        //* recenter view on user
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
            mapView.setRegion(region, animated: true)
        }
    }
    
    //* prepare for segue, sends pokemon data to next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! PokedexViewController
        nextVC.pokemons = pokemons
    }
}
