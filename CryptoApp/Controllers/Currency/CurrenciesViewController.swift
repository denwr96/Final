/*
 CryptoViewController.swift
 CryptoApp
 
 Created by Denis Lobach on 24/11/2021.
 
 */

import UIKit

class CurrenciesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmendetControl: UISegmentedControl!
    
    @IBAction func infoButton(_ sender: Any) {
        basicAlert(title: "Attention!", message: "Last Update Date: 2021-11-24 12:35:30")
    }
   
    @IBAction func indexChanged(_ sender: Any) {
        switch(segmendetControl.selectedSegmentIndex) {
        case 0:
            fetchData(file: "currencies")
            tableView.reloadData()
            break
            
        case 1:
            fetchData(file: "values")
            tableView.reloadData()
            break
        default:
            break
            
        }
    }
    
    var currencies: [Currency] = []
    var values: [Values] = []
    var currentTableView = 0
    
    
    override func viewDidLoad() {
        UINavigationBar.appearance().tintColor = .purple
        super.viewDidLoad()
        self.tableView.allowsSelection = false
        fetchData(file: "values")
        fetchData(file: "currencies")
    }

    
    func fetchData(file: String) {
        guard let url = Bundle.main.url(forResource: file, withExtension: "json") else {
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return
        }

        let decoder = JSONDecoder()
        
        do {
            let currencies = try decoder.decode([Currency].self, from: data)
            let values = try decoder.decode([Values].self, from: data)
            self.currencies = currencies
            self.values = values
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
        
    }
}

extension CurrenciesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CurrencyTableViewCell
        let currencie = currencies[indexPath.row]
        let value = values[indexPath.row]
        
        switch(segmendetControl.selectedSegmentIndex) {
        case 0:
            cell.nameLabel.text = currencie.name
            cell.unitLabel.text = currencie.unit
            cell.valueLabel.text = currencie.value
            cell.imageLabel.image = UIImage(named: currencie.image)
            
        case 1:
            cell.nameLabel.text = value.name
            cell.unitLabel.text = value.unit
            cell.valueLabel.text = value.value
            cell.imageLabel.image = UIImage(named: currencie.image)
            break
            
        default:
            break
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
