//
//  ModelFirebase.swift
//  Amigo
//
//  Created by אביעד on 22/01/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//

import Foundation
import Firebase

class ModelFirebase{
    
    var city : String?
    
    func add(user:User){
        let db = Firestore.firestore()
        let json = user.toJson();
        db.collection("users").document(user.id).setData(json){
            err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                ModelEvents.UserDataEvent.post();
            }
        }
    }
    
    func addPost(post:Post){
        let db = Firestore.firestore()
        //        var ref: DocumentReference? = nil
        let json = post.toJson();
        db.collection("posts").document(post.id).setData(json){
            err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                ModelEvents.PostDataEvent.post();
            }
        }
    }
    
    func deletePost(postId :String){
        print("momo20")
        print(postId)
        let db = Firestore.firestore()
        //        var ref: DocumentReference? = nil
        db.collection("posts").document(postId).delete(){
            err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                ModelEvents.PostDataEvent.post();
            }
        }
    }
    
    
    
    func getAllPosts(since:Int64, callback: @escaping ([Post]?)->Void){
        let db = Firestore.firestore()
        db.collection("posts").order(by: "lastUpdate").start(at: [Timestamp(seconds: since, nanoseconds: 0)]).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                callback(nil);
            } else {
                var data = [Post]();
                db.collection("cities").getDocuments { (snapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for documents in snapshot!.documents {
                            self.city = documents.get("title") as? String
                        }
                        print("gabi")
                        print(self.city)
                    }
                    
                    
                    for document in querySnapshot!.documents {
                        print(document.get("title") as! String)
                        print("hila")
                        print(self.city)
                        
                        if(document.get("title") as! String == self.city){
                            
                            if let ts = document.data()["lastUpdate"] as? Timestamp{
                                let tsDate = ts.dateValue();
                                print("\(tsDate)");
                                let tsDouble = tsDate.timeIntervalSince1970;
                                print("\(tsDouble)");
                                
                            }
                            print(document.data())
                            
                            data.append(Post(json: document.data()));
                            print("kobi")
                            print(data.append(Post(json: document.data())))
                            
                        }
                    }
                    callback(data);
                    print("shirshir")
                    
                }
            }
        };
    }
}

