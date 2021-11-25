import UIKit
import CoreData
import SDWebImage


// --------------------------------------------------------------------------
var savedItems = [Items]()

var context: NSManagedObjectContext?

class SavedTableViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        
        UINavigationBar.appearance().tintColor = .purple
        tableView.reloadData()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        //context.ins
        loadData()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
        countItemsInSavedItems()
    }
    
    func countItemsInSavedItems() {
        if savedItems.isEmpty {
            title = "Favourite artilces is empty"
            tableView.reloadData()
            
        } else {
            title = "Favourite articles (\(savedItems.count))"
            tableView.reloadData()
        }
    }
    
    func saveData(){
        do{
            try context?.save()
            basicAlert(title: "Deleted!", message: "You just deleated your article from favourite list.")
            // tableView.reloadData()
        }catch{
            print(error.localizedDescription)
        }
        loadData()
    }
    
    func loadData(){
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        do {
            savedItems = try (context?.fetch(request))!
            tableView.reloadData()
        }catch{
            fatalError("Error in retrieving Saved Items")
        }
        tableView.reloadData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return savedItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "appleCell", for: indexPath) as? NewsTableViewCell else{
            return UITableViewCell()
        }
        
        let item = savedItems[indexPath.row]
        cell.newsTitleLabel.text = item.newsTitle
        cell.newsTitleLabel.numberOfLines = 0
        cell.newsImageView.sd_setImage(with: URL(string: item.image ?? ""), placeholderImage: UIImage(named: "news.png"))
        
        //        print(Items)
        // print("Saved items in savedtableVC: ", savedItems)
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    // Delet
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        if editingStyle == .delete {
            let item = savedItems[indexPath.row]
            context.delete(item)
            saveData()
            countItemsInSavedItems()
        }
    }
}
