import UIKit


class OrderedMixesController : UITableViewController{
    
    var orderedMixes: [Mix] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        Service.shared.getOrderedMixes{
            success in
            self.orderedMixes = Service.shared.orderedMixes
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
