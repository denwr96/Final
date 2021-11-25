//
//  Crypto.swift
//  NewsApiOrg
//
//  Created by deniss.lobacs on 24/11/2021.
//

import Foundation

struct Crypto: Decodable {
    var assets: [CryptoValue]
}

struct CryptoValue: Decodable {
    var asset_id: String?
    var name: String?
    var price: Float
    var volume_24h: Float
    var change_1h: Float
    var change_24h: Float
    var change_7d: Float
}

