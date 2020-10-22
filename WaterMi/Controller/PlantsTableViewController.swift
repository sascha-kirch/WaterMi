//
//  PlantsTableViewController.swift
//  WaterMi
//
//  Created by Sascha on 21.10.20.
//

import UIKit
import SwipeCellKit

class PlantsTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    
    
    var Plants: [Plant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        //register custom cell design!
        tableView.register(UINib(nibName: WMConstant.cellNibName, bundle: nil), forCellReuseIdentifier: WMConstant.cellIdentifier)

        Plants = [
            Plant(name: "Olivio", image: UIImage(named: "olivio") ?? UIImage(named: "leaf")! ),
            Plant(name: "Tomatino", image: UIImage(named: "tomatino") ?? UIImage(named: "leaf")!),
            Plant(name: "Spicy", image: UIImage(named: "spicy") ?? UIImage(named: "leaf")!)]
    }
    
    @IBAction func addPlantButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "GoToAddPlantView", sender: self)
    }
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Plants.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plant = Plants[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WMConstant.cellIdentifier, for: indexPath) as! PlantCell
        cell.label.text = plant.name
        cell.plantImageView.image = plant.image
        cell.delegate = self //delegate for the swipe kit
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            if self.Plants[indexPath.row] != nil{
                self.Plants.remove(at: indexPath.row)
            }
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "trash")
        
        
        return [deleteAction]
    }
    
    /**used to define the options for swiping*/
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    //MARK: - Row Interaction
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToPlantDetailsView", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Only executed for the transition to the detail View!
        if let destinationVC = segue.destination as? PlantDetailsViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedPlant = Plants[indexPath.row].name
                destinationVC.selectedPlantImage = Plants[indexPath.row].image
            }
        }
    }
   
}

