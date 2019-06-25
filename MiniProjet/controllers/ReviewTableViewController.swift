//
//  ReviewTableViewController.swift
//  Pi
//
//  Created by wajdii on 17/01/2019.
//  Copyright © 2019 Louay Baccary. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Cosmos

class ReviewTableViewController: UITableViewController{
    
    var id : String = ""
    var ListReview:NSArray=[]
    var Allresult:Dictionary <String,Any> = [:]
    var rating : String = ""
    var comment : String = ""
    var imageUser : String = ""
    var nameUser : String = ""
    //@IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Fetchdata()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListReview.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        let cell = tableView.dequeueReusableCell(withIdentifier: "review")
        let ListReview = self.ListReview[indexPath.row] as! Dictionary <String,Any>
        print(ListReview)
        self.rating = String(ListReview["rating"] as! Int)
        self.comment = ListReview["comment"] as! String
        let contentView = cell?.viewWithTag(0)
        let rating = contentView?.viewWithTag(1) as! CosmosView
        let comment = contentView?.viewWithTag(2) as! UITextView
        // let nameUser = contentView?.viewWithTag(4) as! UILabel
        comment.text = self.comment
        rating.rating = Double (self.rating)!
        return cell!
    }
    
    func userData (id : String , i: Int)-> String{
        Alamofire.request(Constant.URL_GET_CLIENT+id).responseJSON{response in
            print(response.result.value as Any)
            self.Allresult = self.ListReview[i] as! Dictionary <String,Any>
            print(self.Allresult)
        }
        return self.Allresult["last_name"] as! String
    }
    
    func Fetchdata()
    {
        Alamofire.request(Constant.URL_GET_PRODUCT_REVIEWS+self.id).responseJSON{response in
            print(response.result.value as Any)
            self.ListReview = response.result.value! as! NSArray
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Fetchdata()
        tableView.reloadData()
    }
}
