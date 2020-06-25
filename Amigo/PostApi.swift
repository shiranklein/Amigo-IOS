//
//  PostApi.swift
//  Amigo
//
//  Created by אביעד on 20/01/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//

import Foundation
import FirebaseDatabase


class PostApi{
    var REF_POSTS = Database.database().reference().child("posts")
 
    
    func observePosts(completion : @escaping (PostUser) -> Void){
        REF_POSTS.observe(.childAdded) { (snapshot:DataSnapshot) in
            if let dict = snapshot.value as? [String:Any] {
                let newpost : PostUser = PostUser.transformPostFromJson(json: dict , key: snapshot.key)
                completion(newpost)
            }
        }
    }
    func observePost(withId id: String, completion: @escaping (PostUser) -> Void){
     REF_POSTS.child(id).observeSingleEvent(of: DataEventType.value, with: {snapshot in
     if let dict = snapshot.value as? [String: Any] {
         let post = PostUser.transformPostFromJson(json: dict, key: snapshot.key)
         completion(post)
         }
     })
 }
 
 func observeLikeCount(withPostId id : String , completion: @escaping (Int) -> Void) {
     Api.PostUser.REF_POSTS.child(id).observe(.childChanged) { (snapshot :DataSnapshot) in
         if let count = snapshot.value as? Int {
             completion(count)
         }
     }
 }
func observeTopPosts(completion: @escaping (PostUser) -> Void){
     REF_POSTS.queryOrdered(byChild: "likeCount").observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
         let arrSnapshot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
         arrSnapshot.forEach({ (child :DataSnapshot) in
             if let dict = child.value as? [String: Any]{
                 let post = PostUser.transformPostFromJson(json: dict, key: child.key)
                 completion(post)
             }
         })
     }
 }
func observePosts(completion: @escaping ([PostUser]) -> Void){
    REF_POSTS.observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
        let arrSnapshot = (snapshot.children.allObjects as! [DataSnapshot])
        var posts = [PostUser]()
        arrSnapshot.forEach({ (child :DataSnapshot) in
            if let dict = child.value as? [String: Any]{
                let post = PostUser.transformPostFromJson(json: dict, key: child.key)
                posts.append(post)
            }
        })
        completion(posts)
    }
}

}
