import UIKit

class DrinkController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segControl: UISegmentedControl!
    
    @IBAction func segSwitched(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
        }
        tableView.reloadData()
    }
    
    
    @IBOutlet var CustomDrinkTable: UITableView!
    
    @IBAction func LogoutTapped(_ sender: Any) {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        //switching to login screen
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginController") as UIViewController
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        print("lol")
    }
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshTable(_:)), for: .valueChanged)
        Service.shared.getCustomMixes {
            success in
            self.tableView.reloadData()
        }
        super.viewDidLoad()
    }
    
    @objc private func refreshTable(_ sender: Any) {
        // Fetch Weather Data
        fetchDrinkData()
    }
    
    func fetchDrinkData()
    {
        switch(segControl.selectedSegmentIndex)
        {
        case 0: Service.shared.getAvailableMixes {
            succsess in self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            //self.activityIndicatorView.stopAnimating()
        }
        case 1: Service.shared.getCustomMixes {
            succsess in self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            //self.activityIndicatorView.stopAnimating()
            }
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if segControl.selectedSegmentIndex == 1 {
            return .delete
        }
        else
        {
            return .none
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredCell") as! ingredCell
        switch(segControl.selectedSegmentIndex)
        {
        case 0: //available Drinks
            cell.mixTitle.text = Service.shared.availableMixes[indexPath.row].mixDescription
            for i in 0..<Service.shared.availableMixes[indexPath.row].ingredients.count
            {
                cell.addOrReplaceLabel(ingredient: Service.shared.availableMixes[indexPath.row].ingredients[i].drinkDescription, yPos: i)
            }
            return cell
            
        case 1: //Custom Drinks
            cell.mixTitle.text = Service.shared.customMixes[indexPath.row].mixDescription
            
            for i in 0..<Service.shared.customMixes[indexPath.row].ingredients.count
            {
                cell.addOrReplaceLabel(ingredient: Service.shared.customMixes[indexPath.row].ingredients[i].drinkDescription, yPos: i)
            }
            return cell
            
        default: break
        }
        return cell
    }
    
    func tableView(_: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if segControl.selectedSegmentIndex == 1 && editingStyle == .delete {
            //remove ingred from data model
            Service.shared.customMix(mixToAdd: Service.shared.customMixes[indexPath.row], add: false){
                success in
            }
            Service.shared.customMixes.remove(at: indexPath.row)
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var mix : Mix;
        switch segControl.selectedSegmentIndex
        {
        case 0: mix = Service.shared.availableMixes[indexPath.row]
        case 1: mix = Service.shared.customMixes[indexPath.row]
        default: return
        }
        let vc: UIViewController = storyboard!.instantiateViewController(withIdentifier: "orderMix")
        (vc as! orderMixController).mixToOrder = mix
        navigationController?.pushViewController(vc, animated: true)
        //Service.shared.orderMix(mixToOrder: mix, add: true) {_ in }
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
            return Service.shared.customMixes.count
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
            return CGFloat(60 + Service.shared.availableMixes[indexPath.row].ingredients.count * 25)
        case 1:
            return CGFloat(60 + Service.shared.customMixes[indexPath.row].ingredients.count * 25)
        default: return 25
        }
    }
}
