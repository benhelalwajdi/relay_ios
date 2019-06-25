//
//  ViewController.swift
//  MiniProjet
//
//  Created by Ahlem on 05/11/2018.
//  Copyright © 2018 Ahlem. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    
    @IBOutlet weak var tableView: UITableView!
    var dataResponse:NSArray = []
    let jsonUrl = "http://"+Constant.IP_ADDRESS+":11809/stores";
    
    let images = ["1", "2", "3", "4"]
    var storeId : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      /*
        let attrs = [
            NSAttributedString.Key.font: UIFont(name: "Bodoni 72", size: 24)!
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attrs
*/
        fetchStores()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataResponse.count    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "store", for: indexPath)
        
        let contentview = cell.viewWithTag(0)
        let storeName = contentview?.viewWithTag(1) as! UILabel
        let storeImage = contentview?.viewWithTag(2) as! UIImageView
        
        let stores = dataResponse[indexPath.item] as! Dictionary<String , Any>
        storeName.text = stores["store_name"] as? String
        storeImage.image = UIImage(named: images.randomElement()!)
        
        storeImage.layer.cornerRadius = storeImage.frame.size.width/2
        storeImage.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "listProducts", sender: indexPath)
    }
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "listProducts"){
            let indexPath = sender as! IndexPath
            let stores = dataResponse[indexPath.item] as! Dictionary<String , Any>
        
            let destinationViewController = segue.destination as? ListProductsController
            destinationViewController?.storeId = String(describing: stores["id"] as! Int)
            
        }
    }

    func fetchStores (){
        Alamofire.request(jsonUrl)
            .responseJSON{response in
                self.dataResponse = response.result.value! as! NSArray
                self.tableView.reloadData()
                
                print(self.dataResponse)
 
        }
    }
    

}

