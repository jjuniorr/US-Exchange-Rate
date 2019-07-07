//
//  ExchangeRateService.swift
//  US Exchange Rate
//
//  Created by Junior Etrata on 7/1/19.
//  Copyright © 2019 Junior Etrata. All rights reserved.
//

import Foundation
import CoreData

enum Request<T> {
   case success(T)
   case failure(Error?)
}

class ExchangeRateService {
   
   typealias ResponseHandler = ((Data) -> Void)
   
   fileprivate let endpoint: URL!
   
   init(url : URL) {
      self.endpoint = url
   }
}

extension ExchangeRateService{
   
   func downloadExchangeRate(completion: @escaping ResponseHandler){
      
      URLSession.shared.dataTask(with: self.endpoint) { (data, response, error) in
         if error == nil{
            guard let res = response as? HTTPURLResponse, res.statusCode == 200 else {
               fatalError()
            }
            guard let returnedData = data else { fatalError() }
            
            completion(returnedData)
         }else {
            print(error?.localizedDescription ?? "")
         }
      }.resume()
      
   }
}
