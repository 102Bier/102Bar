import UIKit
import Alamofire

class LoginController: UIViewController {
    
    let dispatchGroup = DispatchGroup()
    
    @IBOutlet weak var _username: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBOutlet weak var _login_button: UIButton!
    @IBOutlet weak var _login_as_guest_button: UIButton!
    @IBOutlet weak var _register_button: UIButton!
    
    let URL_USER_LOGIN = "http://102bier.de/102bar/login.php"
    
    let service = Service()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "username") != nil{
            changeView()
        }
    }
    
    func changeView()
    {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as UIViewController
        present(vc, animated: true, completion: nil)
    }

    @IBAction func LoginButton(_ sender: Any) {
        
        if(_username.text! == "" || _password.text! == ""){
            self.labelMessage.text = "please type in username and password"
            self.labelMessage.isHidden = false
            return
        }
        if(self.service.login(username: _username.text!, password: _password.text!)){
            self.changeView()
        }else{
            //error message in case of invalid credential
            self.labelMessage.text = "Invalid username or password"
        }
        
        
    }
    
    @IBAction func LoginAsGuestButton(_ sender: Any) {
        
    }
    
    @IBAction func RegisterButton(_ sender: Any) {
        
    }
}
