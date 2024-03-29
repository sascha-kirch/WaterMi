//
//  PlantsTableViewController.swift
//  WaterMi
//
//  Created by Sascha on 21.10.20.
//

import UIKit
import SwipeCellKit
import UserNotifications


final class PlantsTableViewController: UITableViewController, UIViewControllerPreviewingDelegate, UNUserNotificationCenterDelegate {

    @IBOutlet var plantsTableView: UITableView!
    var Plants: [Plant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //Register3D Touch Preview
        if( traitCollection.forceTouchCapability == .available){
            registerForPreviewing(with: self, sourceView: plantsTableView)
        }
        
        plantsTableView.delegate = self
        plantsTableView.dataSource = self
        UNUserNotificationCenter.current().delegate = self
        NotificationManager.setNotificationCategories()
        
        //register custom cell design!
        tableView.register(UINib(nibName: WMConstant.CustomCell.plantCellNibName, bundle: nil), forCellReuseIdentifier: WMConstant.CustomCell.plantCellIdentifier)
        tableView.register(UINib(nibName: WMConstant.CustomCell.adCellNibName, bundle: nil), forCellReuseIdentifier: WMConstant.CustomCell.adCellIdentifier)
        
        //Load Plants
        Plants = DatabaseManager.loadPlantsFromPersistentContainer()
        
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Plants.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plant = Plants[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WMConstant.CustomCell.plantCellIdentifier, for: indexPath) as! PlantCell
        cell.plantNameLabel.text = plant.plantName
        cell.plantImageView.image = UIImage(data: plant.plantImage!)
        cell.delegate = self //delegate for the swipe kit
        
        return cell
    }
    
    //MARK: - Row Interaction
    
    /**Defines what happens, when item has been selected*/
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: WMConstant.SegueID.plantDetailsView, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /**Prepares the destination viewcontroller of the segue that is about to be executed*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Only executed for the transition to the detail View!
        if let destinationVC = segue.destination as? PlantDetailsViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.plant = Plants[indexPath.row]
            }
        } else if let destinationVC = segue.destination as? AddPlantViewController {
                destinationVC.callingViewController = self
        }
    }
    
    //MARK: - 3D Touch capabilities
    /**Returns the preview for a certain viewcontroller*/
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = plantsTableView?.indexPathForRow(at: location) else { return nil }
        guard let cell = plantsTableView?.cellForRow(at: indexPath) else { return nil }
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: WMConstant.StoryBoardID.PlantDetailsViewController) as? PlantDetailsViewController else { return nil }
        
        detailVC.plant = Plants[indexPath.row]
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
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let plantID = userInfo["plantID"] as? String {
            print("Received plantID: \(plantID)")
        
            if let plant:Plant = DatabaseManager.getPlantFromUUIDString(uuid: plantID){
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                //User Swiped to unlock
            print("Default Identifier")
            case "waterAction":
                DatabaseManager.wateredPlant(plant: plant)
            case "postponeAction":
                print("postponeAction triggered")
            default:
                break
            }
            }
        }
        
        //you must call completionhandler when you're done
        completionHandler()
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

                DatabaseManager.deletePlantFromContext(plant: self.Plants[indexPath.row])
                self.Plants.remove(at: indexPath.row) //IMPORTANT: first the context, then the array! If not ndex out of range
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
        
        let waterAction = SwipeAction(style: .default, title: "Water") { action, indexPath in
            // handle action by updating model with deletion
            if indexPath.row < self.Plants.count {
                DatabaseManager.wateredPlant(plant: self.Plants[indexPath.row])
            }
        }
        // customize the action appearance
        waterAction.image = UIImage(named: "drop")
        waterAction.backgroundColor = UIColor.blue
        
        let notifyAction = SwipeAction(style: .default, title: "Notify") { action, indexPath in
            // handle action by updating model with deletion
            if indexPath.row < self.Plants.count {
                NotificationManager.SetUpWateringNotification(for: self.Plants[indexPath.row])
            }
        }
        // customize the action appearance
        notifyAction.image = UIImage(named: "message")
        notifyAction.backgroundColor = UIColor.gray
        
        return [deleteAction, editAction, waterAction, notifyAction]
    }
    
    /**used to define the options for swiping*/
    func tableView(_ tableView: UITableView,
                   editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}


//MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI

extension PlantsTableViewController: UIViewControllerRepresentable {
    
  func makeUIViewController(context: Context) -> PlantsTableViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
      guard let viewController =  storyboard.instantiateViewController(
                identifier: WMConstant.StoryBoardID.PlantsTableViewController) as? PlantsTableViewController else {
          fatalError("Cannot load from storyboard")
      }
      // Configure the view controller here
      return viewController
  }

  func updateUIViewController(_ uiViewController: PlantsTableViewController,
    context: Context) {
  }
}

struct PlantsTableViewControllerPreviews: PreviewProvider {
  static var previews: some View {
    PlantsTableViewController()
        .environment(\.colorScheme, .light)
        .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
        .previewDisplayName("iPhone 11")
    
    PlantsTableViewController()
        .environment(\.colorScheme, .light)
        .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (2nd generation)"))
        .previewDisplayName("iPad Pro (11-inch) (2nd generation)")
    
    PlantsTableViewController()
        .environment(\.colorScheme, .dark)
        .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
        .previewDisplayName("iPhone SE")
  }
}
#endif
