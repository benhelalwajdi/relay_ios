//
//  CheckoutController.swift
//  MiniProjet
//
//  Created by Ahlem on 10/12/2018.
//  Copyright © 2018 Ahlem. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class CheckoutController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var products: Array<ProductModel> = []
    let managedContext = DBHelper.persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePriceLabel()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingBagProduct", for: indexPath)
        
        let contentview = cell.viewWithTag(0)
        let img = contentview?.viewWithTag(1) as! UIImageView
        let name = contentview?.viewWithTag(2) as! UILabel
        let quantity = contentview?.viewWithTag(3) as! UILabel
        let price = contentview?.viewWithTag(4) as! UILabel
        
        img.image = UIImage(named: products[indexPath.row].image)
        name.text = products[indexPath.row].name
        quantity.text = "QTY: \(products[indexPath.row].quantity)"
        price.text = "\(products[indexPath.row].price * (Float(products[indexPath.row].quantity)!) ) TND"
        
        return cell
    }
    
    @IBAction func submitOrder(_ sender: Any) {
        let URL = "http://"+Constant.IP_ADDRESS+":11809/orders/add_new_order/"
        for p in products {
            let parameters:  [String: Any] = [
                "idProduct": p.id,
                "idStore": p.idStore,
                "idClient": 57,
                "quantity": p.quantity
            ]
            print(p.idStore)
            print(p.id)
            addOrder(url: URL, parameters: parameters)
        }
    }
    
    func addOrder(url: String, parameters:  [String: Any])  {
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseString
            { response in
                print(response)
                self.clearShoppingBag()
        }
    }
    
    func clearShoppingBag(){
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
             try managedContext.execute(request)
        } catch let error as NSError {
            print(error)
        }
    }
    
    
    func updatePriceLabel(){
        var totalPrice : Float! = 0
        if (products.count != 0){
            for p in products {
                print(p.price)
                totalPrice += p.price * Float(p.quantity)!
            }
        }
        
        totalPriceLabel.text = String(describing: totalPrice!) + " TND"
    }
    
}
