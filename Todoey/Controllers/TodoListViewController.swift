//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController { //Powerful subclass. Previously it was UIViewController, but to make use of TableView I had to change it.
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
//                if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//                    itemArray = items
//                }
                 //Do any additional setup after loading the view.
        loadItems()
        
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell;
    }
    
    //MARK - TableView Delegate Methods
    //whenever we click on any cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if itemArray[indexPath.row].done == false {
            itemArray[indexPath.row].done = true
        } else {
            itemArray[indexPath.row].done = false
        }
        
        saveItems()
        
        tableView.cellForRow(at: indexPath)?.accessoryType = tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark ? .none : .checkmark
        
        // recommended to use:
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        //UIAlertController with TextField
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            
            var newItem = Item()
            newItem.title = textField.text!
            //What will happen once the user clicks the Add Item on our UIAlert
            self.itemArray.append(newItem)
            
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.saveItems()
            
            
            self.tableView.reloadData()
        }
        
        alert.addTextField(configurationHandler: { alertTextField in
            alertTextField.placeholder = "Create new item"
            //reinitialize textfield to manipulate its text
            textField = alertTextField
        })
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error")
        }
    }
    
    
    func loadItems(){
        
        
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemArray =  try decoder.decode([Item].self, from: data)
            } catch {
                
            }
            
        
        }
    }
}


