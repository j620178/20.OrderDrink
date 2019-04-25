//
//  DataType.swift
//  20.OrderDrink
//
//  Created by 張睿哲 on 2019/4/18.
//  Copyright © 2019 littema. All rights reserved.
//
import UIKit
import Foundation

struct Drink {
    var name: String
    var price: Int
}

struct Order: Codable {
    var drinkName: String
    var orderName: String
    var price: Int
    var suger: Int
    var ice: Int
}

struct UploadData: Codable {
    var data: [OrderDrink]
}

struct GetHistoryOrder: Codable {
    var drinkName: String
    var orderName: String
    var price: String
    var suger: String
    var ice: String
    var time: String
}

struct OrderDrink: Codable {
    var drinkName: String
    var orderName: String
    var price: Int
    var suger: Int
    var ice: Int
    var time: String
    
    static func saveToFile(orderDrinks: [OrderDrink]) {
        let propertyEncoder = PropertyListEncoder()
        if let data = try? propertyEncoder.encode(orderDrinks) {
            let userDefault = UserDefaults.standard
            userDefault.set(data, forKey: "orderDrinks")
        }
    }
    
    static func readOrderDrinkFile() -> [OrderDrink]? {
        let userDefaults = UserDefaults.standard
        let propertyDecoder = PropertyListDecoder()
        if let data = userDefaults.data(forKey: "orderDrinks"), let orderDrinks = try? propertyDecoder.decode([OrderDrink].self, from: data) {
            return orderDrinks
        } else {
            return nil
        }
    }
}
