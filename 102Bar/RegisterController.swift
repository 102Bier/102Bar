import UIKit
import Alamofire

class RegisterController: UIViewController {
    
    @IBOutlet weak var _firstname: UITextField!
    @IBOutlet weak var _lastname: UITextField!
    @IBOutlet weak var _username: UITextField!
    @IBOutlet weak var _email: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _confirmPassword: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    
    let service = Service()
    
    @IBAction func RegisterButton(_ sender: UIButton) {
        
        if(_firstname.text! == "" || _lastname.text! == "" || _username.text == "" || _email.text! == "" || _password.text! == "" || _confirmPassword.text! == ""){
            labelMessage.text = "Fill in all fields!"
            return
        }
        
        if(!_password.text!.elementsEqual(_confirmPassword.text!)){
            labelMessage.text = "Passwords are not equal"
            return
        }
        
        self.service.register(username: _username.text!, firstname: _firstname.text!, lastname: _lastname.text!, email: _email.text!, password: _password.text!){
            success in
            self.labelMessage.text = success
        }
    }
    
    @IBAction func CancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

