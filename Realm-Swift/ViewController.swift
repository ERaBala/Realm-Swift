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
        
    }
    
    func insertTheValue( NewValue : String) {
        
        try! realm.write() {
            
            let newCategory = list1()
            newCategory.listName = NewValue
            newCategory.id = categories.count+1
            
            realm.add(newCategory)
        }

        self.TableView.reloadData()
        categories = realm.objects(list1.self) // 5
        
    }
    
    @IBAction func GetActionButton(_ sender: Any) {
        
        alertAction(Title: "Enter the Value", Message: "", updateValue: "", Type: "New")
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
    
    func alertAction(Title : String, Message : String, updateValue : String, Type: String) {
        
        let alertController = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            if Type == "Edit"{
                self.editTheValue(PredicedValue: updateValue, UpdatedValue: firstTextField.text!)
            }else{
                self.insertTheValue(NewValue: firstTextField.text!)
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter the Value"
        }
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)

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
            self.alertAction(Title: "Add New Value", Message: "", updateValue: detail, Type: "Edit")

        }
        editButtonTap.backgroundColor = .lightGray
        
        let share = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("Delete button tapped")
            
            let detail = self.RealmObject[editActionsForRowAt.row]
            self.deleteTheValue(PredicatedValue: detail)
            
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
