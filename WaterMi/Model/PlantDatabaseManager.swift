//
//  PlantDatabaseManager.swift
//  WaterMi
//
//  Created by Sascha on 26.10.20.
//

import UIKit
import CoreData

class PlantDatabaseManager {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel") //Container is the actual database
        let storeURL = URL.storeURL(for: "group.SaSaPeKi.WaterMi.core.data", databaseName: "WaterMi")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func addNewPlantToContext(plantName:String?, plantImage:UIImage?) -> Plant {
        let newPlant = Plant(context: persistentContainer.viewContext)
        newPlant.plantName = plantName ?? "Plant"
        newPlant.plantImage = plantImage!.pngData()
        savePlants()
        return newPlant
    }
    
    func loadPlants(with request: NSFetchRequest<Plant> = Plant.fetchRequest()) -> [Plant] {
        do {
            return try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error loading category array \(error)")
        }
        return []
    }
    
    func savePlants() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                print("Error encoding item array \(error)")
            }
        }
    }
    
    func deletePlant(plant:Plant) {
        persistentContainer.viewContext.delete(plant)
    }
}

public extension URL {

    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }
        
        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
