//
//  DetailTableViewController.swift
//  20.OrderDrink
//
//  Created by 張睿哲 on 2019/4/18.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol DetailTableViewControllerDelegate {
    func orderDrinkUpdate(orderDrink: OrderDrink)
}

class DetailTableViewController: UITableViewController {
    var drink:Drink?
    var delegate:DetailTableViewControllerDelegate?

    @IBOutlet weak var drinkName: UINavigationItem!
    @IBOutlet weak var inputName: UITextField!
    @IBOutlet weak var inputSuger: UISegmentedControl!
    @IBOutlet weak var inputIce: UISegmentedControl!
    
    @IBAction func addDrink(_ sender: Any) {
        if inputName.text?.isEmpty == false, drinkName.title?.isEmpty == false {
            let suger = inputSuger.selectedSegmentIndex
            let ice = inputSuger.selectedSegmentIndex
            let todaysDate:NSDate = NSDate()
            let dateFormatter:DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyy-MM-dd HH:mm"
            let time:String = dateFormatter.string(from: todaysDate as Date)
            
            let orderDrink = OrderDrink(drinkName: drink!.name, orderName: inputName.text!, price: drink!.price, suger: suger, ice: ice,time: time)
            delegate?.orderDrinkUpdate(orderDrink: orderDrink)
            //清空textfield
            inputName.text = ""
            //顯示成功提示
            let alertToast = UIAlertController(title: "完成", message: "已成功加入購物車", preferredStyle: .alert)
            present(alertToast, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                alertToast.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let drink = drink{
            drinkName.title = drink.name
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
