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
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginController") as UIViewController
        present(vc, animated: true, completion: nil)
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
