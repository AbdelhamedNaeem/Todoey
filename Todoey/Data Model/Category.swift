//
//  Category.swift
//  Todoey
//
//  Created by Abdelhamid Naeem on 10/2/18.
//  Copyright © 2018 Abdelhamid Naeem. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    @objc dynamic var name : String = ""
    let items = List<Item>()

}
