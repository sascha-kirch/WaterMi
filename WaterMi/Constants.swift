//
//  Constants.swift
//  WaterMi
//
//  Created by Sascha on 21.10.20.
//

import Foundation

/**Contants in order to avoid string typos */
struct WMConstant {
    
    struct CustomCell{
        static let plantCellIdentifier = "ReusablePlantCell"
        static let plantCellNibName = "PlantCell"
        static let feedbackCellIdentifier = "ReusableFeedbackCell"
        static let feedbackCellNibName = "FeedbackCell"
        static let adCellIdentifier = "ReusableAdCell"
        static let adCellNibName = "AdCell"
    }
    
    struct SegueID {
        static let addPlantView = "GoToAddPlantView"
        static let plantDetailsView = "GoToPlantDetailsView"
        static let feedbackViewController = "GoToFeedbackViewController"
    }
    
    struct StoryBoardID {
        static let PlantDetailsViewController = "PlantDetailsViewController"
    }
    
}
