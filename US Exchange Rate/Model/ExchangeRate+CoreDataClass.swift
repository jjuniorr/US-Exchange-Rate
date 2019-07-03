//
//  ExchangeRate+CoreDataClass.swift
//  US Exchange Rate
//
//  Created by Junior Etrata on 7/2/19.
//  Copyright © 2019 Junior Etrata. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ExchangeRate)
public class ExchangeRate: NSManagedObject, Codable {
   
   enum CodingKeys: String, CodingKey{
      case timestamp = "time_last_updated"
   }

   public required init(from decoder: Decoder) throws {
      guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
         let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
         let entity = NSEntityDescription.entity(forEntityName: "ExchangeRate", in: managedObjectContext) else {
            fatalError("Failed to decode User")
      }
      
      super.init(entity: entity, insertInto: managedObjectContext)
      
      let container = try decoder.container(keyedBy: CodingKeys.self)
      do{
         self.timestamp = try container.decode(Double.self, forKey: .timestamp)
      }catch{
         print("Error: \(error)")
      }
   }
   
   public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(timestamp, forKey: .timestamp)
   }
   
}

public extension CodingUserInfoKey{
   static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
