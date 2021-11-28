/*
   CryptoViewController.swift
   CryptoApp
 
   Created by Denis Lobach on 24/11/2021.
 
 */

import UIKit

class CryptoViewController: UIViewController {
    
    var crypto: Crypto? = nil
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var table: UITableView!
    
    /*
      Refreshing view button
     */
    
    @IBAction func refreshButton(_ sender: Any) {
        viewDidLoad()
        table.reloadData()
    }

    /*
     Requesting data from API function
     */
    
    func request(urlString: String, completion: @escaping (Result<Crypto, Error>) -> Void) {
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
                    let values = try JSONDecoder().decode(Crypto.self, from: data)
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
        self.table.allowsSelection = false
        super.viewDidLoad()
        let urlString = "https://cryptingup.com/api/assets?size=10"
        activityIndicator(animated: true)
        request(urlString: urlString) { [weak self] (result) in
            switch result {
            case .success(let crypto):
                self?.crypto = crypto
                self?.table.reloadData()
            case .failure(let error):
                print("Request error: ", error)
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
    
}

extension CryptoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return crypto?.assets.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cryptoCell", for: indexPath) as? CryptoTableViewCell else {return UITableViewCell()}
        
        
        let crypto = crypto?.assets[indexPath.row]
        
        cell.assetIdLabel.text = crypto?.asset_id
        cell.nameLabel.text = crypto?.name
        cell.priceValue.text = "$ " + String(format: "%.16f", crypto!.price)
        cell.volume24hLabel.text = String(format: "%.1f", crypto!.volume_24h)
        
        cell.change1hLabel.text = "$ " + String(format: "%.16f", crypto!.change_1h)
        cell.change1hLabel.textColor = crypto!.change_1h > 0 ? UIColor(red: 0.00, green: 0.55, blue: 0.01, alpha: 1.00) : UIColor.red
        
        cell.change24hLabel.text = "$ " + String(format: "%.16f", crypto!.change_24h)
        cell.change24hLabel.textColor = crypto!.change_24h > 0 ? UIColor(red: 0.00, green: 0.55, blue: 0.01, alpha: 1.00) : UIColor.red
        
        cell.change7dLabel.text = "$ " + String(format: "%.16f", crypto!.change_7d)
        cell.change7dLabel.textColor = crypto!.change_7d > 0 ? UIColor(red: 0.00, green: 0.55, blue: 0.01, alpha: 1.00) : UIColor.red
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
