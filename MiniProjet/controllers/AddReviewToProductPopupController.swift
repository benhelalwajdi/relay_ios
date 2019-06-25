//
//  AddReviewToProductPopupController.swift
//  MiniProjet
//
//  Created by Ahlem on 10/12/2018.
//  Copyright © 2018 Ahlem. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire

class AddReviewToProductPopupController: UIViewController {

    var productId: String?
    var clientId: String?
    
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var commentField: UITextField!
    var r: Double? = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cosmosView.rating = 1
        cosmosView.didFinishTouchingCosmos = { rating in
            self.r = rating
            print(self.r!)
        }
        
        let defaultValues = UserDefaults.standard
        clientId = defaultValues.string(forKey: "user_id")
        print (clientId!)
    }
    

    @IBAction func addReview(_ sender: Any) {
         dismiss(animated: true, completion: nil)
         print(commentField.text!)
    
            let URL = "http://"+Constant.IP_ADDRESS+":11809/reviews/add_review/product"
            let parameters:  [String: Any] = [
                "idProduct": productId!,
                "idClient": clientId!,
                "rating" : self.r!,
                "comment" : commentField.text!
            ]
            addReview(url: URL, parameters: parameters)
}
    
    
    
    func addReview(url: String, parameters:  [String: Any])  {
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseString
            { response in
                print(response)
        }
    }
}
