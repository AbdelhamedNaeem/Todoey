//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Abdelhamid Naeem on 9/20/18.
//  Copyright © 2018 Abdelhamid Naeem. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var itemArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()

    }
     //Mark: - TableView Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.name
       
        return cell
    }
    
    
    //Mark: - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //Mark: - Data Manipulation Method
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add ", style: .default) { (action) in
            
            //what will happen when the user hit add button
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let newItem = Category(context: self.context)
            newItem.name = textField.text!
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    func saveItems(){
        do{
            try context.save()
        }catch{
            print("error saving content \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadItems(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    
}


extension CategoryTableViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
        
        print( "searvh bar texttt \(searchBar.text!)")
        
        if searchBar.text == "" {
            loadItems()
            searchBar.resignFirstResponder()
        }
        
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




