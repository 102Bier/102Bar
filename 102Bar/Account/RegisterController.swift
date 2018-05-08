import UIKit

class RegisterController: UIViewController {
    
    // MARK: - Variables
    
    @IBOutlet weak var _firstname: UITextField!
    @IBOutlet weak var _lastname: UITextField!
    @IBOutlet weak var _username: UITextField!
    @IBOutlet weak var _email: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _confirmPassword: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Action Event Functions
    
    @IBAction func RegisterButton(_ sender: UIButton) {
        
        if(_firstname.text! == "" || _lastname.text! == "" || _username.text == "" || _email.text! == "" || _password.text! == "" || _confirmPassword.text! == ""){
            labelMessage.text = "Fill in all fields!"
            return
        }
        
        if(!_password.text!.elementsEqual(_confirmPassword.text!)){
            labelMessage.text = "Passwords are not equal"
            return
        }
        
        Service.shared.register(username: _username.text!, firstname: _firstname.text!, lastname: _lastname.text!, email: _email.text!, password: _password.text!){
            success in
            self.labelMessage.text = success
        }
    }
    
    @IBAction func CancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Tap Gesture Recognizer
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

