/*
   CryptoViewController.swift
   CryptoApp
 
   Created by Denis Lobach on 24/11/2021.
 
 */

import UIKit

class BlogsViewController: UIViewController {
    
    var searchResponse: SearchResponse? = nil
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private var filtred = [Blog]() // filtred items
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    /*
     Requesting data from API function
     */
    
    func request(urlString: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Request error", error)
                    completion(.failure(error))
                    return
                }
                guard let data = data else {return}
                do {
                    let values = try JSONDecoder().decode(SearchResponse.self, from: data)
                    completion(.success(values))
                    self.activityIndicator(animated: false)
                    
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        UINavigationBar.appearance().tintColor = .purple
        super.viewDidLoad()
        setupSearchBar()
        
        let urlString = "https://inshortsapi.vercel.app/news?category=startup"
        activityIndicator(animated: true)
        request(urlString: urlString) { [weak self] (result) in
            switch result {
            case .success(let searchResponse):
                self?.searchResponse = searchResponse
                self?.table.reloadData()
            case .failure(let error):
                print("error: ", error)
            }
        }
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
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    

}

extension BlogsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filtred.count
        }
        return searchResponse?.data.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "blogCell", for: indexPath) as? BlogsTableViewCell else {return UITableViewCell()}
        
        var blog: Blog
        
        if isFiltering {
            blog = filtred[indexPath.row]
        } else {
            blog = (searchResponse?.data[indexPath.row])!
        }
        
        cell.titleLabel.text = blog.title
        cell.authorLabel.text = blog.author
        cell.dateLabel.text = blog.date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = table.indexPathForSelectedRow {
            
            let blog: Blog
            
            if isFiltering {
                blog = filtred[indexPath.row]
            } else {
                blog = (searchResponse?.data[indexPath.row])!
            }
            let detailVC = segue.destination as! BlogDetailViewController
            detailVC.blog = blog
            detailVC.webUrlString = blog.url
        }
    }
    
}

extension BlogsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filtred = (searchResponse?.data.filter({ ( blog: Blog) -> Bool in
            return (blog.author?.lowercased().contains(searchText.lowercased()))!
        }))!
        
        table.reloadData()
        
    }   
}
