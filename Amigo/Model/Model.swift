//
//  Model.swift
//  Amigo
//
//  Created by אביעד on 11/01/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//

import Foundation
class Model {
    static let instance = Model()
    
// //   var modelSql:ModelSql = ModelSql()
    var modelFirebase:ModelFirebase = ModelFirebase()
    
    private init() {
        for i in 0...0 {
            let us = User(email:String(i),name:String(i),gender:String(i),password:String(i),country:String(i),avatar:"")
            add(user:us)
        }
    }

    func add(user:User){
//        modelSql.add(student: user)l
       modelFirebase.add(user: user)
        
    }
    
    func getAllUsers()->[User]{
     //   modelFirebase.getAllUsers(callback: callback);
// //       return modelSql.getAllStudents()
//        modelFirebase.getAllStudents();
        modelFirebase.getAllUsers()
    }
    
}
