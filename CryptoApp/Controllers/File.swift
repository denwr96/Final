//
//  File.swift
//  NewsApiOrg
//
//  Created by deniss.lobacs on 21/11/2021.
//

import Foundation

var tweets: [Tweet] = []

func fetchVideoData() {
   guard let url = Bundle.main.url(forResource: "tweets", withExtension: "json") else {
       return
   }

   guard let data = try? Data(contentsOf: url) else {
       return
   }
   let str = String(decoding: data, as: UTF8.self)
   print(str)
   print("Data: \(data)")
   let decoder = JSONDecoder()

   do {
       let tweets = try decoder.decode([Tweet].self, from: data)
       //self.tweets = tweets
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

   print("tweets: \(tweets)")

}
