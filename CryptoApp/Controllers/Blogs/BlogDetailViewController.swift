//
//  BlogDetailViewController.swift
//  NewsApiOrg
//
//  Created by deniss.lobacs on 23/11/2021.
//

import UIKit
import SDWebImage

class BlogDetailViewController: UIViewController {

    var webUrlString = String()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var blog: Blog!
    
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
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let destinationVC: WebViewController = segue.destination as! WebViewController
        
        destinationVC.urlString = webUrlString
        print("DVC url: ", webUrlString)
       // destinationVC.urlString = blog[indexP]
    }

}
