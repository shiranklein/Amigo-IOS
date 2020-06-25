//
//  ModelFirebase.swift
//  Amigo
//
//  Created by אביעד on 11/01/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//

import Foundation
import Firebase

class ModelFirebase{
    
    func add(user:User){
       let db = Firestore.firestore()
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "first": "Ada",
            "last": "Lovelace",
            "last": "Lovelace",
            "last": "Lovelace",
            "born": "Lovelace",
            "born": "Lovelace"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }

    }
    
    func getAllUsers()->[User] {
        return [User]()
//        let db = Firestore.firestore()
//        db.collection("users").getDocuments { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//                callback(nil);
//            } else {
//                var data = [User]();
//                for document in querySnapshot!.documents {
//                    data.append(User(json: document.data()));
//                }
//                callback(data);
//            }
//        };
    }
}


