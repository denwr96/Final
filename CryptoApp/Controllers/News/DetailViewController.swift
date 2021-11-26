/*
   CryptoViewController.swift
   CryptoApp
 
   Created by Denis Lobach on 24/11/2021.
 
 */

import UIKit
import SDWebImage
import CoreData

class DetailViewController: UIViewController {
    
    @IBOutlet weak var savedButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var contentTextView: UILabel!
    
    var savedItems = [Items]()
    var context: NSManagedObjectContext?
    
    var webUrlString = String()
    var titleString = String()
    var contentString = String()
    var newsImage = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().tintColor = .purple
        titleLabel.text = titleString
        contentTextView.text = contentString
        newsImageView.sd_setImage(with: URL(string: newsImage), placeholderImage: UIImage(named: "news.png"))
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        loadData()
        
        for item in savedItems {
            if item.newsTitle == titleString {
                savedButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
        }
    }
    
    /*
      Saving datas to CoreData function
     */
    
    func saveData(){
        do{
            
            try context?.save()
            basicAlert(title: "Saved!", message: "To see your saved article, click on the heart at the top.")
        }catch{
            print(error.localizedDescription)
        }
    }
    
    /*
      Loading datas from CoreData
     */
    
    func loadData(){
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        do {
            savedItems = try (context?.fetch(request))!
            
        }catch{
            fatalError("Error in retrieving Saved Items")
        }
        
    }
    
    /*
      Saving article to Favourite list button
     */
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        for item in savedItems {
            if item.newsTitle == titleString {
                basicAlert(title: "Failed!", message: "This article is already in Favourites list")
                return
            }
        }

        /*
         Preparing new item for saving it in CoreData
         */
        
        let newItem = Items(context: self.context!)
        newItem.newsTitle = titleString
        newItem.newsContent = contentString
        newItem.url = webUrlString
        
        if !newsImage.isEmpty{
            newItem.image = newsImage
        }
        
        self.savedItems.append(newItem)
        saveData()
        basicAlert(title: "Saved!", message: "To see your saved article, click on the heart at the top.")
        savedButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    }
    
    
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let destinationVC: WebViewController = segue.destination as! WebViewController
        
        destinationVC.urlString = webUrlString
        // Pass the selected object to the new view controller.
    }
    
    
}
