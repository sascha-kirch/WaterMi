//
//  Plant.swift
//  WaterMi
//
//  Created by Sascha on 21.10.20.
//

import UIKit

class Plant {
    var name : String
    var image : UIImage

    init(name: String, image: UIImage = UIImage(systemName: "leaf")!) {
        self.name = name
        self.image = image
    }
}
