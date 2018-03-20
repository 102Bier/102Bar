import UIKit

class DrinkController: UIViewController {
    
    var customDrinkController: UIView!
    var defaultDrinkController: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customDrinkController = CustomDrinkController().view
        defaultDrinkController = DefaultDrinkController().view
    }

    
    @IBAction func LogoutTapped(_ sender: Any) {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        //switching to login screen
        let loginController = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController
        self.navigationController?.pushViewController(loginController, animated: true)
        self.dismiss(animated: false, completion: nil)
        LoginController.loginVar.loginOk = false
    }
    
    
    
    @IBAction func switchView(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            view.bringSubview(toFront: defaultDrinkController)
        case 1:
            view.bringSubview(toFront: customDrinkController)
        default:
            break
        }
    }
}
