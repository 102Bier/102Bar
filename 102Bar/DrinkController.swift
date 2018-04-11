import UIKit

class DrinkController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredCell") as! ingredCell
        cell.mixTitle.text = Service.shared.customDrinkModel.customMixes[indexPath.row].mixDescription
        
        for i in 0..<Service.shared.customDrinkModel.customMixes[indexPath.row].ingredients.count
        {
            cell.ingredLabels[i].text = Service.shared.customDrinkModel.customMixes[indexPath.row].ingredients[i].drinkDescription
        }
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Service.shared.customDrinkModel.customMixes.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCustomDrink"
        {
            Service.shared.getAvailableIngredients() {
                sucess in
                let dest = segue.destination.childViewControllers[0] as! AddDrinkController
                dest.reinitDrinkContent()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(35 + Service.shared.customDrinkModel.customMixes[indexPath.row].ingredients.count * 20)
    }
    
    
//    var customDrinkController: UIView!
//    var defaultDrinkController: UIView!
    
    @IBOutlet var CustomDrinkTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //customDrinkController = CustomDrinkController().view
        //defaultDrinkController = DefaultDrinkController().view
    }

    
    @IBAction func LogoutTapped(_ sender: Any) {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        //switching to login screen
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginController") as UIViewController
        present(vc, animated: true, completion: nil)
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addDrink")
        {
            let content = AddDrinkTableContent()
            let target = segue.destination as! AddDrinkController
            target.drinkContent = content
        }
    }*/
    
    /*@IBAction func switchView(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            //view.bringSubview(toFront: defaultDrinkController)
        case 1:
            //view.bringSubview(toFront: customDrinkController)
        default:
            break
        }
    }*/
}
