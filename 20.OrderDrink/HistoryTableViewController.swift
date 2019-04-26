//
//  HistoryTableViewController.swift
//  20.OrderDrink
//
//  Created by 張睿哲 on 2019/4/25.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    var historyOrder = [GetHistoryOrder]()
    let refreshView = UIActivityIndicatorView.init(style: .whiteLarge)
    
    func getOrder(completion: @escaping ([GetHistoryOrder]?) -> Void){
        refreshView.color = UIColor.gray
        tableView.backgroundView = refreshView
        refreshView.startAnimating()
        var getOrderDrinks = [GetHistoryOrder]()
        
        if let urlStr = "https://sheetdb.io/api/v1/i3jrq2akol5d8".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlStr) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let results = try JSONDecoder().decode([GetHistoryOrder].self, from: data)
                        for i in results{
                            let drinkName = i.drinkName
                            let orderName = i.orderName
                            let price = i.price
                            let suger = i.suger
                            let ice = i.ice
                            let time = i.time
                            let aOrderDrink = GetHistoryOrder(drinkName: drinkName, orderName: orderName, price: price, suger: suger, ice: ice, time: time)
                            getOrderDrinks.append(aOrderDrink)
                        }
                        if getOrderDrinks.count != 0{
                            completion(getOrderDrinks)
                            DispatchQueue.main.async {
                                self.refreshView.stopAnimating()
                            }
                        }else{
                            completion(nil)
                            DispatchQueue.main.async {
                                self.refreshView.stopAnimating()
                            }
                        }
                    }catch{
                        print(error)
                    }
                }
            }
            task.resume()
        } else {
            completion(nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return historyOrder.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getOrder { (getOrderDrinks) in
            if let getOrderDrinks = getOrderDrinks {
                DispatchQueue.main.async {
                    self.historyOrder = getOrderDrinks
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        cell.textLabel?.text = historyOrder[indexPath.row].drinkName
        cell.detailTextLabel?.text = historyOrder[indexPath.row].time
        
        // Configure the cell...
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
