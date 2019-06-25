//
//  ClientRegistrationControllerController.swift
//  MiniProjet
//
//  Created by Ahlem on 18/01/2019.
//  Copyright © 2019 Ahlem. All rights reserved.
//

import UIKit
import Alamofire

class ClientRegistrationControllerController: UIViewController {

    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!

    var dataResponse:NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signUpAction(_ sender: Any) {
        let URL = "http://"+Constant.IP_ADDRESS+":11809/users/create_client"
        let parameters:  [String: Any] = [
            "first_name": txtFirstName.text!,
            "last_name": txtLastName.text!,
            "phone_number": txtPhone.text!,
            "address": txtAddress.text!,
            "mail": txtEmail.text!,
            "password": txtPassword.text!
        ]
        
        Alamofire.request(URL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON
            { response in
                let result = response.result.value as! Dictionary<String, Any>
                let defaultValues = UserDefaults.standard
                defaultValues.set(String(describing: result["id"] as! Int), forKey: "user_id")
                print(String(describing: result["id"] as! Int))
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeController") as! HomeController
                    self.navigationController?.pushViewController(homeViewController, animated: true)
                    self.dismiss(animated: false, completion: nil)
                
        

        }
    }
    
}
