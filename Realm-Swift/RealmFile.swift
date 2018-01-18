//
//  RealmFile.swift
//  Realm-Swift
//
//  Created by Omnipro Technologies on 13/09/17.
//  Copyright © 2017 Omnipro Technologies. All rights reserved.
//

import RealmSwift

class list: Object {
    
    dynamic var listName = ""
    dynamic var id : Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
