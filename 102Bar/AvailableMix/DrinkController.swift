import UIKit

class DrinkController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Variables
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segControl: UISegmentedControl!
    @IBOutlet var CustomDrinkTable: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    // MARK: - ViewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDrinkData()
        tableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        if(!Service.shared.hasUserRight(right: Service.Rights.canCreateOwn.rawValue)){
            self.navigationItem.setRightBarButton(nil, animated: true)
            segControl.isHidden = true
        }
        tableView.allowsSelection = Service.shared.hasUserRight(right: Service.Rights.canOrder.rawValue)
        
        segControl.layer.borderWidth = 1
        segControl.layer.cornerRadius = 4.0
    }
    
    // MARK: - Action Event Functions
    
    @IBAction func segSwitched(_ sender: UISegmentedControl) { //switch for custom/default mixes
        if sender.selectedSegmentIndex == 0 {
        }
        tableView.reloadData()
    }
    
    @IBAction func LogoutTapped(_ sender: Any) {
        
        Service.shared.logout()
        
        //switching to login screen
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginController") as UIViewController
        present(vc, animated: true, completion: nil)
    }
    
    @objc func orderTapped() {
        if let vc = navigationController?.topViewController
        {
            (vc as! OrderMixController).orderTapped()
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Refresh Table Functions
    
    @objc private func refreshTable(_ sender: Any) {
        fetchDrinkData()
    }
    
    func fetchDrinkData()
    {
        switch(segControl.selectedSegmentIndex)
        {
        case 0: Service.shared.getAvailableMixes {
            succsess in self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        case 1: Service.shared.getCustomMixes {
            succsess in self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            }
        default: break
        }
    }
    
    // MARK: - Init Table View Functions
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        // removing of custom mixes is possible, default mixes not
        if segControl.selectedSegmentIndex == 1 {
            return .delete
        }
        else
        {
            return .none
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mixCell") as! MixCell
        switch(segControl.selectedSegmentIndex)
        {
        case 0: //available mixes
            cell.mixTitle.text = Service.shared.availableMixes[indexPath.row].mixDescription
            for i in 0..<Service.shared.availableMixes[indexPath.row].ingredients.count
            {
                cell.addOrReplaceLabel(ingredient: Service.shared.availableMixes[indexPath.row].ingredients[i].drinkDescription, yPos: i)
            }
            
            if Service.shared.availableMixes[indexPath.row].ingredients.contains(where: {$0.drinkType.drinkGroup.alcoholic == true})
            {
                cell.alcoholicLabel.text = "alcoholic"
            }
            else
            {
                cell.alcoholicLabel.text = "non alcoholic"
            }
            return cell
            
        case 1: //custom mixes
            cell.mixTitle.text = Service.shared.customUserMixes[indexPath.row].mixDescription
            
            for i in 0..<Service.shared.customUserMixes[indexPath.row].ingredients.count
            {
                cell.addOrReplaceLabel(ingredient: Service.shared.customUserMixes[indexPath.row].ingredients[i].drinkDescription, yPos: i)
            }
            
            if Service.shared.customUserMixes[indexPath.row].ingredients.contains(where: {$0.drinkType.drinkGroup.alcoholic == true})
            {
                cell.alcoholicLabel.text = "alcoholic"
            }
            else
            {
                cell.alcoholicLabel.text = "non alcoholic"
            }
            return cell
            
        default: break
        }
        return cell
    }
    
    func tableView(_: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if segControl.selectedSegmentIndex == 1 && editingStyle == .delete {
            //remove ingredient from data model
            Service.shared.customMix(mixToAdd: Service.shared.customUserMixes[indexPath.row], add: false){
                success in
            }
            Service.shared.customUserMixes.remove(at: indexPath.row)
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var mix : Mix;
        switch segControl.selectedSegmentIndex
        {
            case 0: mix = Service.shared.availableMixes[indexPath.row]
            case 1: mix = Service.shared.customUserMixes[indexPath.row]
            default: return
        }
        let vc: UIViewController = storyboard!.instantiateViewController(withIdentifier: "orderMix")
        
        let order = UIBarButtonItem(title: "Order", style: .plain, target: self, action: #selector(orderTapped))
        order.style = .done
        vc.navigationItem.rightBarButtonItem = order
        vc.navigationItem.title = "Order " + mix.mixDescription
        (vc as! OrderMixController).mixToOrder = mix
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(segControl.selectedSegmentIndex)
        {
        case 0: //available
            return Service.shared.availableMixes.count
        case 1: //custom
            return Service.shared.customUserMixes.count
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
            return CGFloat(60 + Service.shared.customUserMixes[indexPath.row].ingredients.count * 25)
        default: return 25
        }
    }
}
