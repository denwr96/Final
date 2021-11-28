/*
   CryptoViewController.swift
   CryptoApp
 
   Created by Denis Lobach on 24/11/2021.
 
 */

import UIKit
import SDWebImage

class BlogDetailViewController: UIViewController {

    var blog: Blog!
    var webUrlString = String()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        UINavigationBar.appearance().tintColor = .purple
        super.viewDidLoad()
        
        if blog != nil {
            titleLabel.text = blog.title!
            contentLabel.text = blog.content!
            timeLabel.text = blog.time!
            authorLabel.text = blog.author
            imageView.sd_setImage(with:URL(string: blog.imageUrl!), placeholderImage: UIImage(named: "news.png"))
        }
    }
    

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC: WebViewController = segue.destination as! WebViewController
        destinationVC.urlString = webUrlString
    }
}
