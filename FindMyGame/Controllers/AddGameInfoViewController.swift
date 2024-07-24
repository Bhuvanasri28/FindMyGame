//
//  AddGameInfoViewController.swift
//  FindMyGame
//
//  Created by Bhuvana on 11/10/18.
//  Copyright © 2018 capgemini. All rights reserved.
//

import UIKit

class AddGameInfoViewController: UIViewController {
    
    /// Craeting outlets for the textfields to add new game name, id, genre, platform, description, title..
    @IBOutlet weak var addGameName: UITextField!
    @IBOutlet weak var addGameId: UITextField!
    @IBOutlet weak var addGameGenre: UITextField!
    @IBOutlet weak var addGamePlatform: UITextField!
    @IBOutlet weak var addGameDescription: UITextView!
    @IBOutlet weak var buttonTitle: UIButton!
    @IBOutlet weak var gameInfoTitle: UILabel!
    
    /// Creating an object for UserDataManager()
    var userDataManager = UserDataManager()
    var gameToBeEdited : GameData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Checking whether the object gamesToBeEdited is nil or not, if it is not nil => edit button is pressed, so we are calling DisplayingEditGamesData() function
        if gameToBeEdited != nil {
            DisplayingEditGamesData()
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        // To tap not to interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    /// Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    /**
        * Creating an outlet action for cancel button
        * Here we are dismissing the view if they press the cancel button using dismiss
     */
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
        * Creating an outlet action for button to add Games
        * Based on the gameToBeEdited object we are distinguishing whether the user pressed '+' sign or edit button :
            * If it is empty => We have pressed + sign, so we need to add Games
                * Here we are calling a function from UserDataManager Class by creating an object and calling the function addNewGamesData
                * Through this function we are going to take the data that is enetered in the textfields and adding in the coredata
            *  If it is not empty => We have pressed Edit button, so we need to update Games Data
                * Here we are calling a function from UserDataManager Class by creating an object and calling the function updateGameDetails
                * Through this function we are going to take the data that is enetered in the textfields and updating in the coredata
        * Finally presenting the split view controller after adding or editing
     */
    @IBAction func AddGames(_ sender: UIButton) {
        
        if gameToBeEdited == nil{
            userDataManager.addNewGamesData(name: addGameName.text!, id: addGameId.text!, genre: addGameGenre.text!, platform: addGamePlatform.text!, desc: addGameDescription.text!)
        }
        else {
            userDataManager.updateGameDetails(name: addGameName.text!, id: (gameToBeEdited?.gameId)!, genre: addGameGenre.text!, platform: addGamePlatform.text!, desc: addGameDescription.text!)
        }
        if let splitView = self.storyboard?.instantiateViewController(withIdentifier: "SplitViewScene") {
            self.present(splitView, animated: true, completion: nil)
        }
    }
    
    /**
        * Creating a function to show Games Data which is to be edited in a new view
        * Assigning the data from the detail view controller to the textfileds for which we created outlets
     */
    func DisplayingEditGamesData() {
        self.addGameName.text = gameToBeEdited?.gameName!
        self.addGameId.text = gameToBeEdited?.gameId!
        self.addGameGenre.text = gameToBeEdited?.gameGenre!
        self.addGamePlatform.text = gameToBeEdited?.gamePlatform!
        self.addGameDescription.text = gameToBeEdited?.gameDesc!
        self.buttonTitle.setTitle("Save Changes", for: .normal)
        self.gameInfoTitle.text = "Edit Game"
    }

}
