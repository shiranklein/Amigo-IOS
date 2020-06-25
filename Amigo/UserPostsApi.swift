//
//  UserPostsApi.swift
//  Amigo
//
//  Created by אביעד on 20/01/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserPostsApi {
    var REF_USER_POSTS = Database.database().reference().child("userPosts")
    
    
    func fechUserPosts(userId : String, completion : @escaping (String)->Void) {
        REF_USER_POSTS.child(userId).observe(.childAdded) { (snapshot: DataSnapshot) in
            completion(snapshot.key)
        }
    }
    
    func fechCountUserPosts(userId : String, completion : @escaping (Int)->Void) {
        REF_USER_POSTS.child(userId).observe(.value) { (snapshot: DataSnapshot) in
            completion(Int(snapshot.childrenCount))
        }
    }
    
}
