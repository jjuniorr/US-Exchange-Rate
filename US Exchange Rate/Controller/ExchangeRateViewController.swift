//
//  ExchangeRateViewController.swift
//  US Exchange Rate
//
//  Created by Junior Etrata on 7/1/19.
//  Copyright © 2019 Junior Etrata. All rights reserved.
//

import UIKit

class ExchangeRateViewController: UIViewController {

   @IBOutlet weak var lastUpdatedLabel: UILabel!
   @IBOutlet weak var sliderDisplayValue: UILabel!
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   
   private lazy var service = ExchangeRateService(url: URL(string: Constants.url)!)
   private var storage = ExchangeRateStorage(persistentContainer: (UIApplication.shared.delegate as! AppDelegate).persistentContainer)
   private var exchangeRateViewModel : ExchangeRateViewModel?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      activityIndicator.startAnimating()
      if Reachability.isConnectedToNetwork(){
         service.downloadExchangeRate { [unowned self] (data) in
            self.storage.processData(data: data, completion: { (exchangeRate) in
               self.setupApplication(exchangeRate: exchangeRate)
            })
         }
      }else{
         storage.fetchData { [unowned self] (exchangeRate) in
            self.setupApplication(exchangeRate: exchangeRate)
         }
      }
   }
   
   func setupApplication(exchangeRate: ExchangeRate){
      self.exchangeRateViewModel = ExchangeRateViewModel(exchangeRate: exchangeRate)
      
      DispatchQueue.main.async { [unowned self] in
         self.activityIndicator.stopAnimating()
         self.lastUpdatedLabel.text = self.exchangeRateViewModel?.lastUpdated
         self.tableView.reloadData()
         self.setupBindings()
      }
   }
   
   func setupBindings(){
      exchangeRateViewModel?.rates.bind({ (_) in
         self.tableView.reloadData()
      })
      exchangeRateViewModel?.slidervalue.bind({ (text) in
         self.sliderDisplayValue.text = text
      })
   }
   
   @IBAction func slider(_ sender: UISlider) {
      let value = Int(sender.value)
      exchangeRateViewModel?.updateRates(withMultiplier: value)
      sender.setValue(Float(value), animated: true)
   }
   
}

extension ExchangeRateViewController : UITableViewDelegate, UITableViewDataSource{
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return exchangeRateViewModel?.exchangeRateCount ?? 0
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let viewModel = exchangeRateViewModel,
            let rates = viewModel.rates.value else { return UITableViewCell() }
      let cell = tableView.dequeueReusableCell(withIdentifier: "Exchange Rate", for: indexPath)
      let (country, rate) = rates[indexPath.row]
      cell.textLabel?.text = country
      cell.detailTextLabel?.text = String(format: "%.2f", rate)
      return cell
   }
   
}
