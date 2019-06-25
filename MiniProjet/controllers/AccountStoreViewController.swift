//
//  AccountStoreViewController.swift
//  Pi
//
//  Created by Mac Os on 11/29/18.
//  Copyright © 2018 Louay Baccary. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
class AccountStoreViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    var refreshControl = UIRefreshControl()
    var ListProduct:NSArray=[]
    var movieID:Int?
    let defaultValues = UserDefaults.standard
    // self.defaultValues.set(list["id"]!, forKey: "id_product")
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        let cell = tableView.dequeueReusableCell(withIdentifier: "productcell")
        let ListProduct = self.ListProduct[indexPath.row] as! Dictionary <String,Any>
        print(ListProduct)
        let ProductName = ListProduct["name"] as! String
        let imgname = ListProduct["image"] as! String
        let dateAdd = ListProduct["date"] as! String
        print("image url "+Constant.URL_IMAGE+""+imgname)
        let contentView = cell?.viewWithTag(0)
        let ProdImg = contentView?.viewWithTag(1) as! UIImageView
        let Product_Name = contentView?.viewWithTag(2) as! UILabel
        let date = contentView?.viewWithTag(3) as! UILabel
        ProdImg.af_setImage(withURL: URL(string: Constant.URL_IMAGE+""+imgname)!)
        Product_Name.text = ProductName
        date.text = dateAdd
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("clicked")
        performSegue(withIdentifier: "DetailProduct", sender: indexPath.row)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "DetailProduct") {
            let index = sender as! Int
            print(ListProduct[index])
            let list = ListProduct[index] as! Dictionary <String, Any>
            print( list["description"]! )
            print(list["name"]!)
            print(list["price"]! )
            print(list["quantity"]!)
            print(list["size"]!)
            print(list["id"]!)
            print(list["date"]!)
            print(list["image"]!)
            
            let destinationViewController =  segue.destination as? DetailProductViewController
            destinationViewController?.discription = (list["description"] as! String)
            destinationViewController?.nameProd = (list["name"] as! String)
            destinationViewController?.price = (list["price"] as! String)
            destinationViewController?.quantity = (list["quantity"] as! String)
            destinationViewController?.sizetxt = (list["size"] as! String)
            destinationViewController?.id = String((list["id"] as! Int))
            destinationViewController?.image = (list["image"] as! String)
            destinationViewController?.date = (list["date"] as! String)
            self.defaultValues.set(list["id"]!, forKey: "id_product")
            
        }else{
            
        }
        
    }
    
    @objc func refresh() {
        // Code to refresh table view
        Fetchdata()
        print("reload")
        refreshControl.endRefreshing()
    }
    
    func Fetchdata()
    {
        let defaultValues = UserDefaults.standard
        let idp = defaultValues.string(forKey: "user_id")
        
        Alamofire.request(Constant.URL_GET_PRODUCTS+"/"+idp!).responseJSON{response in
            print(response.result.value as Any)
            self.ListProduct = response.result.value! as! NSArray
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Fetchdata()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Fetchdata()
        tableView.reloadData()   // ...and it is also visible here.
    }
    
}






