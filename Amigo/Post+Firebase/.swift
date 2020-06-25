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
        let title = json["title"] as! String;
        self.init(title:title)

        placeImage = json["placeImage"] as! String;
        userName = json["userName"] as! String;
          recText = json["recText"] as! String;
        let ts = json["lastUpdate"] as! Timestamp
        lastUpdate = ts.seconds
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]();
        json["title"] = title
        json["placeImage"] = placeImage
        json["userName"] = userName
        json["recText"] = recText
        json["lastUpdate"] = FieldValue.serverTimestamp()
        return json;
    }
    
}
