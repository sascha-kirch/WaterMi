//
//  PlantDatabaseManager.swift
//  WaterMi
//
//  Created by Sascha on 26.10.20.
//

import UIKit
import CoreData

class PlantDatabaseManager {
    
    //refers to the lazy var in the appdelegate file!
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func addNewPlantToContext(plantName:String?, plantImage:UIImage?) -> Plant {
        let newPlant = Plant(context: context)
        newPlant.plantName = plantName ?? "Plant"
        newPlant.plantImage = plantImage!.pngData()
        savePlants()
        return newPlant
    }
    
    func loadPlants(with request: NSFetchRequest<Plant> = Plant.fetchRequest()) -> [Plant] {
        do {
            return try context.fetch(request)
        } catch {
            print("Error loading category array \(error)")
        }
        return []
    }
    
    func savePlants() {
        do {
            try context.save()
        } catch {
            print("Error encoding item array \(error)")
        }
    }
    
    func deletePlant(plant:Plant) {
        context.delete(plant)
    }
}
