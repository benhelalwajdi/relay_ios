//
//  ShoppingBagPopupController.swift
//  MiniProjet
//
//  Created by Ahlem on 09/12/2018.
//  Copyright © 2018 Ahlem. All rights reserved.
//

import UIKit
import CoreData

class ShoppingBagPopupController: UIViewController {
    
    var productId: String?
    var productName: String?
    var actualQuantity: Int?
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    let managedContext = DBHelper.persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quantityLabel.text = String(describing: actualQuantity!)
        productNameLabel.text = productName!
        
    }
    
    @IBAction func decreaseQuantity(_ sender: Any) {
        var qte = Int(quantityLabel.text!)
        if (qte! > 1) {
            qte = qte! - 1
            quantityLabel.text = String(describing: qte!)
        }
    }
    @IBAction func increaseQuantity(_ sender: Any) {
        var qte = Int(quantityLabel.text!)
        qte = qte! + 1
        quantityLabel.text = String(describing: qte!)
        
        
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateQuantity(_ sender: Any) {
        print(productId!)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        
          request.predicate = NSPredicate(format: "id = \(productId!)")
      //  request.predicate = NSPredicate(format: "id==%i", productId!)
        
        
        do {
            let list = try managedContext.fetch(request) as? [NSManagedObject]
            print("LIST COUNT = ")
            print(list!.count)
            if list!.count != 0 {
                list?[0].setValue(quantityLabel.text, forKey: "quantity")
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        do {
            try managedContext.save()
            dismiss(animated: true, completion: nil)
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        }
        catch {
            print("Saving Core Data Failed: \(error)")
        }
    }
    
}
