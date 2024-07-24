//
//  GameInformation.swift
//  FindMyGame
//
//  Created by Bhuvana on 27/09/18.
//  Copyright © 2018 capgemini. All rights reserved.
//

import Foundation
import CoreData

class GameInfo {
    
    var name : String?
    var id : String?
    var genre : String?
    var platform : String?
    var description : String?
    
    init(name: String, id: String, genre: String, platform: String, description: String) {
        self.name = name
        self.id = id
        self.genre = genre
        self.platform = platform
        self.description = description
    }
}
