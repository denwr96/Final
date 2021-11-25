//
//  CryptoViewController.swift
//  NewsApiOrg
//
//  Created by deniss.lobacs on 21/11/2021.
//

import UIKit

class CryptoViewController: UIViewController {

    @IBOutlet weak var btcPrice: UILabel!
    @IBOutlet weak var ethPrice: UILabel!
    @IBOutlet weak var usdPrice: UILabel!
    @IBOutlet weak var audPrice: UILabel!
    @IBOutlet weak var ltcPrice: UILabel!
    @IBOutlet weak var lastUpdatedPrice: UILabel!
    
    let urlString = "https://api.coingecko.com/api/v3/exchange_rates"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func refreshBtn(_ sender: Any) {
        self.viewDidLoad()
    }
    func fetchData() {
         let url = URL(string: urlString)
         let defaultSession = URLSession(configuration: .default)
         let dataTask = defaultSession.dataTask(with: url!) { (data: Data?,response: URLResponse?, error: Error?) in
       
            if error != nil {
                print(error!)
                return
            }
            
            do {
                let json = try JSONDecoder().decode(Rates.self, from: data!)
                self.setPrices(currency: json.rates)
            } catch {
                print(error)
                return
            }
            
        }
        dataTask.resume()
    }
    
    func setPrices(currency: Currency) {
        
        DispatchQueue.main.sync {
        self.btcPrice.text = self.formatPrice(currency.btc)
        self.ethPrice.text = self.formatPrice(currency.eth)
        self.usdPrice.text = self.formatPrice(currency.usd)
        self.audPrice.text = self.formatPrice(currency.aud)
        self.ltcPrice.text = self.formatPrice(currency.ltc)
        self.lastUpdatedPrice.text = self.formatDate(date: Date())
        }
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM y HH:mm:ss"
        return formatter.string(from: date)
    }
    
    func formatPrice(_ price: Price) -> String {
        return String(format: "%@ %.4f", price.unit,price.value)
    }
    
    struct Rates: Codable {
        let rates: Currency
    }
    
    struct Currency: Codable {
        let btc: Price
        let eth: Price
        let usd: Price
        let aud: Price
        let ltc: Price
    }
    
    struct Price: Codable {
        let name: String
        let unit: String
        let value: Float
        let type: String
    }

}
