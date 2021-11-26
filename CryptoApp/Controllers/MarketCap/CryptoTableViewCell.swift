/*
   CryptoViewController.swift
   CryptoApp
 
   Created by Denis Lobach on 24/11/2021.
 
 */

import UIKit

class CryptoTableViewCell: UITableViewCell {

    @IBOutlet weak var assetIdLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceValue: UILabel!
    @IBOutlet weak var volume24hLabel: UILabel!
    @IBOutlet weak var change1hLabel: UILabel!
    @IBOutlet weak var change24hLabel: UILabel!
    @IBOutlet weak var change7dLabel: UILabel!
}
