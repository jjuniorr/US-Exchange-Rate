//
//  ExchangeRateStorage.swift
//  US Exchange Rate
//
//  Created by Junior Etrata on 7/3/19.
//  Copyright © 2019 Junior Etrata. All rights reserved.
//

import Foundation
import CoreData

struct ExchangeRateStorage {
   
   private let persistentContainer : NSPersistentContainer
   
   init(persistentContainer : NSPersistentContainer) {
      self.persistentContainer = persistentContainer
   }
   
}

extension ExchangeRateStorage {
   
   fileprivate func saveContext(){
      if persistentContainer.viewContext.hasChanges{
         do{
            try persistentContainer.viewContext.save()
         }catch {
            print("Error when trying to save \(error)")
         }
      }
   }
   
   fileprivate func deleteStorage(){
      do{
         try persistentContainer.viewContext.execute(NSBatchDeleteRequest(fetchRequest: ExchangeRate.fetchRequest()))
         saveContext()
      } catch {
         print("Not able to delete storage")
      }
   }
   
   func fetchData(completion: @escaping ((ExchangeRate) -> Void)){
      do {
         let dataModel = try persistentContainer.viewContext.fetch(ExchangeRate.fetchRequest())
         if dataModel.isEmpty != true, let exchangeRate = dataModel.first as? ExchangeRate{
            completion(exchangeRate)
         }
      }catch {
         print("Fetch failed")
      }
   }
   
   func processData(data : Data, completion: @escaping ((ExchangeRate) -> Void)){
      do {
         guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
            fatalError("Failed to retrieve context")
         }
         
         deleteStorage()
         
         // Parse JSON data
         let managedObjectContext = persistentContainer.viewContext
         let decoder = JSONDecoder()
         decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
         let exchangeRate = try decoder.decode(ExchangeRate.self, from: data)
         saveContext()
         completion(exchangeRate)
      } catch let error {
         print(error)
      }
   }
}
