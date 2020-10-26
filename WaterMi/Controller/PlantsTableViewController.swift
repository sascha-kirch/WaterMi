//
//  PlantsTableViewController.swift
//  WaterMi
//
//  Created by Sascha on 21.10.20.
//

import UIKit
import SwipeCellKit
import UserNotifications


class PlantsTableViewController: UITableViewController, UIViewControllerPreviewingDelegate, UNUserNotificationCenterDelegate {

    @IBOutlet var plantsTableView: UITableView!
    var Plants: [Plant] = []
    
    let plantDatabaseManger = PlantDatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register3D Touch Preview
        if( traitCollection.forceTouchCapability == .available){
            registerForPreviewing(with: self, sourceView: plantsTableView)
        }
        
        plantsTableView.delegate = self
        plantsTableView.dataSource = self
        UNUserNotificationCenter.current().delegate = self
        setNotificationCategories()
        
        //register custom cell design!
        tableView.register(UINib(nibName: WMConstant.CustomCell.plantCellNibName, bundle: nil), forCellReuseIdentifier: WMConstant.CustomCell.plantCellIdentifier)
        tableView.register(UINib(nibName: WMConstant.CustomCell.adCellNibName, bundle: nil), forCellReuseIdentifier: WMConstant.CustomCell.adCellIdentifier)
        
        //Load Plants
        Plants = plantDatabaseManger.loadPlants()
        
        //Asking user for permission using the provisorial scheme!
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound, .provisional]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func addPlantButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: WMConstant.SegueID.addPlantView, sender: self)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return Plants.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plant = Plants[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WMConstant.CustomCell.plantCellIdentifier, for: indexPath) as! PlantCell
        cell.plantNameLabel.text = plant.plantName
        cell.plantImageView.image = UIImage(data: plant.plantImage!)
        cell.delegate = self //delegate for the swipe kit
        
        return cell
    }
    
    //MARK: - Row Interaction
    
    /**Defines what happens, when item has been selected*/
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: WMConstant.SegueID.plantDetailsView, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /**Prepares the destination viewcontroller of the segue that is about to be executed*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Only executed for the transition to the detail View!
        if let destinationVC = segue.destination as? PlantDetailsViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedPlant = Plants[indexPath.row].plantName
                destinationVC.selectedPlantImage = UIImage(data:Plants[indexPath.row].plantImage!)
            }
        } else if let destinationVC = segue.destination as? AddPlantViewController {
                destinationVC.callingViewController = self
        }
    }
    
    //MARK: - 3D Touch capabilities
    /**Returns the preview for a certain viewcontroller*/
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = plantsTableView?.indexPathForRow(at: location) else { return nil }
        guard let cell = plantsTableView?.cellForRow(at: indexPath) else { return nil }
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: WMConstant.StoryBoardID.PlantDetailsViewController) as? PlantDetailsViewController else { return nil }
        
        detailVC.selectedPlant = Plants[indexPath.row].plantName
        detailVC.selectedPlantImage = UIImage(data:Plants[indexPath.row].plantImage!)
        detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
        
        previewingContext.sourceRect = cell.frame
        
        return detailVC
    }
    
    /**defines what happens, when the 3D touch has been recognized (pop-condition)*/
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
    
    //MARK: - Notification related
    
    /**Used to debug notifications*/
    @IBAction func notificationButtonPressed(_ sender: UIBarButtonItem) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Olivio:"
        notificationContent.subtitle = "\"Hi pal! I am getting thursty!\""
        notificationContent.body = "Please be so kind and help olivio. Don't forget to update the reminder!"
        notificationContent.sound = UNNotificationSound.default
        notificationContent.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        notificationContent.categoryIdentifier = "watermi.category"
        
        //Method is defined in the extensions file!
        if let attechment = UNNotificationAttachment.create(identifier: ProcessInfo.processInfo.globallyUniqueString, image: UIImage(named: "olivio")!, options: nil){
            notificationContent.attachments = [attechment]
        }

        // show this notification one seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    
    func setNotificationCategories(){
        let waterAction = UNNotificationAction(identifier: "waterAction", title: "Watered!", options: [])
        let postponeAction = UNNotificationAction(identifier: "postponeAction", title: "Remind me later!", options: [])
    
        let waterMiCategory = UNNotificationCategory(identifier: "watermi.category", actions: [waterAction,postponeAction], intentIdentifiers: [], options: [])
    
        UNUserNotificationCenter.current().setNotificationCategories([waterMiCategory])
        
    }
}

//MARK: - SwipeCellKit Extension
extension PlantsTableViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        //only allow sliding from the righthand side
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            if indexPath.row < self.Plants.count {

                self.plantDatabaseManger.deletePlant(plant: self.Plants[indexPath.row])
                self.Plants.remove(at: indexPath.row) //IMPORTANT: first the context, then the array! If not ndex out of range
                self.plantDatabaseManger.savePlants()
                
            }
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "trash")
        deleteAction.backgroundColor = UIColor.red
        
        
        let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPath in
            // handle action by updating model with deletion
            if indexPath.row < self.Plants.count {
                self.performSegue(withIdentifier: WMConstant.SegueID.addPlantView, sender: self)
            }
        }
        // customize the action appearance
        editAction.image = UIImage(named: "pencil")
        editAction.backgroundColor = UIColor.orange
        
        return [deleteAction, editAction]
    }
    
    /**used to define the options for swiping*/
    func tableView(_ tableView: UITableView,
                   editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}

