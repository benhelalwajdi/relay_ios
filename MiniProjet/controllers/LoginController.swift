//
//  LoginController.swift
//  MiniProjet
//
//  Created by Ahlem on 11/11/2018.
//  Copyright © 2018 Ahlem. All rights reserved.
//

import UIKit
import Alamofire

class LoginController: UIViewController {

    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var dataResponse:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func connection(_ sender: Any) {
        login()
    }
    
    func  login () {
        let mail = txtMail.text!;
        let password = txtPassword.text!;
        print(mail)
        print(password)
        
        let URL = "http://"+Constant.IP_ADDRESS+":11809/users/user/" + mail + "/" + password;
        print(URL)
        Alamofire.request(URL)
            .responseJSON{response in
                if(response.result.value! is NSNull){
                    let str = "Please check your Mail or Password and try again." ;
                    let alert = UIAlertController(title: "Oups", message: str, preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

                }else {                    
                    let result = response.result.value as! Dictionary<String, Any>
                    let defaultValues = UserDefaults.standard
                    defaultValues.set(String(describing: result["id"] as! Int), forKey: "user_id")
                    print(String(describing: result["id"] as! Int))
                    print(result["user_type"] as! String)
                    if (result["user_type"] as! String == "CLIENT"){
                        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeController") as!
                            HomeController
                        self.navigationController?.pushViewController(homeViewController, animated: true)
                        self.dismiss(animated: false, completion: nil)
                    }else if (result["user_type"] as! String == "DELIVERER"){
                        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileLivViewController") as! ProfileLivViewController
                        self.navigationController?.pushViewController(homeViewController, animated: true)
                        self.dismiss(animated: false, completion: nil)
                    }else if (result["user_type"] as! String == "STORE"){
                        print("I am in the store test")
                        let LoginController = self.storyboard?.instantiateViewController(withIdentifier: "LoginController")
                        let ProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")
                        self.navigationController?.pushViewController(ProfileViewController!, animated: true)
                    }
                }
        }
    }
}
