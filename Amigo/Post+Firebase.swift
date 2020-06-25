//
//  Post+Firebase\.swift
//  Amigo
//
//  Created by אביעד on 09/03/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//

import Foundation
import Firebase

extension Post{
    
    convenience init(json:[String:Any]){
        let id = json["id"] as! String
        self.init(id:id)
        placeImage = json["placeImage"] as! String
        placeLocation = json["placeLocation"] as! String
        recText = json["recText"] as! String
        title = json["title"] as! String
        userName = json["userName"] as! String
        userId = json["userId"] as! String
        postId = json["postId"] as! String
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]();
        json["id"] = id
        json["lastUpdate"] = FieldValue.serverTimestamp()
        json["placeImage"] = placeImage
        json["placeLocation"] = placeLocation
        json["recText"] = recText
        json["title"] = title
        json["userName"] = userName
        json["userId"] = userId
        json["postId"] = postId
        return json;
    }
    
}
