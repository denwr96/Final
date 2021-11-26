/*
   CryptoViewController.swift
   CryptoApp
 
   Created by Denis Lobach on 24/11/2021.
 
 */

import UIKit
import CoreData
import SDWebImage

var savedItems = [Items]()
var context: NSManagedObjectContext?

class SavedTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        UINavigationBar.appearance().tintColor = .purple
        tableView.reloadData()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        loadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
        countItemsInSavedItems()
    }
    
    /*
       Change navigation bar title function, and counting elements inside Favourite list
     */
    
    func countItemsInSavedItems() {
        if savedItems.isEmpty {
            title = "Favourite artilces is empty"
            tableView.reloadData()
            
        } else {
            title = "Favourite articles (\(savedItems.count))"
            tableView.reloadData()
        }
    }
    
    /*
      Saving datas to CoreData function
     */
    
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
    
    /*
      Loading datas from CoreData function
     */
    
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
        
        var numOfSections: Int = 0
        if !savedItems.isEmpty {
            tableView.separatorStyle = .singleLine
            numOfSections = 1
            tableView.backgroundView = nil
        }
        else {
            
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "Favourite list is empty"
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
        return numOfSections
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    /*
      Deleting datas from CoreData function
     */
    
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
