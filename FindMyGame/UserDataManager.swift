//
//  UserDataManager.swift
//  FindMyGame
//
//  Created by Bhuvana on 26/09/18.
//  Copyright © 2018 capgemini. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class UserDataManager {
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    /**
        * Creating a function to fetch users data from core data
        * By using username we predicate data from the entitiy
        * Returning the data that is fetched
     */
    func getRequiredData(user: String) -> UserData?{
        let consumerFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        consumerFetchRequest.predicate = NSPredicate(format: "username = %@", user)
        if let users = try? context.fetch(consumerFetchRequest) as? [UserData]{
            return users?.first
        }
        return nil
    }
    
    /**
        * Creating a function to add games information into coredata
        * In the entity GameData we are inserting games information from the Class GameInfo by creating an object
     */
    func addGamesData(gameObject: GameInfo) {
        if let addData = NSEntityDescription.insertNewObject(forEntityName: "GameData", into: context) as? GameData {
            addData.gameName = gameObject.name
            addData.gameId = gameObject.id
            addData.gameGenre = gameObject.genre
            addData.gamePlatform = gameObject.platform
            addData.gameDesc = gameObject.description
            appDelegate.saveContext()
        }
    }
    
    /**
        * Creating a function to add new games data into coredata in the entity GameData
        * Saving the data that is inserted
     */
    func addNewGamesData(name: String, id: String, genre: String, platform: String, desc: String) {
        if let addData = NSEntityDescription.insertNewObject(forEntityName: "GameData", into: context) as? GameData {
            addData.gameName = name
            addData.gameId = id
            addData.gameGenre = genre
            addData.gamePlatform = platform
            addData.gameDesc = desc
            appDelegate.saveContext()
        }
    }
    
    /**
        * Creating a function to fetch the games data from the GameData entity
        * Predicatimg using gameType attribute and fetching data
        * Returning the data that is fetched
     */
    func getGameData(gameType: String) -> [GameData]? {
        let productsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameData")
        productsFetchRequest.predicate = NSPredicate(format: "gamePlatform == %@", gameType)
        if let gamess = try? context.fetch(productsFetchRequest) as? [GameData]{
            return gamess
        }
        return nil
    }
    
    /**
        * Craeting a function to get the game data from the entity GameData
        * Predicating using gameId attribute
        * Returning the particular data that is fetched
     */
    func getGameDetails(gameId: String) ->GameData? {
        let productsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameData")
        productsFetchRequest.predicate = NSPredicate(format: "gameId == %@", gameId)
        if let games = try? context.fetch(productsFetchRequest) as? [GameData]{
            return games?.first
        }
        return nil
    }
    
    
    /**
        * Creating a function to upadte the data in the coredata in the entity GameData
        * Fetching the data using getGameDetails() function
        * Updating the data at the coredata based on the function
        * Saving the data after updating
     */
    func updateGameDetails(name: String, id: String, genre: String, platform: String, desc: String){
        if let SelectedGame = getGameDetails(gameId: id){
            SelectedGame.gameName = name
            SelectedGame.gameId = id
            SelectedGame.gameGenre = genre
            SelectedGame.gamePlatform = platform
            SelectedGame.gameDesc = desc
        }
        appDelegate.saveContext()
    }
}
