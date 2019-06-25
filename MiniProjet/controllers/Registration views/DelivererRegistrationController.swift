
import UIKit
import Alamofire

class DelivererRegistrationController: UIViewController
, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
     let vehicle = ["TWO WHEELS","CAR","TRUCK"]
     var selectedVehicle : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self
        self.picker.dataSource = self
        print(vehicle)
        
    }


    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vehicle.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return vehicle[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedVehicle = vehicle[row]
    }

    @IBAction func signUpAction(_ sender: Any) {
        let URL = "http://"+Constant.IP_ADDRESS+":11809/users/create_deliverer"
        let parameters:  [String: Any] = [
            "first_name": txtFirstName.text!,
            "last_name": txtLastName.text!,
            "phone_number": txtPhone.text!,
            "address": txtAddress.text!,
            "mail": txtEmail.text!,
            "password": txtPassword.text!,
            "vehicle": selectedVehicle
        ]
        
        Alamofire.request(URL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON
            { response in
                print(response)
                let result = response.result.value as! Dictionary<String, Any>
                let defaultValues = UserDefaults.standard
                defaultValues.set(String(describing: result["id"] as! Int), forKey: "user_id")
                print(String(describing: result["id"] as! Int))
                    let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileLivViewController") as! ProfileLivViewController
                    self.navigationController?.pushViewController(homeViewController, animated: true)
                    self.dismiss(animated: false, completion: nil)
         
        }
    }
}
