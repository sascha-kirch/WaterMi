//
//  PlantDatabaseManager.swift
//  WaterMi
//
//  Created by Sascha on 26.10.20.
//

import UIKit
import CoreData

class DatabaseManager {
    
    //MARK: - general Mehtods
    static var persistentContainer: NSPersistentContainer = {
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
    
    /**Saves all plants from context into the container*/
    static func saveContextToPersistentContainer() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                print("Error encoding item array \(error)")
            }
        }
    }
    
    //MARK: - Plant Methods
    
    /**Adds a new plant to the context*/
    static func addNewPlantToContext(plantName:String, plantImage:UIImage, waterIntervall:Int16, waterTime:Date, saveContextToContainer:Bool = true) -> Plant {
        let newPlant = Plant(context: persistentContainer.viewContext)
        newPlant.plantID = UUID().uuidString
        newPlant.plantName = plantName
        newPlant.plantImage = plantImage.pngData()
        newPlant.timerActive = true
        newPlant.wateringIntervall = waterIntervall
        newPlant.wateringTime = waterTime
        newPlant.nextTimeWatering = getNextWateringTime(waterIntervall: waterIntervall, waterTime: waterTime)
        newPlant.lastTimeWatering = nil
        
        //saving is optional in order to be more efficient when modifying more objects at once
        if saveContextToContainer {
            saveContextToPersistentContainer()
        }
        return newPlant
    }
    
    /**loads the plants stored in the container and returns the context*/
    static func loadPlantsFromPersistentContainer(with request: NSFetchRequest<Plant> = Plant.fetchRequest()) -> [Plant] {
        do {
            return try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error loading category array \(error)")
        }
        return []
    }
    
    /**deletes plant provided from context.*/
    static func deletePlantFromContext(plant:Plant, saveContextToContainer:Bool = true) {
        //deleteStatisticsOfPlantFromContext(plant: plant)
        
        //Deletes all children since configured deletion is "cascade"
        persistentContainer.viewContext.delete(plant)
        
        //saving is optional in order to be more efficient when modifying more objects at once
        if saveContextToContainer {
            saveContextToPersistentContainer()
        }
    }
    
    /**Updates the plant provided in the context*/
    static func setPlantActivationState(plant:Plant, newState:Bool, saveContextToContainer:Bool = true) {
        
        plant.timerActive = newState
        
        //saving is optional in order to be more efficient when modifying more objects at once
        if saveContextToContainer {
            saveContextToPersistentContainer()
        }
    }
    
    static func wateredPlant(plant:Plant, saveContextToContainer:Bool = true){
        //first the statistic, then the update of the plant!
        addNewWateringStatistic(plant: plant)
        plant.lastTimeWatering = Date()
        plant.nextTimeWatering = getNextWateringTime(waterIntervall: plant.wateringIntervall, waterTime: plant.wateringTime!)
        
        //saving is optional in order to be more efficient when modifying more objects at once
        if saveContextToContainer {
            saveContextToPersistentContainer()
        }
    }
    
    static func getNextWateringTime(waterIntervall:Int16, waterTime:Date) -> Date {
        let waterTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: waterTime)
        var nextIntervallDate = Calendar.current.date(byAdding: .day, value: Int(waterIntervall), to: Date())
        nextIntervallDate = Calendar.current.date(bySettingHour: waterTimeComponents.hour!, minute: waterTimeComponents.minute!, second: 0, of: nextIntervallDate!)
        
        return nextIntervallDate!
    }
    
    static func getPlantFromUUIDString(uuid:String, request: NSFetchRequest<Plant> = Plant.fetchRequest()) -> Plant?{
        var plant:Plant? = nil
        let plantPredicate = NSPredicate(format: "plantID MATCHES %@", uuid)
        request.predicate = plantPredicate
        
        do {
            //first bacause the should be maximum 1 plant since uuid is unique
            plant = try persistentContainer.viewContext.fetch(request).first
            } catch {
                print("Error loading category array \(error)")
        }
        return plant
    }
    
    static func getDebugPlant() -> Plant{
        let plant = Plant()
        plant.plantName = "olivio"
        plant.plantImage = UIImage(named: "olivio")?.pngData()
        plant.timerActive = true
        plant.lastTimeWatering = Date()
        plant.nextTimeWatering = Date()
        plant.wateringTime = Date()
        plant.wateringIntervall = 5
        
        return plant
    }
    
    //MARK: - Statistic Methods
    
    /**adds a new watering process to the context!*/
    static func addNewWateringStatistic(plant:Plant, saveContextToContainer:Bool = true){
        let newWateringStatistic = WateringStatistic(context: persistentContainer.viewContext)
        newWateringStatistic.parentPlant = plant
        newWateringStatistic.actualDate = Date()
        newWateringStatistic.dueDate = plant.nextTimeWatering
        
        //saving is optional in order to be more efficient when modifying more objects at once
        if saveContextToContainer {
            saveContextToPersistentContainer()
        }
    }
    
    /**deletes statistic provided from context.*/
    static func deleteStatisticFromContext(statistic:WateringStatistic, saveContextToContainer:Bool = true) {
        persistentContainer.viewContext.delete(statistic)
        
        if saveContextToContainer {
            saveContextToPersistentContainer()
        }
    }
    
    /**loads the plants stored in the container and returns the context*/
    static func loadStatisticsFromPersistentContainer(with request: NSFetchRequest<WateringStatistic> = WateringStatistic.fetchRequest()) -> [WateringStatistic] {
        do {
            return try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error loading category array \(error)")
        }
        return []
    }
    
    /**loads the plants stored in the container and returns the context*/
    static func loadStatisticsFromPersistentContainer(for plant:Plant, with request: NSFetchRequest<WateringStatistic> = WateringStatistic.fetchRequest()) -> [WateringStatistic] {
        
        let plantPredicate = NSPredicate(format: "parentPlant.plantName MATCHES %@", plant.plantName!)

        request.predicate = plantPredicate

        do {
            let fetchedResult = try persistentContainer.viewContext.fetch(request)
            return fetchedResult
        } catch {
            print("Error loading category array \(error)")
        }
        return []
    }
    
    /**Returns statistics independently from its parent plant*/
    static func getStatistics(statisticTypes:[EwateringStatistic]) -> [StatisticFormat] {
        var statistic : [StatisticFormat] = []
        for type in statisticTypes {
            switch type {
            case .timesWatered:
                statistic.append(StatisticFormat(name: "Times Watered", value: Double(loadStatisticsFromPersistentContainer().count)))
            case .numberOfPlants:
                statistic.append(StatisticFormat(name: "Number of Plants", value: Double(loadPlantsFromPersistentContainer().count)))
            }
        }
        return statistic
    }
    
    /**Returns statistics for a given plant*/
    static func getStatistics(for plant:Plant, statisticTypes:[EwateringStatistic]) -> [StatisticFormat] {
        var statistic : [StatisticFormat] = []
        for type in statisticTypes {
            switch type {
            case .timesWatered:
                statistic.append(StatisticFormat(name: "\(plant.plantName!): Times Watered", value: Double(loadStatisticsFromPersistentContainer(for: plant).count)))

            case .numberOfPlants:
                print("Nothing")
            }
        }
        return statistic
    }
}

struct StatisticFormat {
    let name:String
    let value:Double
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
