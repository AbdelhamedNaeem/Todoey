//
//  ViewController.swift
//  Todoey
//
//  Created by Abdelhamid Naeem on 9/3/18.
//  Copyright © 2018 Abdelhamid Naeem. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController{

    var todoItems :Results<Item>?
    
    let realm = try! Realm()
    
    let item = Item()
    
    var selectedCategory : Category? {
        didSet{                                 //should happen when a variable gets a new value.
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        
    }
   
    
    // Tableview Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        
        cell.textLabel?.text = item.title
       
        cell.accessoryType = item.done ? .checkmark : .none
      
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    // Tableview Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                    
            }
            }catch{
                print("error saving done status\(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    // Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            //what will happen when the user hit add button
                        
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateOfCreated = Date()
                        currentCategory.items.append(newItem)
                        
                    }
                   
                }catch{
                    print("Error Saving new items , \(error)")
                }
            }
            
            self.tableView.reloadData()
        
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField

        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
   
    func loadItems(){

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
  
    
    
    
}

//MARK :- Search Bar Method

extension TodoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateOfCreated", ascending: true)
        
        if searchBar.text == "" {
            loadItems()
            searchBar.resignFirstResponder() //dismiss keyboard
        }
        
        tableView.reloadData()
    }

    
    func searchBar(_ searchBar : UISearchBar, textDidChange: String ){
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}















