import UIKit
import Alamofire
import LocalAuthentication

class LoginController: UIViewController {
    
    @IBOutlet weak var _username: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBOutlet weak var _login_button: UIButton!
    @IBOutlet weak var _login_as_guest_button: UIButton!
    @IBOutlet weak var _register_button: UIButton!
    
    @IBOutlet var bier: UIImageView!
    var errorMessage = ""
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)    }
    
    @IBAction func biometricLogin(_ sender: UIButton) {
        checkBiometricLogin()
        checkErrorMessage()
    }
    
    func checkBiometricLogin()
    {
        let context = LAContext()
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil)
        {
            self.evaulateBiometricAuthenticity(context: context)
        }
    }
    
    func evaulateBiometricAuthenticity(context: LAContext)
    {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
        guard !username.isEmpty else {
            let error = LAError(.systemCancel)
            showBiometricLoginError(error)
            return }
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "For a faster login") { (authSuccessful, authError) in
            if authSuccessful {
                let passwordItem = KeychainPasswordItem(service:   KeychainConfiguration.serviceName, account: username, accessGroup: KeychainConfiguration.accessGroup)
                do {
                    let storedPassword = try passwordItem.readPassword()
                    Service.shared.login(username: username, password: storedPassword){
                        success in
                        if success == "A"{
                            Service.shared.getAvailableIngredients {succsess in
                                Service.shared.getAvailableMixes {succsess in
                                    Service.shared.getCustomMixes{success in
                                        self.changeView()
                                    }
                                }
                            }
                        }
                    }
                } catch KeychainPasswordItem.KeychainError.noPassword {
                    let error = LAError(.passcodeNotSet)
                    self.showBiometricLoginError(error)
                } catch {
                    print("Unhandled error")
                }
            } else {
                if let error = authError as? LAError {
                    self.showBiometricLoginError(error)
                }
                
            }
        }
    }
    
    func showBiometricLoginError(_ error : LAError) {
        var message: String = ""
        switch error.code {
        case LAError.authenticationFailed:
            message = "Authentication was not successful because the user failed to provide valid credentials. Please enter password to login."
            break
        case LAError.userCancel:
            message = "Authentication was canceled by the user"
            break
        case LAError.userFallback:
            message = "Authentication was canceled because the user tapped the fallback button"
            break
        case LAError.biometryNotEnrolled:
            message = "Authentication could not start because biometry is not enrolled"
            break
        case LAError.passcodeNotSet:
            message = "Passcode is not set on the device"
            break
        case LAError.systemCancel:
            message = "Authentication was canceled by system, maybe the username is not stored on your device"
            break
        default:
            message = error.localizedDescription
            break
        }
        //self.showPopupWithMessage(message)
        errorMessage = message
        print(message)
    }
    
    func checkErrorMessage()
    {
        if(errorMessage != "")
        {
            labelMessage.text = errorMessage
            errorMessage = ""
        }
    }
    
    func saveAccountDataToUserDefault(username : String, password : String)
    {
        UserDefaults.standard.set(username, forKey: "username")
        do {
            // This is a new account, create a new keychain item with the account name.
            let passwordItem = KeychainPasswordItem(
                service: KeychainConfiguration.serviceName,
                account: username,
                accessGroup: KeychainConfiguration.accessGroup)
            // Save the password for the new item.
            try passwordItem.savePassword(password)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
    }
    
    override func viewDidLoad() {
        bier.frame = CGRect(x: bier.frame.origin.x, y: bier.frame.origin.y, width: view.safeAreaLayoutGuide.layoutFrame.size.width * 0.5 , height: view.safeAreaLayoutGuide.layoutFrame.size.height * 0.25)
        super.viewDidLoad()
        let context = LAContext()
        
        
        
        if let loggedOut = UserDefaults.standard.object(forKey: "loggedOut")
        {
            if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) && (UserDefaults.standard.object(forKey: "hasData") as! Bool) && !(loggedOut as! Bool)
            {
                evaulateBiometricAuthenticity(context: context)
            }
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
        Service.shared.login(username: self._username.text!, password: self._password.text!){
            success in
            if success == "A"{
                
                if !UserDefaults.standard.bool(forKey: "hasData") {
                    self.saveAccountDataToUserDefault(username: self._username.text!, password: self._password.text!)
                   UserDefaults.standard.set(true, forKey: "hasData")
                }
                
                Service.shared.getAvailableIngredients {succsess in
                    Service.shared.getAvailableMixes {succsess in
                        Service.shared.getCustomMixes{success in
                            self.changeView()
                        }
                    }
                }
            }else{
                 self.labelMessage.text = success
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
}
