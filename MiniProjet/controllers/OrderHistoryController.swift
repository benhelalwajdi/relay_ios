//
//  OrderHistoryController.swift
//  MiniProjet
//
//  Created by Ahlem on 10/12/2018.
//  Copyright © 2018 Ahlem. All rights reserved.
//

import UIKit
import Alamofire
import Cosmos

class OrderHistoryController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataResponse:NSArray = []
    let URL = "http://"+Constant.IP_ADDRESS+":11809/orders/client/57"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchOrders()
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataResponse.count    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "order", for: indexPath)
        
        let contentview = cell.viewWithTag(0)
        let orderStatusImage = contentview?.viewWithTag(1) as! UIImageView
        let orderReference = contentview?.viewWithTag(2) as! UILabel
        
        
        let orders = dataResponse[indexPath.item] as! Dictionary<String , Any>
        orderReference.text = orders["reference"] as? String
        if (orders["state"] as? String == "WAITING"){
            orderStatusImage.image = UIImage(named: "dark_circle_small")
        }else if (orders["state"] as? String == "IN PROGRESS"){
            orderStatusImage.image = UIImage(named: "orange_circle_small")
        }else {
            orderStatusImage.image = UIImage(named: "green_circle_small")
        }
        
        return cell
    }
    
    func fetchOrders (){
        Alamofire.request(URL)
            .responseJSON{response in
                self.dataResponse = response.result.value! as! NSArray
                self.tableView.reloadData()
        }
    }
    
    
}
