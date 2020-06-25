//
//  FirebaseStorage.swift
//  Amigo
//
//  Created by אביעד on 22/01/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class FirebaseStorage {
    static func saveImage(image:UIImage, callback:@escaping (String)->Void){
        let storageRef = Storage.storage().reference(forURL:
            "gs://amigo-e1b90.appspot.com")
        let data = image.jpegData(compressionQuality: 0.5)
        let imageRef = storageRef.child(Auth.auth().currentUser!.uid)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(data!, metadata: metadata) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return
                }
                print("url: \(downloadURL)")
                callback(downloadURL.absoluteString)
            }
        }
    }
    
    
    static func saveImagePost(image:UIImage, callback:@escaping (String)->Void){
        let storageRef = Storage.storage().reference(forURL:
            "gs://amigo-e1b90.appspot.com")
        let data = image.jpegData(compressionQuality: 0.5)
        var db : Firestore!
        db = Firestore.firestore()
        let imageRef = storageRef.child(db.collection("posts").document().documentID)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(data!, metadata: metadata) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return
                }
                print("url: \(downloadURL)")
                callback(downloadURL.absoluteString)
            }
        }
    }
    
}
