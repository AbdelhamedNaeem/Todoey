//
//  AppDelegate.swift
//  Todoey
//
//  Created by Abdelhamid Naeem on 9/3/18.
//  Copyright © 2018 Abdelhamid Naeem. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      // print path of local p-list
      // print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask ,true).last! as String)
      
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
        do{
        _ = try! Realm()
            
        }catch{
            print("error initialisation new realm \(error)")
        }
      
        return true
    }

}

