//
//  User+Sql.swift
//  Amigo
//
//  Created by אביעד on 22/01/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//

import Foundation

extension User{
    static func create_table(database: OpaquePointer?){
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS USER (US_ID TEXT PRIMARY KEY, FULLNAME TEXT, AVATAR TEXT, EMAIL TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    func addUserToDb(){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(ModelSql.instance.database,"INSERT OR REPLACE INTO USER(US_ID, FULLNAME, AVATAR, EMAIL) VALUES (?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let id = self.id.cString(using: .utf8)
            let fullname = self.fullname.cString(using: .utf8)
            let avatar = self.ImagAvatr.cString(using: .utf8)
            let email = self.email.cString(using: .utf8)
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, fullname,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, avatar,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, email,-1,nil);
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getAllUsersFromDb()->[User]{
        var sqlite3_stmt: OpaquePointer? = nil
        var data = [User]()
        
        if (sqlite3_prepare_v2(ModelSql.instance.database,"SELECT * from USER;",-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let stId = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let st = User(id: stId);
                st.fullname = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                st.ImagAvatr = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                st.email = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                data.append(st)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return data
    }
    
    static func setLastUpdate(lastUpdated:Int64){
        return ModelSql.instance.setLastUpdate(name: "USER", lastUpdated: lastUpdated);
    }
    
    static func getLastUpdateDate()->Int64{
        return ModelSql.instance.getLastUpdateDate(name: "USER")
    }
    
    
    
}
