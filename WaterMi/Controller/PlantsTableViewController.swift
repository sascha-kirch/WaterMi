//
//  PlantsTableViewController.swift
//  WaterMi
//
//  Created by Sascha on 21.10.20.
//

import UIKit
import SwipeCellKit
import UserNotifications
import GoogleMobileAds

class PlantsTableViewController: UITableViewController, UIViewControllerPreviewingDelegate, UNUserNotificationCenterDelegate, GADUnifiedNativeAdLoaderDelegate  {
    
    
    
    @IBOutlet var plantsTableView: UITableView!
    var Plants: [Plant] = []
    var adLoader: GADAdLoader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register3D Touch Preview
        if( traitCollection.forceTouchCapability == .available){
            registerForPreviewing(with: self, sourceView: plantsTableView)
        }
        plantsTableView.delegate = self
        plantsTableView.dataSource = self
        UNUserNotificationCenter.current().delegate = self
        setCategories()
        
        //tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
        //register custom cell design!
        tableView.register(UINib(nibName: WMConstant.CustomCell.plantCellNibName, bundle: nil), forCellReuseIdentifier: WMConstant.CustomCell.plantCellIdentifier)
        
        Plants = [
            Plant(name: "Olivio", image: UIImage(named: "olivio") ?? UIImage(systemName: "leaf")! ),
            Plant(name: "Tomatino", image: UIImage(named: "tomatino") ?? UIImage(systemName: "leaf")!),
            Plant(name: "Spicy", image: UIImage(named: "spicy") ?? UIImage(systemName: "leaf")!)]
        
        //Asking user for permission using the provisorial scheme!
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound, .provisional]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
            multipleAdsOptions.numberOfAds = 5

            adLoader = GADAdLoader(adUnitID: "ca-app-pub-3940256099942544/3986624511", rootViewController: self,
                adTypes: [GADAdLoaderAdType.unifiedNative],
                options: [multipleAdsOptions])
            adLoader.delegate = self
            adLoader.load(GADRequest())
    }
    
    @IBAction func addPlantButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: WMConstant.SegueID.addPlantView, sender: self)
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Plants.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plant = Plants[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WMConstant.CustomCell.plantCellIdentifier, for: indexPath) as! PlantCell
        cell.label.text = plant.name
        cell.plantImageView.image = plant.image
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
                destinationVC.selectedPlant = Plants[indexPath.row].name
                destinationVC.selectedPlantImage = Plants[indexPath.row].image
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
        
        detailVC.selectedPlant = Plants[indexPath.row].name
        detailVC.selectedPlantImage = Plants[indexPath.row].image
        
        detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
        
        previewingContext.sourceRect = cell.frame
        
        return detailVC
    }
    
    /**defines what happens, when the 3D touch has been recognized (pop-condition)*/
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
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
                self.Plants.remove(at: indexPath.row)
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
    
    //MARK: - Notification related
    
    /**Used to debug notifications*/
    @IBAction func notificationButtonPressed(_ sender: UIBarButtonItem) {
        let content = UNMutableNotificationContent()
        content.title = "Olivio:"
        content.subtitle = "\"Hi pal! I am getting thursty!\""
        content.body = "Please be so kind and help olivio. Don't forget to update the reminder!"
        content.sound = UNNotificationSound.default
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        content.categoryIdentifier = "watermi.category"
        
        //Method is defined in the extensions file!
        if let attechment = UNNotificationAttachment.create(identifier: ProcessInfo.processInfo.globallyUniqueString, image: UIImage(named: "olivio")!, options: nil){
            content.attachments = [attechment]
        }
        

        // show this notification one seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    
    func setCategories(){
        let waterAction = UNNotificationAction(identifier: "waterAction", title: "Watered!", options: [])
        let postponeAction = UNNotificationAction(identifier: "postponeAction", title: "Remind me later!", options: [])
    
        let waterMiCategory = UNNotificationCategory(identifier: "watermi.category", actions: [waterAction,postponeAction], intentIdentifiers: [], options: [])

    
        UNUserNotificationCenter.current().setNotificationCategories([waterMiCategory])
        
    }
    
    //MARK: - Add Loader (Google Adds Functions)
    func adLoader(_ adLoader: GADAdLoader,
                    didReceive nativeAd: GADUnifiedNativeAd) {
        // A unified native ad has loaded, and can be displayed.
        print("Received Add")
        let alert = UIAlertController(title: nativeAd.headline, message: nativeAd.body, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: .none))
        var imageView = UIImageView(frame: CGRect(x: 220, y: 10, width: 40, height: 40))
        imageView.image = (nativeAd.mediaContent.mainImage ?? UIImage(systemName: "leaf"))
        alert.view.addSubview(imageView)
        
        present(alert, animated: true, completion: nil)

      }

      func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
          // The adLoader has finished loading ads, and a new request can be sent.
        print("AddLoader has finished Loading")
        let alert = UIAlertController(title: "Finished", message: "Addloader did finish loading", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: .none))
        present(alert, animated: true, completion: nil)
      }
    
    public func adLoader(_ adLoader: GADAdLoader,
                         didFailToReceiveAdWithError error: GADRequestError){
        //Handling failed requests
        print("Addloader Failed to recieve!")
        print(error)
        let alert = UIAlertController(title: "Error", message: "Error has accured", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: .none))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: - Native Adds (Google Adds Functions)
    
    func nativeAdDidRecordImpression(_ nativeAd: GADUnifiedNativeAd) {
      // The native ad was shown.
    }

    func nativeAdDidRecordClick(_ nativeAd: GADUnifiedNativeAd) {
      // The native ad was clicked on.
    }

    func nativeAdWillPresentScreen(_ nativeAd: GADUnifiedNativeAd) {
      // The native ad will present a full screen view.
    }

    func nativeAdWillDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
      // The native ad will dismiss a full screen view.
    }

    func nativeAdDidDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
      // The native ad did dismiss a full screen view.
    }

    func nativeAdWillLeaveApplication(_ nativeAd: GADUnifiedNativeAd) {
      // The native ad will cause the application to become inactive and
      // open a new application.
    }
    
}

