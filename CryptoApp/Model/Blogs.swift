//
//  SearchResponse.swift
//  NewsApiOrg
//
//  Created by deniss.lobacs on 23/11/2021.
//

import Foundation

struct Blogs: Decodable {
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

