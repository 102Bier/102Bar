import UIKit

class DrinkController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segControl: UISegmentedControl!
    
    @IBAction func segSwitched(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //customDrinkController = CustomDrinkController().view
        //defaultDrinkController = DefaultDrinkController().view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredCell") as! ingredCell
        switch(segControl.selectedSegmentIndex)
        {
        case 0: //available Drinks
            cell.mixTitle.text = Service.shared.availableMixes[indexPath.row].mixDescription
            for i in 0..<Service.shared.availableMixes[indexPath.row].ingredients.count
            {
                cell.addLabel(ingredient: Service.shared.availableMixes[indexPath.row].ingredients[i].drinkDescription, yPos: i)
            }
            return cell
            
        case 1: //Custom Drinks
            cell.mixTitle.text = Service.shared.customDrinkModel.customMixes[indexPath.row].mixDescription
            
            for i in 0..<Service.shared.customDrinkModel.customMixes[indexPath.row].ingredients.count
            {
                cell.addLabel(ingredient: Service.shared.customDrinkModel.customMixes[indexPath.row].ingredients[i].drinkDescription, yPos: i)
            }
            return cell
            
        default: break
        }
        return cell
    }
    
    func tableView(_: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //remove ingred from data model
            Service.shared.customDrinkModel.customMixes.remove(at: indexPath.row)
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(segControl.selectedSegmentIndex)
        {
        case 0: //available
            return Service.shared.availableMixes.count
        case 1: //custom
            return Service.shared.customDrinkModel.customMixes.count
        default: return 0
        }
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
        switch(segControl.selectedSegmentIndex)
        {
        case 0:
            if Service.shared.availableMixes.count - 1 > indexPath.row
            {
                return 25
            }
            else
            {
                return CGFloat(60 + Service.shared.availableMixes[indexPath.row].ingredients.count * 25)
            }
        case 1:
            if Service.shared.customDrinkModel.customMixes.count - 1 > indexPath.row
            {
                return 25
            }
            else
            {
                return CGFloat(60 + Service.shared.customDrinkModel.customMixes[indexPath.row].ingredients.count * 25)
            }
        default: return 25
        }
    }
    
    
//    var customDrinkController: UIView!
//    var defaultDrinkController: UIView!
    
    @IBOutlet var CustomDrinkTable: UITableView!
    
    @IBAction func LogoutTapped(_ sender: Any) {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        //switching to login screen
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginController") as UIViewController
        present(vc, animated: true, completion: nil)
    }
}
