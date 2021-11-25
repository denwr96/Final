//
//  TweetsViewController.swift
//  NewsApiOrg
//
//  Created by deniss.lobacs on 21/11/2021.
//

import UIKit

class CurrenciesViewController: UIViewController {
    
    
    var currencies: [Currency] = []
    var values: [Values] = []
    
    var currentTableView = 0
    var a: String!
    
    @IBAction func infoButton(_ sender: Any) {
        basicAlert(title: "Attention", message: "Last Update Date: 2021-11-24 12:35:30")
    }
    @IBOutlet weak var segmendetControl: UISegmentedControl!
    @IBAction func indexChanged(_ sender: Any) {
        switch(segmendetControl.selectedSegmentIndex) {
           case 0:
            fetchVideoData(file: "currencies")
               tableView.reloadData()
               break

           case 1:
            fetchVideoData(file: "values")
               tableView.reloadData()
               break
           default:
               break

        }
    }
    
    func fetchVideoData(file: String) {
       guard let url = Bundle.main.url(forResource: file, withExtension: "json") else {
           return
       }

       guard let data = try? Data(contentsOf: url) else {
           return
       }
       let str = String(decoding: data, as: UTF8.self)
       print(str)
      // print("Data: \(data)")
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

    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        UINavigationBar.appearance().tintColor = .purple
        super.viewDidLoad()
        self.tableView.allowsSelection = false
        fetchVideoData(file: "values")
        fetchVideoData(file: "currencies")
    }
}

extension CurrenciesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CurrencyTableViewCell
        let object = currencies[indexPath.row]
        let object2 = values[indexPath.row]
        
        switch(segmendetControl.selectedSegmentIndex)
        {
        case 0:
            cell.nameLabel.text = object.name
            cell.unitLabel.text = object.unit
            cell.valueLabel.text = object.value
            cell.imageLabel.image = UIImage(named: object.image)
            
        case 1:
            cell.nameLabel.text = object2.name
            cell.unitLabel.text = object2.unit
            cell.valueLabel.text = object2.value
            cell.imageLabel.image = UIImage(named: object.image)
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
