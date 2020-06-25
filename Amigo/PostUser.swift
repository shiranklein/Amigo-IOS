////
////  PostUser.swift
////  Amigo
////
////  Created by אביעד on 20/01/2020.
////  Copyright © 2020 Shiran Klein. All rights reserved.
////
//
//import Foundation
//import FirebaseAuth
//
//class PostUser :  Hashable {
//    static func == (lhs: PostUser, rhs: PostUser) -> Bool {
//        return (lhs.hashValue == rhs.hashValue)
//    }
//    
//    var hashValue: Int {
//        return (self.id).hashValue
//    }
//    
//    var uid : String?
//    var caption : String?
//    var photoUrl : String?
//    var id : String?
//    var createAt :Int?
//    var lastUpdate : Double?
//    
//}
//
//extension PostUser{
//
//static func transformPostFromJson(json : [String : Any] , key : String) -> PostUser{
//    let post : PostUser = PostUser()
//    post.id = key
//    post.uid = json["uid"] as? String
//    post.caption = json["caption"] as? String
//    post.photoUrl = json["photoUrl"] as? String
//    post.createAt = json["createAt"] as? Int ?? 0
//    post.lastUpdate = json["lastUpdate"] as? Double ?? json["createAt"] as? Double ?? 0
//    return post
//}
//
//
//static func transformPostToJson(post : PostUser) -> [String : Any]{
//     var json = [String: Any]()
//     json["uid"] = post.uid
//     json["caption"] = post.caption
//     json["photoUrl"] = post.photoUrl
//     json["createAt"] = post.createAt ?? 0
//     json["lastUpdate"] = post.lastUpdate ?? post.createAt ?? 0
//     return json
// }
//
//}
