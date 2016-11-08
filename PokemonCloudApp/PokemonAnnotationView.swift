//
//  PokemonAnnotationView.swift
//  PokemonCloudApp
//
//  Created by rem{e}koh on 11/8/16.
//  Copyright © 2016 rem{e}koh. All rights reserved.
//

import UIKit
import MapKit

class PokemonAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        setupAnnotationView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAnnotationView() {
        
        self.frame.size = CGSize(width: 60, height: 60)
        self.centerOffset = CGPoint(x: -5, y: -5)
        
        let imageView = UIImageView(image: UIImage(named: "Pokemon"))
        imageView.frame = self.frame
        self.addSubview(imageView)
        
    }


}
