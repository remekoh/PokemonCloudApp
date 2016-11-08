//
//  MapsViewController.swift
//  PokemonCloudApp
//
//  Created by rem{e}koh on 11/8/16.
//  Copyright © 2016 rem{e}koh. All rights reserved.
//

import UIKit
import MapKit
import CloudKit

class MapsViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate,AddPokemonViewControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    
    var container :CKContainer!
    var publicDB : CKDatabase!
    
    var pokemons = [Pokemon]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        
        self.locationManager.delegate = self
        
        self.locationManager.requestAlwaysAuthorization()
        
        self.mapView.showsUserLocation = true
        
        self.mapView.delegate = self
        
        self.locationManager.startUpdatingLocation()
        
        processQuery()
        
    }
    

    func addPokemonLocation(){
        
        for pokemon in pokemons {
        
            let pokemonAnnotation = PokemonAnnotation()
            pokemonAnnotation.title = pokemon.name
            pokemonAnnotation.coordinate = CLLocationCoordinate2DMake(pokemon.latitude, pokemon.longitude)
            pokemonAnnotation.imageURL = pokemon.imageURL
            
            DispatchQueue.main.async {
                self.mapView.addAnnotation(pokemonAnnotation)
                
            }
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            
            let currentAnnotation = annotation as! PokemonAnnotation
            //
            //            let currentAnnotationPhoto = currentAnnotation.accessibilityLabel
            
            let photoURL = URL(string: currentAnnotation.imageURL!)
            
            //Data(contentsOf: <#T##URL#>)
            
            let imageData = try? Data(contentsOf: photoURL!)
            
            //            let imageData = try! Data(contentsOf: URL(string: pokemon.imageURL)!)
            
            var pokemonAnnotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "PokemonAnnotationView")
            
            if pokemonAnnotationView == nil {
                pokemonAnnotationView = PokemonAnnotationView(annotation: annotation, reuseIdentifier: "PokemonAnnotatonView")
            }
            
            pokemonAnnotationView?.canShowCallout = true
            
            let pokemonImageView = UIImageView(image: UIImage(data: imageData!))
            
            pokemonImageView.frame.size = CGSize(width: 50, height: 50)
            
            pokemonAnnotationView?.addSubview(pokemonImageView)
            
            return pokemonAnnotationView
            
        }
    }

    
    func processQuery() {
        
        self.pokemons = [Pokemon]()
        self.container = CKContainer.default()
        self.publicDB = self.container.publicCloudDatabase
        
        let query = CKQuery(recordType: "Pokemon", predicate: NSPredicate(value: true))
        
        self.publicDB.perform(query, inZoneWith: nil){ (records: [CKRecord]?, error :Error?) in
            
            if error != nil {
                
                print("Something bad happened")
                print(error?.localizedDescription)
                
            } else {
                
                for record in records! {
                    
                    let pokemon = Pokemon()
                    pokemon.name = record["Name"] as! String
                    pokemon.imageURL = record["ImageURL"] as! String
                    pokemon.latitude = record["Latitude"] as! Double
                    pokemon.longitude = record["Longitude"] as! Double
                    
                    self.pokemons.append(pokemon)
                    
                    // create annotation
                    
                    
                }
                
                
            }
            
            self.addPokemonLocation()
            
        }
        
    } 
    
    func addPokemonViewControllerDelegateDidAddPokemon(pokemon: Pokemon) {
        
        self.pokemons.append(pokemon)
        let pokemonAnnotation = PokemonAnnotation()
        pokemonAnnotation.title = pokemon.name
        pokemonAnnotation.coordinate = CLLocationCoordinate2DMake(pokemon.latitude, pokemon.longitude)
        pokemonAnnotation.imageURL = pokemon.imageURL
        
        DispatchQueue.main.async {
            self.mapView.addAnnotation(pokemonAnnotation)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
        let addPokemonVC = segue.destination as? AddPokemonViewController
        addPokemonVC?.delegate = self
        
        addPokemonVC?.coordinate = self.locationManager.location?.coordinate
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

}
