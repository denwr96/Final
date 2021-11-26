/*
   CryptoViewController.swift
   CryptoApp
 
   Created by Denis Lobach on 24/11/2021.
 
 */

/*
  Cryptocurrency model
 */

import Foundation

struct Currency: Codable {
    var name: String
    var unit: String
    var value: String
    var image: String
}
