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
var categories: Results<list1> = { realm.objects(list1.self) }()

class ViewController: UIViewController {
    
    @IBOutlet weak var TextView: UITextView!
    @IBOutlet weak var TableView: UITableView!
    
    let cellReuseIdentifier = "cell"
    let RealmObject = realm.objects(list1.self)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        TableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        TableView.delegate = self
        TableView.dataSource = self
        
        let PrimaryCount = [1,2,3,4,5]
        print(PrimaryCount.map{$0})

        print(Realm.Configuration.defaultConfiguration.fileURL ?? "*** No URL ***")
        
        print("Start .....")
        insertTheValue()
    }
    
    func insertTheValue() {
        
        if categories.count == 0 { // 1
        
            try! realm.write() { // 2
                
                let defaultCategories = ["Birds", "Mammals", "Flora", "Reptiles", "Arachnids" ] // 3
                let PrimaryCount = [1,2,3,4,5]
                var i = 0
                
                for category in defaultCategories  { // 4
                    let newCategory = list1()
                    newCategory.listName = category
                    newCategory.id = PrimaryCount[i]
                    realm.add(newCategory)
                    i += 1
                }
            }
            
            categories = realm.objects(list1.self) // 5
            print(categories)
        }

    }
    
    @IBAction func GetActionButton(_ sender: Any) {
        
        var str = ""
        for index in 0..<RealmObject.count {
            str += "\(RealmObject[index])\n"
        }
        self.TextView.text = str
    }
    
    
    // Update the Value
    func editTheValue( PredicedValue: String, UpdatedValue : String) {
        print( PredicedValue, UpdatedValue)
        
        let workouts = self.RealmObject.filter("listName = %@", PredicedValue)
        
        let realm = try! Realm()
        if let workout = workouts.first {
            try! realm.write {
                
                workout.listName = UpdatedValue
                self.TableView.reloadData()
            }
        }
    }
    
    
    // Delete the Value
    func deleteTheValue(PredicatedValue : Object) {
        
        let realm = try! Realm()
        try! realm.write({
            
            realm.delete(PredicatedValue)
            self.TableView.reloadData()
        })
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RealmObject.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.TableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        cell.textLabel?.text = RealmObject[indexPath.row].listName
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        

        let editButtonTap = UITableViewRowAction(style: .normal, title: "Edit") { action, index in

            let detail = self.RealmObject[editActionsForRowAt.row].listName
            self.editTheValue(PredicedValue: detail, UpdatedValue: "")

        }
        editButtonTap.backgroundColor = .lightGray
        
        let share = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("Delete button tapped")
            
            let detail = self.RealmObject[editActionsForRowAt.row]
            self.deleteTheValue(PredicatedValue: detail)
            self.TableView.deleteRows(at: [editActionsForRowAt], with: .fade)
            
        }
        share.backgroundColor = .blue
        return [share, editButtonTap]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}


/* 
    https://www.appcoda.com/realm-database-swift/
    https://realm.io/docs/get-started/installation/mac/
    https://www.raywenderlich.com/112544/realm-tutorial-getting-started
    https://medium.com/@skoli/using-realm-and-charts-with-swift-3-in-ios-10-40c42e3838c0
 */
