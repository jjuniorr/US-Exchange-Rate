//
//  ExchangeRateViewController.swift
//  US Exchange Rate
//
//  Created by Junior Etrata on 7/1/19.
//  Copyright © 2019 Junior Etrata. All rights reserved.
//

import UIKit
import CoreData

class ExchangeRateViewController: UIViewController {

   @IBOutlet weak var lastUpdatedLabel: UILabel!
   @IBOutlet weak var sliderDisplayValue: UILabel!
   @IBOutlet weak var tableView: UITableView!
   private var persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
   
   private lazy var exchangeRateService = ExchangeRateService(url: URL(string: Constants.url)!, persistentContainer: persistentContainer)
   
   override func viewDidLoad() {
      super.viewDidLoad()
      exchangeRateService.downloadExchangeRate { (data) in
      }
   }
}

extension ExchangeRateViewController : UITableViewDelegate, UITableViewDataSource{
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 0
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      return UITableViewCell()
   }
   
}
