//
//  ExchangeRate+CoreDataProperties.swift
//  US Exchange Rate
//
//  Created by Junior Etrata on 7/2/19.
//  Copyright © 2019 Junior Etrata. All rights reserved.
//
//

import Foundation
import CoreData


extension ExchangeRate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExchangeRate> {
        return NSFetchRequest<ExchangeRate>(entityName: "ExchangeRate")
    }

    @NSManaged public var timestamp: Double

}
