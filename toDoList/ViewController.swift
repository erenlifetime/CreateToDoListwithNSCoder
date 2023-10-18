//
//  ViewController.swift
//  toDoList
//
//  Created by Eren lifetime on 17.10.2023.
//

import UIKit

class ViewController:UITableViewController {
    
    var itemArray:[Item]
let dataFilePath = FileManager.default.urls(for: .documentDirectory,in:"Item.plist")
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()

        print(dataFilePath)
      
        loadItems()

    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"ToDoItemCell",for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark: .none
        return cell
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        saveItems()
                tableView.deselectRow(at: indexPath, animated: true)
        
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Diary Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
            let newItem = Item()
            newItem.title = textField.text!
    // Kullanıcıdan Gelen veriyi sadece gösterir.
            self.itemArray.append(newItem)
            let encoder = PropertyListEncoder()
            do{
                let data = try encoder.encode(self.itemArray)
                try data.write(to:dataFilePath! )
            }catch{
                print("Error encoding item array, \(error)")
            }
            self.tableView.reloadData()
        }
// TextField alanı uyarıya eklendiğinde tetiklenir.
        alert.addTextField{(alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
    }
}
func saveItems(){
    let encoder = PropertyListEncoder()
    do{
        let data = try .encoder.encode(self.itemArray)
        try data.write(to: datafilePAth)
    }catch{
        print("Error encoding}\(error)")
    }
    tableView.reloadData()
}
func loadItems(){
    if let data = try? Data(contentsOf: dataFilePath!){
        let decoder = PropertyListDecoder()
        do{
            itemArray = try decoder.decode([Item].self, from: data)
        }catch{
            print("Error decoding item array \(error)")
        }
    }
}
