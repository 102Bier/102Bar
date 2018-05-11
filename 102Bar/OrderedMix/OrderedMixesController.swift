import UIKit

class OrderedMixesController : UITableViewController{
    
    // MARK: - Variables
    
    var orderedMixes: [Mix] = []
    let reloadControl = UIRefreshControl()
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        self.refresh(nil)
        //tableView.isUserInteractionEnabled = false
        tableView.allowsSelection = true
        if #available(iOS 10.0, *) {
            tableView.refreshControl = reloadControl
        } else {
            tableView.addSubview(reloadControl)
        }
        reloadControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        super.viewDidLoad()
    }
    
    // MARK: - Refresh Function
    
    @objc func refresh(_ sender: Any?){
        Service.shared.getUseres{
            success in
            Service.shared.getCustomMixes{
                succes in
                Service.shared.getOrderedMixes {
                    success in
                    self.orderedMixes = Service.shared.orderedMixes
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    // MARK: - Initialize Table View Functions
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "OrderedMixTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? OrderedMixTableViewCell  else {
            fatalError("The dequeued cell is not an instance of OrderedMixTableViewCell.")
        }
        cell.controller = self
        let orderedMix = orderedMixes[indexPath.row]
        cell.MixDescriptionLabel.text = orderedMix.mixDescription
        cell.orderedMix = orderedMix
        var ingredients: String = "Ingredients:"
        for ing in orderedMix.ingredients{
            ingredients += "\n\(ing.toString())"
        }
        if let user = Service.shared.users.first(where: {$0.user == orderedMixes[indexPath.row].orderedByUser}){
            cell.UsernameLabel.text = "Ordered by: " + user.username
        }else{
            cell.UsernameLabel.text = "Ordered by: Guest"
        }
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedMixes.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mix = orderedMixes[indexPath.row]
        let vc: UIViewController = storyboard!.instantiateViewController(withIdentifier: "orderMix")
        
        vc.navigationItem.title = mix.mixDescription
        (vc as! OrderMixController).mixToOrder = mix
        (vc as! OrderMixController).orderMode = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Action Event Functions
    
    @IBAction func LogoutButton(_ sender: Any) {
        
        Service.shared.logout()
        
        //switching to login screen
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginController") as UIViewController
        present(vc, animated: true, completion: nil)
    }
}
