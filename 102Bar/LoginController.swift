import UIKit
import Alamofire

class LoginController: UIViewController {
    
    @IBOutlet weak var _username: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBOutlet weak var _login_button: UIButton!
    @IBOutlet weak var _login_as_guest_button: UIButton!
    @IBOutlet weak var _register_button: UIButton!
    
    let defaultValues = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.string(forKey: "username") != nil{
            changeView()
        }
    }
    
    func changeView()
    {
       let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
        present(vc, animated: true, completion: nil)
    }

    @IBAction func LoginButton(_ sender: Any) {
        
        if(_username.text! == "" || _password.text! == ""){
            self.labelMessage.text = "please type in username and password"
            self.labelMessage.isHidden = false
            return
        }
        Service.shared.login(loginController: self, username: _username.text!, password: _password.text!)
    }
    
    @IBAction func LoginAsGuestButton(_ sender: Any) {
        Service.shared.loginAsGuest(loginController: self)
    }
    
    @IBAction func RegisterButton(_ sender: Any) {
        
    }
}
