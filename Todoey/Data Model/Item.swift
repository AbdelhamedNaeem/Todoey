//
//  File.swift
//  Todoey
//
//  Created by Abdelhamid Naeem on 10/2/18.
//  Copyright © 2018 Abdelhamid Naeem. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateOfCreated : Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

