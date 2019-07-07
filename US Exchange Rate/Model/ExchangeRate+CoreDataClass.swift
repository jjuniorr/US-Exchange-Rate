//
//  ExchangeRate+CoreDataClass.swift
//  US Exchange Rate
//
//  Created by Junior Etrata on 7/3/19.
//  Copyright © 2019 Junior Etrata. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ExchangeRate)
public class ExchangeRate: NSManagedObject, Codable {

   enum CodingKeys: String, CodingKey {
      case timestamp = "time_last_updated"
      case rates
   }
   
   public required convenience init(from decoder: Decoder) throws {
      guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
         let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
         let entity = NSEntityDescription.entity(forEntityName: "ExchangeRate", in: managedObjectContext) else {
            fatalError("Failed to decode ExchangeRate")
      }
      
      self.init(entity: entity, insertInto: managedObjectContext)
      
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.timestamp = try container.decodeIfPresent(Double.self, forKey: .timestamp) ?? 0
      self.rates = try container.decodeIfPresent([String:Double].self, forKey: .rates) ?? [:]

   }
   
   public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(timestamp, forKey: .timestamp)
      try container.encode(rates, forKey: .rates)
   }
   
}

public extension CodingUserInfoKey {
   static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
