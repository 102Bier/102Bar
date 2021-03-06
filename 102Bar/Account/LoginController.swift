import UIKit
import LocalAuthentication

class LoginController: UIViewController {
    
    // MARK: - Varibles
    
    @IBOutlet weak var _username: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBOutlet weak var _login_button: UIButton!
    @IBOutlet weak var _login_as_guest_button: UIButton!
    @IBOutlet weak var _register_button: UIButton!

    var errorMessage = ""
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = LAContext()
        
        if let loggedOut = UserDefaults.standard.object(forKey: "loggedOut") as? Bool
        {
            if let hasData = UserDefaults.standard.object(forKey: "hasData") as? Bool
            {
                if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) && hasData && !loggedOut
                {
                    evaulateBiometricAuthenticity(context: context)
                }
            }
        }
    }
    
    // MARK: - Biometric Login Functions
        
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
        errorMessage = message //error message can't be printed in a non-main thread
        print(message)
    }
    
    func checkErrorMessage() //print error message in the main thread
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
            // new account, create a new keychain item with the account name.
            let passwordItem = KeychainPasswordItem(
                service: KeychainConfiguration.serviceName,
                account: username,
                accessGroup: KeychainConfiguration.accessGroup)
            // save password for the new item.
            try passwordItem.savePassword(password)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
    }
    
    // MARK: - Change View Function
    
    func changeView()
    {
       let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Action Event Functions

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
    
    @IBAction func RegisterButton(_ sender: Any) {
        saveAccountDataToUserDefault(username: _username.text!, password: _password.text!)
        UserDefaults.standard.set(true, forKey: "hasData")
    }
    
    // MARK: - Tap Gesture Recognizer
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
