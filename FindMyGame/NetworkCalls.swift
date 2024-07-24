//
//  NetworkCalls.swift
//  FindMyGame
//
//  Created by Bhuvana on 27/09/18.
//  Copyright © 2018 capgemini. All rights reserved.
//
import Foundation
import UIKit
import Alamofire

class NetworkCalls {
    
    func fetchData(completion: @escaping ([GameInfo]?) -> Void) {
        guard let url = URL(string: "http://www.mocky.io/v2/5bab922d3100001100654413") else {
            completion(nil)
            return
        }
        Alamofire.request(url)
            // method: .get,
            //parameters: ["include_docs": "true"])
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error While fetching data \(String(describing: response.result.error))")
                    completion(nil)
                    return
                }
                
                guard let value = response.result.value as? [String: Any],
                    let rows = value["game details"] as? [NSDictionary] else {
                        print("Malformed data received from fetchAllRooms service")
                        completion(nil)
                        return
                }
                
                let userData : [GameInfo] = rows.map { userDictionary in
                    
                    let game_Name = userDictionary["gameName"] as? String ?? ""
                    let game_Id = userDictionary["gameId"] as? String ?? ""
                    let game_Genre = userDictionary["gameGenre"] as? String ?? ""
                    let game_PlatForm = userDictionary["gamePlatform"] as? String ?? ""
                    let game_Description = userDictionary["gameDescription"] as? String ?? ""
                    
                    let gamesData = GameInfo(name: game_Name, id: game_Id, genre: game_Genre, platform: game_PlatForm, description: game_Description)
                    return gamesData
                }
                
                completion(userData)
        }
    }
}
