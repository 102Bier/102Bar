import UIKit


class OrderedMixesController : UITableViewController{
    
    var orderedMixes: [Mix] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Service.shared.getOrderedMixes{
            success in
            self.orderedMixes = Service.shared.orderedMixes
            super.viewWillAppear(animated)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "OrderedMixTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? OrderedMixTableViewCell  else {
            fatalError("The dequeued cell is not an instance of OrderedMixTableViewCell.")
        }
        let orderedMix = orderedMixes[indexPath.row]
        cell.MixDescriptionLabel.text = orderedMix.mixDescription
        cell.orderedMix = orderedMix
        var ingredients: String = "Ingredients:"
        for ing in orderedMix.ingredients{
            ingredients += "\n\(ing.toString())"
        }
        cell.IngredientsLabel.text = ingredients
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedMixes.count
    }
}
