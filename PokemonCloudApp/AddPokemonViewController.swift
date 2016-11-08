//
//  AddPokemonViewController.swift
//  PokemonCloudApp
//
//  Created by rem{e}koh on 11/8/16.
//  Copyright © 2016 rem{e}koh. All rights reserved.
//

import UIKit
import  MapKit
import CloudKit

protocol AddPokemonViewControllerDelegate: class {
    
    func addPokemonViewControllerDelegateDidAddPokemon(pokemon: Pokemon)
    
}



class AddPokemonViewController: UIViewController {
    
    @IBOutlet weak var newPokemonName : UITextField!
    @IBOutlet weak var newPokemonImage : UITextField!
    @IBOutlet weak var pokemonLocationLatitiude: UITextField!
    @IBOutlet weak var pokemonLocationLongitude: UITextField!
    
    var coordinate: CLLocationCoordinate2D!
    
    weak var delegate: AddPokemonViewControllerDelegate!
    
    var container :CKContainer!
    var publicDB :CKDatabase!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.container = CKContainer.default()
        self.publicDB = self.container.publicCloudDatabase
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addNewPokemonButtonWasPressed(_ sender: AnyObject) {
        
       
        
        let pokemonRecord = CKRecord(recordType: "Pokemon")
        
//        pokemonRecord.setValue("Pokemon", forKey: "Name")
        
        pokemonRecord.setValue(newPokemonName.text, forKey: "Name")
        pokemonRecord.setValue(newPokemonImage.text, forKey: "ImageURL")
        pokemonRecord.setValue(Double(pokemonLocationLatitiude.text!), forKey: "Latitude")
        pokemonRecord.setValue(Double(pokemonLocationLongitude.text!), forKey: "Longitude")
        
        
        self.publicDB.save(pokemonRecord) { (record : CKRecord?, error : Error?) in
        
            print(record)
            
        }
         self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelButtonWasPressed(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
