//
//  MasterViewController.swift
//  FindMyGame
//
//  Created by Bhuvana on 26/09/18.
//  Copyright © 2018 capgemini. All rights reserved.
//

import UIKit
import MBProgressHUD

class MasterViewController: UITableViewController, UISearchBarDelegate {
    
    /// Creating an empty array for GameData
    var gameData = [GameData]()
    var searchedGame = [GameData]()
    
    /// Creating an object for UserDataManager
    var userDataManager = UserDataManager()
    
    /// Creating an outlet for UITableView
    @IBOutlet var gameDataTableView: UITableView!
    
    /// Creating an outlet for UISearchBar
    @IBOutlet weak var gameSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameSearchBar.delegate = self
        gameSearchBar.placeholder = "Find my game.."
        /// Calling function to load games data
        loadGamesData()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    /**
        * Creating an outlet Action for + UIBarButton
        * Presenting modally AddGameInfoViewController with its identifier
     */
    
    @IBAction func AddGameInfo(_ sender: UIBarButtonItem) {
        if let addGamesView = self.storyboard?.instantiateViewController(withIdentifier: "AddGamesScene") as? AddGameInfoViewController {
            self.navigationController?.present(addGamesView, animated: true, completion: nil)
        }
    }
    
    /// Overriding function to know how many rows to be displayed in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return searchedGame.count
    }
    
    /// Overriding function to display data in the cells in the master view controller
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = gameDataTableView.dequeueReusableCell(withIdentifier: "MasterCell", for: indexPath) as! MasterViewTableViewCell
        let index = searchedGame[indexPath.row]
        cell.gameName.text = index.gameName
        if LoginPageViewController.typeOfUser == "PC" {
            cell.userTypeImg.image = #imageLiteral(resourceName: "pc")
        }
        else if LoginPageViewController.typeOfUser == "Xbox" {
            cell.userTypeImg.image = #imageLiteral(resourceName: "Xbox logo")
        }
        else {
            cell.userTypeImg.image = #imageLiteral(resourceName: "Playstation logo")
        }
        // Configure the cell...
        return cell
    }
    
   /**
        * Creating a function to load games data in the master table view
        * Using MBProgessHud to display spinner with the label "Loading...!!!" and hide after some delay
        * Fetching data from the core data by using getGameData function with parameter based on the type of user who logged in and storing in games
        * Storing the fetched data in an empty array gameData i.e; created for GameData
        * Reloading the table view in the main thread
        * Storing data in gameData in searchedGame empty array
    */
    func loadGamesData() {
        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinner.label.text = "Loading...!!!"
        if let games = self.userDataManager.getGameData(gameType: LoginPageViewController.typeOfUser) {
            self.gameData = games
            DispatchQueue.main.async {
                spinner.hide(animated: true, afterDelay: 2.0)
                self.gameDataTableView.reloadData()
            }
        }
        searchedGame = gameData
    }
    
    /**
        * Preapring a segue with identifier "showDetail" from cell to deatil view controller
        * Based on selected row passing data to games object that is in detail view controller
        *
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedGames = searchedGame[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.games = selectedGames
                controller.delegate = self
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    /// Creating an Outlet Action for Logout Button
    @IBAction func logoutAction(_ sender: UIBarButtonItem) {
        /// Alert Function to confirm whether user wants to logout or not
        showAlertToConfirmLogout(message: "Do you want to logout?")
    }
    
    /// Function to show Alert Message For confirming the user to logout or not
    func showAlertToConfirmLogout(message: String) {
        
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        // Create OK button
        let OKAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            print("Ok button tapped");
            if let loginView = self.storyboard?.instantiateViewController(withIdentifier: "LoginScene") as? LoginPageViewController {
                self.present(loginView, animated: true, completion: nil)
            }
        }
        alert.addAction(OKAction)
        
        /// Create Cancel button
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        alert.addAction(cancelAction)
    
        /// Present Dialog message
        self.present(alert, animated: true, completion:nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            guard !searchText.isEmpty else {
                searchedGame = gameData
                gameDataTableView.reloadData()
                return
            }
            searchedGame = gameData.filter({ gameData -> Bool in
                gameData.gameName!.lowercased().contains(searchText.lowercased())
            })
        gameDataTableView.reloadData()
    }
}

/// Creating an extension for class
extension MasterViewController: LoadingTableView {
    func loadTableView() {
        loadGamesData()
    }
    
}





