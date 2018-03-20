import UIKit
import Alamofire

class LoginController: UIViewController {
    
    var loginOk = false
    
    @IBOutlet weak var _username: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBOutlet weak var _login_button: UIButton!
    @IBOutlet weak var _login_as_guest_button: UIButton!
    @IBOutlet weak var _register_button: UIButton!
    
    let URL_USER_LOGIN = "http://102bier.de/102bar/login.php"
    
    let defaultValues = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaultValues.string(forKey: "username") != nil{
            let drinkController = self.storyboard?.instantiateViewController(withIdentifier: "DrinkController") as! DrinkController
            self.navigationController?.pushViewController(drinkController, animated: true)
            
        }
    }
    
   override func shouldPerformSegue(withIdentifier identifier: String,
                                     sender: Any!) -> Bool {
        
        if identifier == "login" {
            return loginOk
        }
        return true
        
    }
    
    @IBAction func LoginButton(_ sender: Any) {
        
        if(_username.text! == "" || _password.text! == ""){
            self.labelMessage.text = "please type in username and password"
            self.labelMessage.isHidden = false
            return
        }
        
        let parameters: Parameters=[
            "username":_username.text!,
            "password":_password.text!
        ]
        
        Alamofire.request(URL_USER_LOGIN, method: .post, parameters: parameters).responseJSON
            {
                response in
                
                print(response)
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    //if there is no error
                    if(!(jsonData.value(forKey: "error") as! Bool)){
                        
                        //getting the user from response
                        let user = jsonData.value(forKey: "user") as! NSDictionary
                        
                        //getting user values
                        let userId = user.value(forKey: "id") as! Int
                        let userName = user.value(forKey: "username") as! String
                        let userFirstname = user.value(forKey: "firstname") as! String
                        let userLastname = user.value(forKey: "lastname") as! String
                        let userEmail = user.value(forKey: "email") as! String
                        
                        //saving user values to defaults
                        self.defaultValues.set(userId, forKey: "userid")
                        self.defaultValues.set(userName, forKey: "username")
                        self.defaultValues.set(userEmail, forKey: "useremail")
                        self.defaultValues.set(userFirstname, forKey: "userfirstname")
                        self.defaultValues.set(userLastname, forKey: "userlastname")
                        
                        self.loginOk = true
                        
                        
                        //switching the screen
                        //let drinkController = self.storyboard?.instantiateViewController(withIdentifier: "DrinkController") as! DrinkController
                        //self.navigationController?.pushViewController(drinkController, animated: true)
                        
                        //self.dismiss(animated: false, completion: nil)
                    }else{
                        //error message in case of invalid credential
                        self.loginOk = false
                        self.labelMessage.text = "Invalid username or password"
                        self.labelMessage.isHidden = false
                    }
                }
        }
    }
    
    @IBAction func LoginAsGuestButton(_ sender: Any) {
        
    }
    
    @IBAction func RegisterButton(_ sender: Any) {
        
    }
    
}
