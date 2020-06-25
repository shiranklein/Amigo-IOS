//
//  User.swift
//  Amigo
//
//  Created by אביעד on 11/01/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//

import Foundation
class User {
    var email:String = ""
    var name:String = ""
    var gender:String = ""
    var password:String = ""
    var country:String = ""
    var avatar:String = ""
    
    init(email:String, name:String, gender:String,password:String,country:String,avatar:String){
        self.email = email
        self.name = name
        self.gender = gender
        self.password = password
        self.country = country
        self.avatar = avatar
    }
    
    init(json:[String:Any]){
        self.email = json["id"] as! String;
        self.name = json["name"] as! String;
        self.gender = json["gender"] as! String;
        self.password = json["password"] as! String;
        self.country = json["country"] as! String;
        self.avatar = json["avatar"] as! String;
    }
    
    func toJson() -> [String:String] {
        var json = [String:String]();
        json["email"] = email
        json["name"] = name
        json["gender"] = gender
        json["password"] = password
        json["country"] = country
        json["avatar"] = avatar
        return json;
    }
    
    
}
