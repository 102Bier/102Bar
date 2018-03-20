import UIKit
import Alamofire

class RegisterController: UIViewController {
    
    let URL_USER_REGISTER = "http://102bier.de/102bar/register.php"
    
    @IBOutlet weak var _firstname: UITextField!
    @IBOutlet weak var _lastname: UITextField!
    @IBOutlet weak var _username: UITextField!
    @IBOutlet weak var _email: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _confirmPassword: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBAction func RegisterButton(_ sender: Any) {
        
        if(_firstname.text! == "" || _lastname.text! == "" || _username.text == "" || _email.text! == "" || _password.text! == "" || _confirmPassword.text! == ""){
            return
        }
        if(!_password.text!.elementsEqual(_confirmPassword.text!)){
            return
        }
        
        let parameters: Parameters=[
            "username":_username.text!,
            "password":_password.text!,
            "firstname":_firstname.text!,
            "lastname":_lastname.text!,
            "email":_email.text!
        ]
        
        Alamofire.request(URL_USER_REGISTER, method: .post, parameters: parameters).responseJSON(completionHandler:
            {
                response in
                //printing response
                print(response)
                
                //getting the json value from the server
                if let result = response.result.value {
                    
                    //converting it as NSDictionary
                    let jsonData = result as! NSDictionary
                    
                    //displaying the message in label
                    self.labelMessage.text = jsonData.value(forKey: "message") as! String?
                }
        })
    }
    
    @IBAction func CancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

