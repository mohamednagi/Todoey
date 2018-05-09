//
//  ViewController.swift
//  Todoey
//
//  Created by Sierra on 5/9/18.
//  Copyright © 2018 Nagiz. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemsArray = ["get eggs" , "buy cheese" , "buy some banana" , "buy milk"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemsArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemsArray[indexPath.row])
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var text = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Me", style: .default) { (action) in
            self.itemsArray.append(text.text!)
            self.tableView.reloadData()
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Create New Todoey"
            text = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

