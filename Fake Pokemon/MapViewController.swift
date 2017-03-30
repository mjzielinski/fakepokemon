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
    
    var updateFlag = true
    
    //* manages user's location
    var manager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    

    
    
}

