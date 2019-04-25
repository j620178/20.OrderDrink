//
//  CarTableViewController.swift
//  20.OrderDrink
//
//  Created by 張睿哲 on 2019/4/18.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import Foundation

class CarTableViewController: UITableViewController {
    var orderDrinks = [OrderDrink]()
    let refreshView = UIActivityIndicatorView.init(style: .whiteLarge)
    let suger = ["正常糖","半糖","微糖","無糖"]
    let ice = ["正常冰","少冰","去冰","熱"]

    func postOrder(orderDrinks:[OrderDrink], completionHandler: @escaping (String) ->Void){
        let url = URL(string: "https://sheetdb.io/api/v1/i3jrq2akol5d8")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let uploadData = UploadData(data: orderDrinks)
//        let uploadData = UploadData(data: orderDrinks.filter({ (a:OrderDrink) -> Bool in
//            a.isUpload == false
//        }))
        
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(uploadData) {
            let task = URLSession.shared.uploadTask(with: urlRequest, from: data, completionHandler: { (retData, res, err) in
                let decoder = JSONDecoder()
                if let retData = retData, let dic = try? decoder.decode([String: Int].self, from: retData), let number = dic["created"], number == orderDrinks.count {
                    completionHandler("OK")
                } else {
                    completionHandler("error")
                }
            })
            task.resume()
        }
    }
    
    func updateBadge(number:Int) {
        if let tabItems = tabBarController?.tabBar.items {
            let tabItem = tabItems[1]
            tabItem.badgeValue = String(number)
        }
    }
    
    @IBAction func orderButton(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            self.refreshView.color = UIColor.gray
            self.tableView.backgroundView = self.refreshView
            self.refreshView.startAnimating()
        }
        postOrder(orderDrinks: orderDrinks) { (uploadStatus) in
            if uploadStatus == "OK" {
                let alertController = UIAlertController(title: "訂購成功", message: "已完成訂購", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                //上傳完成清空orderDrinks,更新Badge
                DispatchQueue.main.async {
                    self.orderDrinks = [OrderDrink]()
                    OrderDrink.saveToFile(orderDrinks: self.orderDrinks)
                    self.updateBadge(number: self.orderDrinks.count)
                    self.tableView.reloadData()
                    self.refreshView.stopAnimating()
                }
            }else {
                let alertController = UIAlertController(title: "訂購失敗", message: "請確認購物車是否加入飲品", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                self.tableView.reloadData()
                self.refreshView.stopAnimating()
            }
        }
//        getOrder { (getOrderDrinks) in
//            if let getOrderDrinks = getOrderDrinks {
//                DispatchQueue.main.async {
//                    self.orderDrinks = getOrderDrinks
//                    self.tableView.reloadData()
//                }
//            }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let orderDrinks = OrderDrink.readOrderDrinkFile() {
            self.orderDrinks = orderDrinks
        }
        tableView.reloadData()
        updateBadge(number: orderDrinks.count)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderDrinks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "carCell", for: indexPath) as! OrderDrinkUITableViewCell
        cell.drinkName.text = orderDrinks[indexPath.row].drinkName
        let detail = "\(ice[orderDrinks[indexPath.row].ice])，\(suger[orderDrinks[indexPath.row].suger])"
        cell.drinkDetail.text = detail
        cell.drinkPrice.text = String(orderDrinks[indexPath.row].price)

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

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        orderDrinks.remove(at: indexPath.row)
        OrderDrink.saveToFile(orderDrinks: orderDrinks)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        if let tabItems = tabBarController?.tabBar.items {
            let tabItem = tabItems[1]
            tabItem.badgeValue = String(orderDrinks.count)
        }
    }


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
