//
//  ViewController.swift
//  Realm-Swift
//
//  Created by Omnipro Technologies on 13/09/17.
//  Copyright © 2017 Omnipro Technologies. All rights reserved.
//

import UIKit
import RealmSwift

let realm = try! Realm()
var categories: Results<list> = { realm.objects(list.self) }()

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        populateDefaultCategories()
    }
    
    func populateDefaultCategories() {
        
        if categories.count == 0 { // 1
            
            try! realm.write() { // 2
                
                let defaultCategories = ["Birds", "Mammals", "Flora", "Reptiles", "Arachnids" ] // 3
                
                for category in defaultCategories { // 4
                    let newCategory = list()
                    newCategory.listName = category
                    realm.add(newCategory)
                }
            }
            
            categories = realm.objects(list.self) // 5
            print(categories)
        }
    }
    
    

}


/* https://www.appcoda.com/realm-database-swift/
https://realm.io/docs/get-started/installation/mac/
 https://www.raywenderlich.com/112544/realm-tutorial-getting-started
 https://medium.com/@skoli/using-realm-and-charts-with-swift-3-in-ios-10-40c42e3838c0
 */
