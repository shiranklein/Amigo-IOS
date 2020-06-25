//
//  Post+Sql.swift
//  Amigo
//
//  Created by אביעד on 09/03/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//

import Foundation
import Firebase

extension Post{
    
    static var city: String = ""
    
    static func create_table(database: OpaquePointer?){
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS POSTAMIGO (PS_ID TEXT PRIMARY KEY, TITLE TEXT, PLACELOCATION TEXT,PLACEIMAGE TEXT,USERNAME TEXT,RECTEXT TEXT,USERID TEXT,POSTID TEXT)", nil, nil,&errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    func addToDb(){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(ModelSql.instance.database,"INSERT OR REPLACE INTO POSTAMIGO (PS_ID, TITLE, PLACELOCATION,PLACEIMAGE,USERNAME,RECTEXT,USERID,POSTID) VALUES (?,?,?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let id = self.id.cString(using: .utf8)
            let title = self.title.cString(using: .utf8)
            let placeLocation = self.placeLocation.cString(using: .utf8)
            let placeImage = self.placeImage.cString(using: .utf8)
            let userName = self.userName.cString(using: .utf8)
            let recText = self.recText.cString(using: .utf8)
            let userId = self.userId.cString(using: .utf8)
            let postId = self.postId.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, title,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, placeLocation,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, placeImage,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, userName,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 6, recText,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 7, userId,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 8, postId,-1,nil);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    
    func UpdateDb(){
        var sqlite3_stmt: OpaquePointer? = nil
        
        print(Model.instance.postID)
        print("good3")
        if (sqlite3_prepare_v2(ModelSql.instance.database,"INSERT OR REPLACE INTO POSTAMIGO (TITLE, PLACELOCATION,PLACEIMAGE,USERNAME,RECTEXT,USERID,POSTID) VALUES (?,?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            //  let id = self.id.cString(using: .utf8)
            let title = self.title.cString(using: .utf8)
            let placeLocation = self.placeLocation.cString(using: .utf8)
            let placeImage = self.placeImage.cString(using: .utf8)
            let userName = self.userName.cString(using: .utf8)
            let recText = self.recText.cString(using: .utf8)
            let userId = self.userId.cString(using: .utf8)
            let postId = self.postId.cString(using: .utf8)
            
            // sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, title,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, placeLocation,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, placeImage,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, userName,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 6, recText,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 7, userId,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 8, postId,-1,nil);
            print("good")
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
                print("good2")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    
    
    
    static func getAllPostsFromDb()->[Post]{
        let db = Firestore.firestore()
        
        //change the title of the page to the pin that pressed
        db.collection("cities").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    self.city = document.get("title") as! String
                }
            }
        }
        
        var sqlite3_stmt: OpaquePointer? = nil
        var data = [Post]()
        
        if (sqlite3_prepare_v2(ModelSql.instance.database,"SELECT * from POSTAMIGO WHERE TITLE LIKE '%\(self.city)%';",-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                
                let poId = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let po = Post(id: poId);
                po.title = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                po.placeLocation = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                po.placeImage = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                po.userName = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
                po.recText = String(cString:sqlite3_column_text(sqlite3_stmt,5)!)
                po.userId = String(cString:sqlite3_column_text(sqlite3_stmt,6)!)
                po.postId = String(cString:sqlite3_column_text(sqlite3_stmt,7)!)
                
                data.append(po)
            }
        }
        
        
        sqlite3_finalize(sqlite3_stmt)
        return data
    }
    
    
    func deleteFromDb(postIds : String){
        print(postIds)
        print("herehere")
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(ModelSql.instance.database,"DELETE FROM POSTAMIGO WHERE POSTID LIKE  '%\(postIds)%';",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, title,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, placeLocation,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, placeImage,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, userName,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 6, recText,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 7, userId,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 8, postId,-1,nil);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func setLastUpdate(lastUpdated:Int64){
        return ModelSql.instance.setLastUpdate(name: "POSTAMIGO", lastUpdated: lastUpdated);
    }
    
    static func getLastUpdateDate()->Int64{
        return ModelSql.instance.getLastUpdateDate(name: "POSTAMIGO")
    }
    
}
