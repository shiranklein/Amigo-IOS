//
//  User+Firebase.swift
//  Amigo
//
//  Created by אביעד on 22/01/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//

import Foundation
import Firebase

extension User{
    convenience init(json:[String:Any]){
        let id = json["id"] as! String;
        self.init(id:id)
        
        fullname = json["fullname"] as! String;
        ImagAvatr = json["avatar"] as! String;
        email = json["email"] as! String;
        let ts = json["lastUpdate"] as! Timestamp
        lastUpdate = ts.seconds
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]();
        json["id"] = id
        json["fullname"] = fullname
        json["avatar"] = ImagAvatr
        json["email"] = email
        json["lastUpdate"] = FieldValue.serverTimestamp()
        return json;
    }
    
}
