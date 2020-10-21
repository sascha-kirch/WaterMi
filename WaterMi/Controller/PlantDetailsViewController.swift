//
//  PlantDetailsViewController.swift
//  WaterMi
//
//  Created by Sascha on 21.10.20.
//

import UIKit

class PlantDetailsViewController: UIViewController {

    var selectedPlant: String?
    
    @IBOutlet weak var plantNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.plantNameLabel.text = selectedPlant ?? "PlantName"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
