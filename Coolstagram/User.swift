//
//  User.swift
//  Coolstagram
//
//  Created by Pavan Sabnis on 1/6/18.
//  Copyright © 2018 Pavan Sabnis. All rights reserved.
//

import Foundation

//import theDattaSnapshot stuf
import FirebaseDatabase.FIRDataSnapshot

class User {
    
    //Mark: - Properties
    
    let uid : String
    let username : String
    
    //Mark: - Init
    
    //equivalent of a constructor in Java, since this is a class meant to be instantiated
    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
    }
    
    // The failable initializer
    init?(snapshot: DataSnapshot) {
        
        // Without the uid, the snapshot cannot be casted to a dictionary
        // Without a username, the initialization will not be complete
        // Therefore, the guard statement makes sure nil is returned either way as a safety
        // This is useful for requiring the initialization to have key information
        
        guard let dict = snapshot.value as? [String: Any],
            let username = dict["username"] as? String
            else {return nil}
        
        // The key property of snapshot is equivalent to the uid of the user
        self.uid = snapshot.key
        self.username = username
    }
    
    
    
    
}
