//
//  MainTableViewController.swift
//  20.OrderDrink
//
//  Created by 張睿哲 on 2019/4/17.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, DetailTableViewControllerDelegate{
    var drinks = [Drink]()
    var orderDrinks = [OrderDrink]()
    
    func readDrinkFile(fileName:String) -> [Drink]? {
        if let asset = NSDataAsset(name: fileName), let content = String(data: asset.data, encoding: .utf8) {
            let array = content.components(separatedBy: "\n")
            var i = 0
            for _ in 0..<array.count/2 {
                let name = array[i]
                if let price = Int(array[i + 1]) {
                    drinks.append(Drink(name: name, price: price))
                }
                i = i + 2
            }
            return drinks
        }
        return nil
    }
    
    func orderDrinkUpdate(orderDrink: OrderDrink) {
        if let tempOrderDrinks = OrderDrink.readOrderDrinkFile() {
            orderDrinks = tempOrderDrinks
            orderDrinks.append(orderDrink)
            updateBadge(number: orderDrinks.count)
            OrderDrink.saveToFile(orderDrinks: orderDrinks)
        }
    }
    
    func updateBadge(number:Int) {
        if let tabItems = tabBarController?.tabBar.items {
            let tabItem = tabItems[1]
            tabItem.badgeValue = String(number)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let readDrinks = readDrinkFile(fileName: "迷克夏") {
            drinks = readDrinks
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let orderDrinks = OrderDrink.readOrderDrinkFile(){
            self.orderDrinks = orderDrinks
            updateBadge(number: orderDrinks.count)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return drinks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drinkCell", for: indexPath) as! DrinkTableViewCell
        cell.drinkName.text = drinks[indexPath.row].name
        cell.drinkPrice.text = String(drinks[indexPath.row].price)
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? DetailTableViewController, let row = tableView.indexPathForSelectedRow?.row {
            controller.drink = drinks[row]
            controller.delegate = self
        }
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
