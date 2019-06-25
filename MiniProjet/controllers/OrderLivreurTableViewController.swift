//
//  OrderLivreurTableViewController.swift
//  Pi
//
//  Created by wajdii on 18/01/2019.
//  Copyright © 2019 Louay Baccary. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import GoogleMaps
import GooglePlaces

class OrderLivreurTableViewController:  UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var refreshControl = UIRefreshControl()
    var ListOrder:NSArray=[]
    var idProd:String?
    var idOrder:String?
    
    @IBOutlet weak var tableView: UITableView!
    let defaultValues = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Fetchdata()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order")
        let ListOrder = self.ListOrder[indexPath.row] as! Dictionary <String,Any>
        print(ListOrder)
        let reference = ListOrder["reference"] as! String
        let date = ListOrder["date"] as! String
        let state = ListOrder["state"] as! String
        let quantity = String( ListOrder["quantity"] as! Int)
        idProd = String( ListOrder["id_store"] as! Int)
        idOrder = String( ListOrder["id"] as! Int)
        var image:String? = nil
        if(state == "DONE"){
            image = Constant.URL_IMAGE+"v.jpg"
        }
        else if(state == "WAITING"){
            image = Constant.URL_IMAGE+"j.jpg"
        }
        else {
            image = Constant.URL_IMAGE+"r.jpg"
        }
        let contentView = cell?.viewWithTag(0)
        let ref = contentView?.viewWithTag(1) as! UILabel
        let qua = contentView?.viewWithTag(2) as! UILabel
        let dat = contentView?.viewWithTag(3) as! UILabel
        let img = contentView?.viewWithTag(4) as! UIImageView
        
        img.af_setImage(withURL: URL(string: image!)!)
        ref.text = reference
        qua.text = quantity
        dat.text = date
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("clicked")
        performSegue(withIdentifier: "store", sender: indexPath.row)
    }
    
    
    func Fetchdata()
    {
        Alamofire.request(Constant.URL_ORDER_LIV).responseJSON{response in
            print(response.result.value as Any)
            self.ListOrder = response.result.value! as! NSArray
            self.tableView.reloadData()
        }
    }
    //self.defaultValues.set(self.id!, forKey: "id_product")
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "store") {
            self.defaultValues.set(self.idProd!, forKey: "id_storeLiv")
            let destinationViewController =  segue.destination as? MapLivreurViewController
            destinationViewController?.id = self.idOrder!
            
        }
        
    }
    
    @objc func refresh() {
        // Code to refresh table view
        Fetchdata()
        print("reload")
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Fetchdata()
        tableView.reloadData()   // ...and it is also visible here.
    }
}
