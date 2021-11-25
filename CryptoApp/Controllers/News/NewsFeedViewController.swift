import UIKit
import SDWebImage

class NewsFeedViewController: UIViewController {
    
    var newsItems: [NewsItem] = []

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
   
    
    override func viewDidLoad() {
        UINavigationBar.appearance().tintColor = .purple
        super.viewDidLoad()
        handleGetData()
    }
    
    @IBAction func infoButton(_ sender: Any) {
        basicAlert(title: "About App", message: "In this application you will find a lot of information about cryptocurrency, such as: news, startups and cryptocurrency prices in real time. Enjoy!")
    }
    func activityIndicator(animated: Bool){
        DispatchQueue.main.async {
            if animated{
                self.activityIndicatorView.isHidden = false
                self.activityIndicatorView.startAnimating()
            }else{
                self.activityIndicatorView.isHidden = true
                self.activityIndicatorView.stopAnimating()
            }
        }
    }

    func handleGetData(){
        activityIndicator(animated: true)
        let jsonUrl = "https://newsapi.org/v2/everything?q=crypto&from=2021-11-23&to=2021-11-23&sortBy=popularity&apiKey=5594193b86624fd1a382fa3c17a07d0b"
        
        guard let url = URL(string: jsonUrl) else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        //urlsession
        URLSession(configuration: config).dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                print((error?.localizedDescription)!)
                self.basicAlert(title: "Error!", message: "\(String(describing: error?.localizedDescription))")
                return
            }
            
            guard let data = data else {
                self.basicAlert(title: "Error!", message: "Something weng wrong, no data.")
                return
            }
            
            do{
                let jsonData = try JSONDecoder().decode(Articles.self, from: data)
                self.newsItems = jsonData.articles
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                    self.activityIndicator(animated: false)
                }
            }catch{
                print("err:", error)
            }
            
        }.resume()
    }
}

extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "appleCell", for: indexPath) as? NewsTableViewCell else {return UITableViewCell()}
        
        let item = newsItems[indexPath.row]
    
        cell.newsTitleLabel.text = item.title
        cell.dateLabel.text = item.publishedAt
            .replacingOccurrences(of: "T", with: " ")
            .replacingOccurrences(of: "Z", with: "")
        cell.newsTitleLabel.numberOfLines = 0
        cell.newsImageView.sd_setImage(with:URL(string: item.urlToImage), placeholderImage: UIImage(named: "news.png"))
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storybord = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storybord.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {return}
        let item = newsItems[indexPath.row]
        vc.newsImage = item.urlToImage
        vc.titleString = item.title
        vc.webUrlString = item.url
        vc.contentString = item.description
        
//        present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

