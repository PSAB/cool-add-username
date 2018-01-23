//
//  LoginViewController.swift
//  Coolstagram
//
//  Created by Pavan Sabnis on 12/4/17.
//  Copyright © 2017 Pavan Sabnis. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

// Can be used to access the instantaneous User object that's logging in
typealias FIRuser = FirebaseAuth.User
var AuthProcessFinished: Bool = false

class LoginViewController: UIViewController {
    //Fixed width could be causing a future layout error with tagline label
    //Create both an IBOutlet and IBAction for the button
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        print("Login button tapped")
        
        //access the FUIAuth default auth UI singleton
        guard let authUI = FUIAuth.defaultAuthUI() // access from FirebaseAuthUI, responsbile for sign-in interface from Firebase
            else {return}
        
        //set LoginViewController class as delegate of authUI. BUT WHAT DOES THIS DO? 
        //POSSIBLE FUTURE ERROR HERE
        authUI.delegate = self
        //access and present our authViewController
        let authViewController = authUI.authViewController()
//        TEMPORARILY COMMENT OUT PRESENTING THE AUTHVIEWCONTROLLER
        present(authViewController, animated: true)
        print("Presented the Auth View controller")
        
    }
    
    
    
}

// make our app conform to the FUIAuthDelegate protocol
//this runs after a signup/login process has completed
extension LoginViewController : FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRuser?, error: Error?) {
        //This method's parameters include the user that logged/signed in and their respective error. Make use of error handling:
        if let error = error {
            assertionFailure("There's an Error signing in dude: \(error.localizedDescription)")
            return
        }
        //let user : FIRuser? = Auth.auth().currentUser
        print("handle user signup/login")
        
        //check to see if FIRuser is not nil. IS IT EVER EVEN NIL IN THE FIRST PLACE?
        //CORRECTION: this basically checks if the user tried to log in/register, which should be the case
        guard let user = user
            else {return}
        
        //build the DatabaseReference to the location we wanna read from (THE USER UID)
        //AKA get the reference to the root of our JSON dictionary
        let userRef = Database.database().reference().child("users").child(user.uid)
        
        //read the data by handling the snapshot
        userRef.observeSingleEvent(of: .value, with: { /*[unowned self]*/ (snapshot) in
            // 4 retrieve user data from snapshot
            
            //retrieve the data from the DataSnapshot using the value property, check if it's expected type (in this case, dictionary)
            // We make use of User failable initializer so we don't have to deal w/ stringly-types key/value pairs
            if let user = User(snapshot: snapshot) {
                //if dictionary exists, the user already exists. IF not, then a new user!
                print("Welcome back, \(user.username)!")
            }
            else {
                print("New User!")
                //if there is a new user, use the segue to present the CreateUsernameViewController
                //self.performSegue(withIdentifier: "toCreateUsername", sender: self)
                self.performSegue(withIdentifier: "toCreateUsername", sender: self)
            }
            
        })
        
        
    }
}






