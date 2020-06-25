//
//  AuthUsers.swift
//  Amigo
//
//  Created by אביעד on 18/01/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import ProgressHUD
class AuthUsers {
    
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        })
        
    }
    
    static func signUp(username: String, email: String, password: String,imageData: Data, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult :AuthDataResult?, error: Error?) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            let uid = authDataResult?.user.uid
            let storageRef = Storage.storage().reference().child("profile_image").child(uid!)

            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    return
                }
                storageRef.downloadURL(completion: { (url :URL?, error :Error?) in
                    if error != nil {
                        onError(error!.localizedDescription)
                        return
                    }
                    self.setUserInfomation(profileImageUrl: url!.absoluteString, username: username, email: email, uid: uid!, onSuccess: onSuccess)
                })
            })
        }
    }
    static func setUserInfomation(profileImageUrl: String, username: String, email: String, uid: String, onSuccess: @escaping () -> Void) {
        let usersReference = Api.User.REF_USERS
        let newUserReference = usersReference.child(uid)
        let user: User = User()
        user.name = username
        user.email = email
        user.profileImageUrl = profileImageUrl
        user.lastUpdate = Double(Date().timeIntervalSince1970)
        newUserReference.setValue(User.transformUserToJson(user: user))
        onSuccess()
    }
    
    
    
    
    
    
    
    //AuthHelper
    
    
    static func uploadDataToServer(data: Data, caption: String, onSuccess: @escaping () -> Void) {
        let photoIdString = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("posts").child(photoIdString)
        storageRef.putData(data, metadata: nil) { (metadata, error) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            storageRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                let photoUrl = url?.absoluteString
                self.sendDataToDatabase(photoUrl: photoUrl!, caption: caption, onSuccess: onSuccess)
            })
            
        }
    }
    
    static func sendDataToDatabase(photoUrl: String, caption: String, onSuccess: @escaping () -> Void) {
        let newPostId = Api.PostUser.REF_POSTS.childByAutoId().key
        let newPostReference = Api.PostUser.REF_POSTS.child(newPostId!)
        
        guard let currentUser = Api.User.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        
        let post:PostUser = PostUser()
        post.uid = currentUserId
        post.photoUrl = photoUrl
        post.caption = caption
        let timestamp = Int(Date().timeIntervalSince1970)
        post.createAt = timestamp
        post.lastUpdate = Double(timestamp)
        newPostReference.setValue(PostUser.transformPostToJson(post: post), withCompletionBlock: {
            (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
            
//            Api.Feed.REF_FEED.child(Api.User.CURRENT_USER!.uid).child(newPostId!).setValue(true)
//            
//            let myPostRef = Api.UserPosts.REF_USER_POSTS.child(currentUserId).child(newPostId!)
//            myPostRef.setValue(true, withCompletionBlock: { (error, ref) in
//                if error != nil {
//                    ProgressHUD.showError(error!.localizedDescription)
//                    return
//                }
//                
//                Api.Follow.REF_FOLLOWERS.child(currentUserId).observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
//                    print("users snapshot \(snapshot)")
//                    let arrSnapshot = (snapshot.children.allObjects as! [DataSnapshot])
//                    for child in arrSnapshot {
//                        Api.Feed.REF_FEED.child(child.key).child(newPostId!).setValue(true)
//                    }
//                })
//                
//            })
            ProgressHUD.showSuccess("Success")
            onSuccess()
        })
    }
    
    static func getImage(url:String, callback:@escaping (UIImage?)->Void){
        let ref = Storage.storage().reference(forURL: url)
        ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if error != nil {
                callback(nil)
            } else {
                let image = UIImage(data: data!)
                callback(image)
            }
        }
    }
}
