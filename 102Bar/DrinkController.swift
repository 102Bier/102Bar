import UIKit

class DrinkController: UIViewController {
    
    @IBOutlet weak var NavBar: UINavigationBar!
    var customDrinkController: UIView!
    var defaultDrinkController: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bringSubview(toFront: NavBar)
        
        customDrinkController = CustomDrinkController().view
        defaultDrinkController = DefaultDrinkController().view
    }

    @IBAction func LogoutButton(_ sender: Any) {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        //switching to login screen
        let loginController = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController
        self.navigationController?.pushViewController(loginController, animated: true)
        self.dismiss(animated: false, completion: nil)
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
