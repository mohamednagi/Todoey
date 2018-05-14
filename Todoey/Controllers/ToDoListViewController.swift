import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

  //  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemsArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
//        context.delete(itemsArray[indexPath.row])
//        itemsArray.remove(at: indexPath.row)
        SaveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var text = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Me", style: .default) { (action) in
            let newitem = Item(context: self.context)
            newitem.title = text.text!
            newitem.done = false
            newitem.parentCategory = self.selectedCategory
            self.itemsArray.append(newitem)
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
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate? = nil){
        let Categorypredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [Categorypredicate,addtionalPredicate])
        }else{
            request.predicate = Categorypredicate
        }
//       let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [Categorypredicate,predicate])
//        request.predicate = compoundPredicate
        do{
            itemsArray = try context.fetch(request)
        }catch{
            print("Error fetching data \(error)")
        }
        tableView.reloadData()
    }
}

extension ToDoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        // [cd] makes the search not case senstive
        let predicate = NSPredicate(format: "title CONTAINS [cd] %@", searchBar.text!)
        request.predicate = predicate
        let sortdescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortdescriptor]
        loadItems(with: request, predicate: predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadItems()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}

