//
//  StoreRegistrationController.swift
//  MiniProjet
//
//  Created by Ahlem on 18/01/2019.
//  Copyright © 2019 Ahlem. All rights reserved.
//

import UIKit
import Alamofire

class StoreRegistrationController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var txtStoreName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    let categories = [  "Supermarket", "Clothing", "Electronics", "Books, Movies, Music & Games", "Cosmetics & Body care",
                        "Food & Drinks", "Bags & Accessories", "Household appliances",
                        "Furniture & Household goods", "Sports & Outdoor", "Toys & Baby products",
                        "Stationary & Hobby supplies", "Garden & Pets", "Other"]
    var selectedCategory : String = ""

    override func viewDidLoad() {
        self.picker.delegate = self
        self.picker.dataSource = self
        super.viewDidLoad()

    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categories[row]
    }

    @IBAction func signUpAction(_ sender: Any) {
        let URL = "http://"+Constant.IP_ADDRESS+":11809/users/create_store"
        let parameters:  [String: Any] = [
            "store_type": selectedCategory,
            "store_name": txtStoreName.text!,
            "phone_number": txtPhone.text!,
            "address": txtAddress.text!,
            "mail": txtEmail.text!,
            "password": txtPassword.text!
        ]
        
        Alamofire.request(URL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON
            { response in
                print(response)
                let result = response.result.value as! Dictionary<String, Any>
                let defaultValues = UserDefaults.standard
                defaultValues.set(String(describing: result["id"] as! Int), forKey: "user_id")
                print(String(describing: result["id"] as! Int))
                 let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                    self.navigationController?.pushViewController(homeViewController, animated: true)
                    self.dismiss(animated: false, completion: nil)
                
        
        }
    }
}
