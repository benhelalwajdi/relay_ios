//
//  ShoppingBagController.swift
//  MiniProjet
//
//  Created by Ahlem on 03/12/2018.
//  Copyright © 2018 Ahlem. All rights reserved.
//

import UIKit
import CoreData

class ShoppingBagController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var products: Array<ProductModel> = []
    var array:[NSManagedObject] = []
    let managedContext = DBHelper.persistentContainer.viewContext
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalItems: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        updateTotalLabels()
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
        quantity.text = "\(products[indexPath.row].quantity) item(s)"
        price.text = "\(products[indexPath.row].price * (Float(products[indexPath.row].quantity)!) ) TND"
        
        return cell
    }
    
    
    @objc func fetchData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        request.returnsObjectsAsFaults = false
        do {
            let result = try managedContext.fetch(request)
            array = result as! [NSManagedObject]
            for data in array  {
                let  product =  ProductModel(id: data.value(forKey: "id") as! String,
                                             name: data.value(forKey: "name") as! String,
                                             price: data.value(forKey: "price") as! Float,
                                             description : data.value(forKey: "descriptions") as! String,
                                             quantity : data.value(forKey: "quantity") as! String,
                                             idStore: data.value(forKey: "storeId") as! String,
                                             image: data.value(forKey: "image") as! String)
                products.append(product)
            }
            self.tableView.reloadData()
            print(array)
        } catch {
            print("Failed")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
            request.predicate = NSPredicate(format: "name == %@", products[indexPath.row].name)
            request.returnsObjectsAsFaults = false
            
            if let result = try? managedContext.fetch(request) {
                for object in result {
                    managedContext.delete(object as! NSManagedObject)
                    self.products.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
        
        do {
            try  managedContext.save()
            updateTotalLabels()
        } catch  {}
    }
    
   
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "updateQuantitySegue", sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "updateQuantitySegue"){
            let indexPath = sender as! IndexPath
            let destinationViewController = segue.destination as? ShoppingBagPopupController
            destinationViewController?.productId = products[indexPath.row].id
            destinationViewController?.productName = products[indexPath.row].name
            destinationViewController?.actualQuantity = Int(products[indexPath.row].quantity)
        }else if (segue.identifier == "proceedToCheckoutSegue"){
            let destinationViewController = segue.destination as? CheckoutController
            destinationViewController?.products = products
        }
    }
 
    func updateTotalLabels(){
        var totalPrice : Float! = 0
        var items = 0
        if (products.count != 0){
            for p in products {
                print(p.price)
            //    i = Float(totalPrice) + Float(p.price)!
                items += Int(p.quantity)!
                totalPrice += p.price * Float(p.quantity)!
    
               // totalPrice = Float (p.price)!
            }
        }
     
        totalLabel.text = String(describing: totalPrice!) + " TND"
        totalItems.text = "(" + String(describing: items) + " Items)"
    }
  
 
    /*
     override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
     NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name(rawValue: "load"), object: nil)
     }
     
     override func viewDidDisappear(_ animated: Bool) {
     super.viewDidDisappear(animated)
     NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "load"), object: nil)
     }
     */
    @IBAction func proceedToCheckout(_ sender: Any) {
        if (products.count > 0) {
            performSegue(withIdentifier: "proceedToCheckoutSegue", sender: self)

        }
    }
}
