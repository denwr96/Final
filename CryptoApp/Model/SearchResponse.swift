/*
   CryptoViewController.swift
   CryptoApp
 
   Created by Denis Lobach on 24/11/2021.
 
 */

/*
  Blog model
 */

import Foundation

struct SearchResponse: Decodable {
    var category: String
    var data: [Blog]
}

struct Blog: Decodable {
    var author: String?
    var content: String?
    var date: String?
    var title: String?
    var time: String?
    var imageUrl: String?
    var readMoreUrl: String 
    var url: String
}
