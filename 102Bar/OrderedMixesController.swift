import UIKit


class OrderedMixesController : UITableViewController{
    
    var orderedMixes: [Mix] = []
    
    override func viewDidLoad() {
        self.refresh()
        tableView.allowsSelection = false
        super.viewDidLoad()
    }
    
    func refresh(){
        Service.shared.getUseres{
            success in
            Service.shared.getOrderedMixes {
                success in
                self.orderedMixes = Service.shared.orderedMixes
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
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
}
