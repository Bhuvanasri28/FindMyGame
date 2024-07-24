//
//  LoginPageViewController.swift
//  FindMyGame
//
//  Created by Bhuvana on 26/09/18.
//  Copyright © 2018 capgemini. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginPageViewController: UIViewController,UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Do any additional setup after loading the view.
    }
    
    /// Creating Objects for UIWindow, Networlcalls, GameInfo
    var window : UIWindow!
    var networkObj = NetworkCalls()
    var games = [GameInfo]()
    
    /// Creating object for Class UserDataManager
    var userDataManager = UserDataManager()
    
    /// Creating a Static object for type of user
    static var typeOfUser = ""

    /// Creating Outlets for username and password fields from storyboard
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passWordField: UITextField!
    
    /// Creating Login Button Action
    @IBAction func loginBtnAction(_ sender: UIButton) {
        
        if let username = userNameField.text, let password = passWordField.text {
            
            /// Validating Users username
            if let userobj = userDataManager.getRequiredData(user : username){
                
                /// Validating Users password
                if userobj.password == password{
                    
                    /// Assigning typeOfUser as Present user's type
                    LoginPageViewController.typeOfUser = userobj.typeofuser!
                    
                    /// Calling fetching function to fetch data and store in core data
                    fetchingGamesData()
                }
                else {
                    showAlertMessage(message: "InCorrect Password!!")
                    self.passWordField.text = ""
                }
            }
            else{
                showAlertMessage(message: "InCorrect Username!!")
            }
        }
        //Looks for single or multiple taps.
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
     Standard Alert function to display alert boxes on the screen.
     - Parameter message: The message string to be displayed in the alert box.
     */
    func showAlertMessage(message: String) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    /**
        * Creating a function to fetch data using userDefaults to avoid duplicates
        * Creating a variable spinner and initialising with MBProgressHUD to show the ProgressHud
        * Fetching data using networkObj object and storing that data in games objects which is an object for class GameInfo
        * Storing data that is in the games object in the coredata using addGamesData Function i.e; in UserDataManager Class
        * Displaying Master View Scene by calling function showMasterViewScene()
    */
    func fetchingGamesData() {
        let fetching = UserDefaults.standard.bool(forKey: "ONE_TIME_FETCH")
        if !fetching {
            let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
            spinner.label.text = "Loading"
            networkObj.fetchData { (data) in
                if let content = data{
                    self.games = content
                    for game in self.games {
                        self.userDataManager.addGamesData(gameObject: game)
                    }
                    DispatchQueue.main.async {
                        spinner.hide(animated: true, afterDelay: 5.0)
                        self.showMasterViewScene()
                    }
                }
            }
        }
        else {
           showMasterViewScene()
        }
        UserDefaults.standard.set(true, forKey: "ONE_TIME_FETCH")
    }
    
    /**
        * Function to show MasterViewController
        * By using the identifier of SpliViewController we are instantiating
        * using appdelegate we are setting SplitViewController as rootViewController
        * Presneting the SpliViewController
     */
    func showMasterViewScene() {
        if let splitView = self.storyboard?.instantiateViewController(withIdentifier: "SplitViewScene"){
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = splitView
            self.present(splitView, animated: true , completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Resets the text fields.
        userNameField.text = ""
        passWordField.text = ""
        userNameField.underlined()
        passWordField.underlined()
    }

}

/// extension for UITextField for underlined border i.e; bottom border for the UITextFiel
extension UITextField {
    /**
        * Creating a function to underline the text fields
     */
    func underlined(){
        let border = CALayer()
        let width = CGFloat(0.7)
        border.borderColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
