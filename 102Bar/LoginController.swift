import UIKit
import Alamofire
import WatchConnectivity

class LoginController: UIViewController, WCSessionDelegate {
    
    let availableMixesArchiveUrl = { () -> URL in
        let documentsDirectories =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("availableMixes.archive")
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    
    @IBOutlet weak var _username: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBOutlet weak var _login_button: UIButton!
    @IBOutlet weak var _login_as_guest_button: UIButton!
    @IBOutlet weak var _register_button: UIButton!
    
    let defaultValues = UserDefaults.standard
    var session : WCSession = WCSession.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.string(forKey: "username") != nil{ //check if user is logged in
            changeView()
        }
        session.delegate = self
        session.activate()
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
        Service.shared.login(username: self._username.text!, password: self._password.text!){
            success in
            if success!{
                Service.shared.getAvailableIngredients {succsess in
                    Service.shared.getAvailableMixes {succsess in
                        let aD = Service.shared.availableMixes
                        NSKeyedArchiver.setClassName("Mix", for: Mix.self)
                        NSKeyedArchiver.setClassName("Drink", for: Drink.self)
                        NSKeyedArchiver.setClassName("DrinkType", for: DrinkType.self)
                        NSKeyedArchiver.setClassName("DrinkGroup", for: DrinkGroup.self)
                        NSKeyedArchiver.archiveRootObject(aD, toFile: self.availableMixesArchiveUrl().path) //save to file
                        let data = NSKeyedArchiver.archivedData(withRootObject: aD)
                        self.session.sendMessageData(data, replyHandler: nil, errorHandler: nil)
                        //self.session.sendMessage(["aD" : aD], replyHandler: nil, errorHandler: nil)
                        Service.shared.getCustomMixes{success in
                            self.session.sendMessage(["test2" : "tschüss"], replyHandler: nil, errorHandler: nil)
                            self.changeView()
                        }
                    }
                }
            }else{
                 self.labelMessage.text = "Invalid username or password"
            }
        }
        
    }
    
    @IBAction func LoginAsGuestButton(_ sender: Any) {
        Service.shared.loginAsGuest(){ success in
            Service.shared.getAvailableIngredients {succsess in
                Service.shared.getAvailableMixes {succsess in
                    Service.shared.getCustomMixes{success in
                        self.changeView()
                    }
                }
            }
        }
    }
    
    @IBAction func RegisterButton(_ sender: Any) {
        
    }
}
