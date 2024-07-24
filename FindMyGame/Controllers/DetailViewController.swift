//
//  DetailViewController.swift
//  FindMyGame
//
//  Created by Bhuvana on 26/09/18.
//  Copyright © 2018 capgemini. All rights reserved.
//

import UIKit
import CoreData

protocol LoadingTableView : class {
    func loadTableView()
}

class DetailViewController: UIViewController {
    
    /// Creating Outlets for textfields i.e; name, id, genre, description, platform of the game
    
    @IBOutlet weak var nameOfGame: UITextField!
    @IBOutlet weak var idOfGame: UITextField!
    @IBOutlet weak var genreOfGame: UITextField!
    @IBOutlet weak var platformOfGame: UITextField!
    @IBOutlet weak var descOfGame: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Creating a UIBarButtonItem to edit the game Information
        let editButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(enableEditing))

        editingFields(status: false)
        
        /// If the games object is null we will hide the text fields or viceversa
        if games == nil {
            isHiddenOfTextFields(status: true)
            self.navigationItem.rightBarButtonItem = nil
        }
        else {
            self.navigationItem.rightBarButtonItem = editButton
        }
    }
    
    /// Creating Object for the class UserDataManager
    
    var userDataManager = UserDataManager()
    
    weak var delegate : LoadingTableView?
    
    /// Creating Closure for the entity GameData to refresh the UI
    var games: GameData? {
        didSet {
            refreshUI() // Refreshing UI while setting the games data
        }
    }
    
    /// Creating a function to set data to the textfields and refreshing the UI if it is not loaded
    
    func refreshUI() {
        loadViewIfNeeded()
        nameOfGame.text = games?.gameName
        idOfGame.text = games?.gameId
        genreOfGame.text = games?.gameGenre
        platformOfGame.text = games?.gamePlatform
        descOfGame.text = games?.gameDesc
    }

    /**
        * Creating a function to display or hide the text fields based on status
        * If the status is true we are hiding the textfields or viceversa
     */
    func isHiddenOfTextFields(status: Bool) {
        nameOfGame.isHidden = status
        idOfGame.isHidden = status
        genreOfGame.isHidden = status
        platformOfGame.isHidden = status
        descOfGame.isHidden = status
    }
    
    /**
        * Creating a function to enable user interaction or not based on status
        * If the status is true we are enabling the user interaction or viceversa
     */
    func editingFields(status: Bool) {
        nameOfGame.isUserInteractionEnabled = status
        idOfGame.isUserInteractionEnabled = status
        genreOfGame.isUserInteractionEnabled = status
        platformOfGame.isUserInteractionEnabled = status
        descOfGame.isEditable = status
    }
    
    /**
        * Creating a function to enable the text fields editing
        * Assigning gameToBeEdited with games, to show the details to be edited, that is in AddGameInfoViewController  
        * Presenting a new view for editing
    */
    @objc func enableEditing() {
        if let addGamesView = self.storyboard?.instantiateViewController(withIdentifier: "AddGamesScene") as? AddGameInfoViewController {
            addGamesView.gameToBeEdited = self.games
            self.navigationController?.present(addGamesView, animated: true, completion: nil)
        }
    }
    
}
