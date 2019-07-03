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
   typealias RequestHandler = ((Request<Data>) -> Void)
   
   fileprivate let endpoint: URL!
   fileprivate let persistentContainer: NSPersistentContainer
   
   init(url : URL, persistentContainer: NSPersistentContainer) {
      self.endpoint = url
      self.persistentContainer = persistentContainer
   }
}

extension ExchangeRateService{
   
   fileprivate func downloadTask(completion: @escaping RequestHandler){
      
      URLSession.shared.dataTask(with: self.endpoint) { [unowned self] (data, response, error) in
         if error == nil{
            guard let res = response as? HTTPURLResponse, res.statusCode == 200 else {
               fatalError()
            }
            
            guard let jsonData = data else { fatalError() }
            
            do{
               guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
                  fatalError("Failed to retrieve managed object context")
               }
               // Parse JSON data
               let managedObjectContext = self.persistentContainer.viewContext
               let decoder = JSONDecoder()
               decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
               let s = try decoder.decode(ExchangeRate.self, from: jsonData)
               print(s)
               //try managedObjectContext.save()
            }catch {
               print("Error when saving: \(error)")
            }
         }else {
            print(error!.localizedDescription)
            completion(.failure(error))
         }
      }.resume()
      
   }
   
   func downloadExchangeRate(completion: @escaping ResponseHandler){

      downloadTask { (request) in
         switch request {
         case .success(let data):
            break
         case .failure(let error):
            break
         }
      }
   }
   
}
