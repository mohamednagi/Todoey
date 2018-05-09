import UIKit

class ToDoListViewController: UITableViewController {

    var defaults = UserDefaults.standard
    var itemsArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newitem=Item()
        newitem.title = "get eggs"
        itemsArray.append(newitem)
        
        let newitem2=Item()
        newitem2.title = "get milk"
        itemsArray.append(newitem2)
        
        let newitem3=Item()
        newitem3.title = "get bananna"
        itemsArray.append(newitem3)
        
        let newitem4=Item()
        newitem4.title = "get some needs"
        itemsArray.append(newitem4)
        
        if let items = defaults.array(forKey: "array") as? [Item]{
            itemsArray = items
        }
        }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemsArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = item.title
        
//      ternary operator
        cell.accessoryType = item.done ? .checkmark : .none
//        if item.done == true{
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemsArray[indexPath.row]
        item.done = !item.done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var text = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Me", style: .default) { (action) in
            let newitem = Item()
            newitem.title = text.text!
            self.itemsArray.append(newitem)
            self.defaults.set(self.itemsArray, forKey: "array")
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

