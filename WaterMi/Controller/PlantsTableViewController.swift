//
//  PlantsTableViewController.swift
//  WaterMi
//
//  Created by Sascha on 21.10.20.
//

import UIKit

class PlantsTableViewController: UITableViewController {
    
    var plants = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        plants = ["Olivio", "Tomatino", "Spicy"]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func addPlantButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "GoToAddPlantView", sender: self)
    }
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return plants.count
    }
   
    override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
   
        cell.textLabel?.text = plants[indexPath.row]
        //cell.textLabel?.textColor = .black
   
        return cell
    }
    
    //MARK: - Row Interaction
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToPlantDetailsView", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PlantDetailsViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedPlant = plants[indexPath.row]
        }
    }
}
