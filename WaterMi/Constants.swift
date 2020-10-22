//
//  Constants.swift
//  WaterMi
//
//  Created by Sascha on 21.10.20.
//

import Foundation

/**Contants in order to avoid string typos */
struct WMConstant {
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "PlantCell"
    
    struct SegueID{
        static let addPlantView = "GoToAddPlantView"
        static let plantDetailsView = "GoToPlantDetailsView"
    }
    
    struct StoryBoardID {
        static let PlantDetailsViewController = "PlantDetailsViewController"
    }
    
}
