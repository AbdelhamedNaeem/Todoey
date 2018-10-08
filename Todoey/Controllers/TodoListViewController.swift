//
//  ViewController.swift
//  Todoey
//
//  Created by Abdelhamid Naeem on 9/3/18.
//  Copyright © 2018 Abdelhamid Naeem. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{

    var todoItems :Results<Item>?
    
    let realm = try! Realm()
    
    let item = Item()
    
    var selectedCategory : Category? {
        didSet{                                 //should happen when a variable gets a new value.
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {     //happen bafore viewDidLoad
      
        title = selectedCategory?.name
       
        guard let colorHex = selectedCategory?.color else{fatalError()}

        updateNavBar(withHexCode: colorHex )
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    // MARK: - nav bar setup method
    
    func updateNavBar(withHexCode colorHexCode: String){
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist")}
        
            if let navBarColor = UIColor(hexString: (colorHexCode)){
                navBar.barTintColor = navBarColor
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
                searchBar.tintColor = navBarColor
            }
    }
   
    
    // Tableview Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
     
        if let item = todoItems?[indexPath.row] {
        
        cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: (selectedCategory?.color)!)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                
                cell.backgroundColor = color
                
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            
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
  
    override func updateModel(at indexPath: IndexPath) {
                    if let itemOfDeletion = self.todoItems?[indexPath.row]{
                        do{
                            try! self.realm.write {
                                self.realm.delete(itemOfDeletion)
                            }
                        } catch {
                            print("Error Deleting Item \(error)")
                        }
        
                    }
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







