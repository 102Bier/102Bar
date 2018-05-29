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
            self.saveAccountDataToUserDefault(username: self._username.text!, password: self._password.text!)
            UserDefaults.standard.set(true, forKey: "hasData")
            self.labelMessage.text = success
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func CancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Tap Gesture Recognizer
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
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
}

