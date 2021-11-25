//
//  SearchResponse.swift
//  CryptoApp
//
//  Created by deniss.lobacs on 25/11/2021.
//  Copyright © 2021 bootcamp. All rights reserved.
//

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
