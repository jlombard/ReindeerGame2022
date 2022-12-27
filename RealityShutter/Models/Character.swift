//
//  Character.swift
//  RealityShutter
//
//  Created by Sergen Gönenç on 21/12/2022.
//

import UIKit

struct Character {
    let name: String
    let sceneName: String
    let image: UIImage
    
    init(name: String, sceneName: String, image: UIImage) {
        self.name = name
        self.sceneName = sceneName
        self.image = image
    }
    
    // Convenience initializer, to be used if 'sceneName' is equal to 'name'
    init(name: String, image: UIImage) {
        self.name = name
        self.sceneName = name
        self.image = image
    }
    
    init() {
        name = ""
        sceneName = ""
        image = UIImage()
    }
}
