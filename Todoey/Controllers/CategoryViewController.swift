//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Abdelhamid Naeem on 9/20/18.
//  Copyright © 2018 Abdelhamid Naeem. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
        

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.rowHeight = 80.0
        
        tableView.separatorStyle = .none
        
    }
    
     //Mark: - TableView Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return categories.count
        
        return categories?.count ?? 1
       
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row]{
            cell.textLabel!.text = category.name
            
            guard let categotyColor = UIColor(hexString: category.color) else {fatalError()}
            
            cell.backgroundColor = categotyColor
            
            cell.textLabel?.textColor = ContrastColorOf(categotyColor, returnFlat: true)
            
        }
        
        return cell
    }
    
    //Mark: - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    //Mark: - Data Manipulation Method
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add ", style: .default) { (action) in
            
            //what will happen when the user hit add button
            
//            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
//            self.categories.append(newCategory)
            
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func save(category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("error saving content \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    func loadCategories(){
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //delete from swipe
    override func updateModel(at indexPath: IndexPath) {
            if let categoryOfDeletion = self.categories?[indexPath.row]{
                do{
                    try! self.realm.write {
                        self.realm.delete(categoryOfDeletion)
                    }
                } catch {
                    print("Error Deleting Category \(error)")
                }

            }
    }
    
}


