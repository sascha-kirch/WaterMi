//
//  NotificationManager.swift
//  WaterMi
//
//  Created by Sascha on 29.10.20.
//

import UIKit
import UserNotifications

class NotificationManager {
    
   static func setNotificationCategories(){
        let waterAction = UNNotificationAction(identifier: "waterAction", title: "Watered!", options: .destructive)
        let postponeAction = UNNotificationAction(identifier: "postponeAction", title: "Remind me later!", options: .destructive)
    
        let waterMiCategory = UNNotificationCategory(identifier: "watermi.category", actions: [waterAction,postponeAction], intentIdentifiers: [], options: [])
    
        UNUserNotificationCenter.current().setNotificationCategories([waterMiCategory])
    }
    
    static func SetUpWateringNotification(for plant:Plant){
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = plant.plantName!
        notificationContent.subtitle = "\"Hi pal! I am getting thursty!\""
        notificationContent.body = "Please be so kind and help olivio. Don't forget to update the reminder!"
        notificationContent.sound = UNNotificationSound.default
        notificationContent.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        notificationContent.categoryIdentifier = "watermi.category"
        notificationContent.userInfo = ["plantID": plant.plantID!]
        
        //Method is defined in the extensions file!
        if let attechment = UNNotificationAttachment.create(identifier: ProcessInfo.processInfo.globallyUniqueString, image: UIImage(data: plant.plantImage!)!, options: nil){
            notificationContent.attachments = [attechment]
        }

        // show this notification one seconds from now
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: plant.nextTimeWatering!)
        let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        

        // choose a random identifier. NotificationID is the unique id of the plant
        let request = UNNotificationRequest(identifier: plant.plantID!, content: notificationContent, trigger: calendarTrigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    
    static func CancelPendingNotification(for plant:Plant) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [plant.plantID!])
    }
}
