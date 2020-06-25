//
//  UserApi.swift
//  Amigo
//
//  Created by אביעד on 18/01/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//

import Foundation
import Firebase

class UserApi{
    var REF_USERS = Database.database().reference().child("users")
    
    func observeUser(withId uid : String,completion : @escaping (User) -> Void){
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
            if let dict = snapshot.value as? [String:Any] {
                let newuser : User = User.transformUserFromJson(json: dict, key: snapshot.key)
                completion(newuser)
            }
        }

    }
    
    
    func queryUser(withText text:String,completion : @escaping (User) -> Void){
        REF_USERS.queryOrdered(byChild: "username_lowercase").queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").queryLimited(toFirst: 10).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            snapshot.children.forEach({ (s) in
                let child = s as! DataSnapshot
                if let dict = child.value as? [String:Any] {
                    let user : User = User.transformUserFromJson(json: dict, key: child.key)
                    completion(user)
                }
            })
        }
    }
    
    
    var CURRENT_USER : Firebase.User?{
        if let currentUser = Auth.auth().currentUser {
            return currentUser
        }
        return nil
    }
    
    var RefCurrentUser: DatabaseReference? {  //pointing to the current user
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }
        return REF_USERS.child(currentUser.uid)
    }
    
    func observeCurrentUser(completion: @escaping (User)-> Void){
        guard let currentUser = Auth.auth().currentUser else {return}
        
        REF_USERS.child(currentUser.uid).observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
            if let dict = snapshot.value as? [String:Any] {
                let user = User.transformUserFromJson(json: dict, key: snapshot.key)
                completion(user)
            }
        }
    }
    
    func observeUsers(completion: @escaping (User)-> Void){
        REF_USERS.observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String:Any] {
                let user = User.transformUserFromJson(json: dict, key: snapshot.key)
                completion(user)
            }
        }
    }
    
    func observeUsers(completion: @escaping ([User])-> Void){
        REF_USERS.observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            //print("snapshot: \(snapshot)")
            let arrSnapshot = (snapshot.children.allObjects as! [DataSnapshot])
            var users = [User]()
            arrSnapshot.forEach({ (child :DataSnapshot) in
                if let dict = child.value as? [String: Any]{
                    let user = User.transformUserFromJson(json: dict, key: child.key)
                    users.append(user)
                }
            })
            completion(users)
        }
    }
}
