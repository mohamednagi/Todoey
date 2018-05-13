import UIKit

class ToDoListViewController: UITableViewController {

//    var defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var itemsArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
//        let newitem=Item()
//        newitem.title = "get eggs"
//        itemsArray.append(newitem)
//
//        let newitem2=Item()
//        newitem2.title = "get milk"
//        itemsArray.append(newitem2)
//
//        let newitem3=Item()
//        newitem3.title = "get bananna"
//        itemsArray.append(newitem3)
//
//        let newitem4=Item()
//        newitem4.title = "get some needs"
//        itemsArray.append(newitem4)
        
//        if let items = defaults.array(forKey: "array") as? [Item]{
//            itemsArray = items
//        }
        }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemsArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = item.title
    
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemsArray[indexPath.row]
        item.done = !item.done
        SaveItems()
//        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var text = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Me", style: .default) { (action) in
            let newitem = Item()
            newitem.title = text.text!
            self.itemsArray.append(newitem)
//            self.defaults.set(self.itemsArray, forKey: "array")
           self.SaveItems()
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Create New Todoey"
            text = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func SaveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemsArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Encoder throws an Error \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(){
        
        if let data = try? Data(contentsOf: dataFilePath!){
           let decoder = PropertyListDecoder()
            do{
                itemsArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Decoder throws an Error \(error)")
            }
        }
        
    }
    
}

