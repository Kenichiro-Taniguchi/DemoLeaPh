//
//  User.swift
//  DemoLeaPh
//
//  Created by 谷口健一郎 on 2016/12/20.
//  Copyright © 2016年 谷口健一郎. All rights reserved.
//

import RealmSwift

class User: Object {
    static let realm = try! Realm()
    
    dynamic var name = ""
    dynamic var userId = ""
    dynamic var email = ""
    dynamic var id = 0
    
    func save(){
        try! User.realm.write{
          User.realm.add(self)
        }
    }
}
