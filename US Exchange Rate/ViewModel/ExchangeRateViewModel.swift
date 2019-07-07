//
//  ExchangeRateViewModel.swift
//  US Exchange Rate
//
//  Created by Junior Etrata on 7/3/19.
//  Copyright © 2019 Junior Etrata. All rights reserved.
//

import Foundation

class ExchangeRateViewModel {
   
   fileprivate var exchangeRate: ExchangeRate!
   fileprivate var originalRates : [(String,Double)]
   var rates : DynamicType<[(String, Double)]> = DynamicType()
   var slidervalue : DynamicType<String> = DynamicType()
   
   init(exchangeRate : ExchangeRate) {
      self.exchangeRate = exchangeRate
      
      let sortArray = exchangeRate.rates.sorted { $0.key < $1.key }
      rates.value = sortArray
      originalRates = sortArray
   }
   
   var exchangeRateCount : Int{
      return exchangeRate.rates.count
   }
   
   var lastUpdated : String {
      let date = Date(timeIntervalSince1970: exchangeRate.timestamp)
      let dateFormatter = DateFormatter()
      dateFormatter.locale = NSLocale.current
      dateFormatter.dateFormat = "MM/dd/yyyy"
      return "Last Updated: " + dateFormatter.string(from: date)
   }
}

extension ExchangeRateViewModel {
   
   func updateRates(withMultiplier multiplier: Int){
      rates.value = originalRates.map { ($0.0, $0.1 * Double(multiplier)) }
      slidervalue.value = "USD: \(multiplier)"
   }
}
