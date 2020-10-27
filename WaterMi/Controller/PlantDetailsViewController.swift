//
//  PlantDetailsViewController.swift
//  WaterMi
//
//  Created by Sascha on 21.10.20.
//

import UIKit

final class PlantDetailsViewController: UIViewController {

    var selectedPlant: String?
    var selectedPlantImage: UIImage?
    
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var plantImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.plantNameLabel.text = selectedPlant
        self.plantImageView.image = selectedPlantImage
        
        // crate round image View!!
        plantImageView.layer.borderWidth = 1
        plantImageView.layer.masksToBounds = false
        plantImageView.layer.borderColor = UIColor.black.cgColor
        plantImageView.layer.cornerRadius = plantImageView.frame.size.width/2
        plantImageView.clipsToBounds = true
    }

    //MARK: - Preview Functionality
    
    /**Shows action items that can be performed when the preview is entered!*/
    override var previewActionItems : [UIPreviewActionItem] {
            
            let action1 = UIPreviewAction(title: "Option 1", style: .default) { (action, viewController) -> Void in
                print("action1 pressed")
            }
            
            let action2 = UIPreviewAction(title: "Option 2", style: .destructive) { (action, viewController) -> Void in
                print("action2 pressed")
            }
            
            return [action1, action2]
            
        }
}


//MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI

extension PlantDetailsViewController: UIViewControllerRepresentable {
    
  func makeUIViewController(context: Context) -> PlantDetailsViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
      guard let viewController =  storyboard.instantiateViewController(
                identifier: WMConstant.StoryBoardID.PlantDetailsViewController) as? PlantDetailsViewController else {
          fatalError("Cannot load from storyboard")
      }
    viewController.selectedPlant = "TestPlant"
    viewController.selectedPlantImage = UIImage(named: "olivio")
      // Configure the view controller here
      return viewController
  }

  func updateUIViewController(_ uiViewController: PlantDetailsViewController,
    context: Context) {
  }
}

struct PlantDetailsViewControllerPreviews: PreviewProvider {
  static var previews: some View {
    PlantDetailsViewController()
        .environment(\.colorScheme, .light)
        .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
        .previewDisplayName("iPhone 11")
    
    PlantDetailsViewController()
        .environment(\.colorScheme, .light)
        .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (2nd generation)"))
        .previewDisplayName("iPad Pro (11-inch) (2nd generation)")
    
    PlantDetailsViewController()
        .environment(\.colorScheme, .dark)
        .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
        .previewDisplayName("iPhone SE")
  }
}
#endif
